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

require 'test_helper'

class BillingInfoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
