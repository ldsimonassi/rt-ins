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

class Province < ActiveRecord::Base
  belongs_to :country
  has_many :cities
end
