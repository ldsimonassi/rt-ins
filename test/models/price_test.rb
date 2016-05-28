# == Schema Information
#
# Table name: prices
#
#  id         :integer          not null, primary key
#  version_id :integer
#  year       :integer
#  currency   :string
#  price      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class PriceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
