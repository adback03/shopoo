# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  firstname          :string(255)
#  lastname           :string(255)
#  encrypted_password :string(255)
#  email              :string(255)
#  billing_info_id    :integer
#  address_id         :integer
#  cart_id            :integer
#  admin              :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  salt               :string(255)
#

require 'digest'

class User < ActiveRecord::Base
  # virtual attribute - not in database. It only exists in memory until encrypted
  attr_accessor :password
  attr_accessible :email, :firstname, :lastname, :password, :password_confirmation, :address_attributes
  belongs_to :billing_info
  belongs_to :address
  has_many :carts
  accepts_nested_attributes_for :address

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :firstname, :presence    => true,
                        :length      => { :maximum => 50 }
  validates :lastname,  :presence    => true,
                        :length      => { :maximum => 50 }
  validates :email,     :presence    => true,
                        :format      => { :with => email_regex },
                        :uniqueness  => { :case_sensitive => false }
  validates :password,  :presence    => true,
                        :confirmation => true,
                        :length      => { :within => 6..40 }

  # active record will call this before saving the model
  before_save :encrypt_password

  # returns true if the user's password is the same as the one submitted
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def cart
    return Cart.find_by_user_id_and_order_date(self.id,nil)
  end

  def checkout
    #Gets the old cart and checks it out
    @oc = cart
    @oc.checkout
    #Creates a new empty cart for the user
    @c = Cart.new
    @c.user = self
    @c.save
  end

  def orders
    return Cart.find_all_by_user_id(self.id, :conditions => ["order_date IS NOT NULL"])
  end

  #make all methods below private
  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
