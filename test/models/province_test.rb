# == Schema Information
#
# Table name: provinces
#
#  id         :integer          not null, primary key
#  country_id :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ProvinceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
