# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  cost        :decimal(, )
#  description :string(255)
#  stock       :integer
#  url         :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Item < ActiveRecord::Base
  has_many :quantities
  has_many :promos
  attr_accessible :name, :cost, :description, :category, :stock, :url
end
