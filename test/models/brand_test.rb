# == Schema Information
#
# Table name: brands
#
#  id         :integer          not null, primary key
#  country_id :integer
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class BrandTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
