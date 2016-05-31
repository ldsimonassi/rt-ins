# == Schema Information
#
# Table name: models
#
#  id         :integer          not null, primary key
#  name       :string
#  brand_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Model < ActiveRecord::Base
  belongs_to :brand
  has_many :versions

  validates :name, presence: true
  validates :brand, presence:true
end
