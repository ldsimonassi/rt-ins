class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :city

  validates :street, presence: true, length: { minumum: 3, maximum: 35 }
  validates :name, presence:true, length: { minumum: 1, maximum: 15 }
  validates :number, presence:true, length: { minumum: 1, maximum: 15 }
  validates :zip_code, presence:true, length: { minumum: 1, maximum: 10 }
end