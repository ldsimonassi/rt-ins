# == Schema Information
#
# Table name: versions
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  model_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Version < ActiveRecord::Base
  belongs_to :model
  has_many :prices

  validates :name, presence: true
end
