class Brand < ActiveRecord::Base
	has_many :models

	validates :name, presence: true, uniqueness: { case_sensitive: false }
end
