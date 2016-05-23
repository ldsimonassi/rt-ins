class Model < ActiveRecord::Base
  belongs_to :brand
  has_many :versions

  validates :name, presence: true
end
