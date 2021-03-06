# == Schema Information
#
# Table name: billing_infos
#
#  id           :integer          not null, primary key
#  cardnumber   :string(255)
#  cardname     :string(255)
#  expiration   :date
#  securitycode :string(255)
#  address_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'creditcard'

class BillingInfo < ActiveRecord::Base
  attr_accessible :cardtype, :cardname, :cardnumber, :expiration, :securitycode, :address_attributes
  belongs_to :address
  has_one :user
  accepts_nested_attributes_for :address

  def incomplete?
    return cardtype.nil? || cardtype.empty? || cardname.nil? || cardname.empty? || cardnumber.nil? || cardnumber.empty? || expiration.nil? || expiration.empty? || securitycode.nil? || securitycode.empty? || address.nil? || address.incomplete?
  end
end
