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

class Brand < ActiveRecord::Base
	has_many :models
	belongs_to :country
end
