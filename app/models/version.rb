class Version < ActiveRecord::Base
  belongs_to :model

  validates :name, presence: true
end
