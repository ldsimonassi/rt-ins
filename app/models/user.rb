# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  email           :string           not null
#  first_name      :string           not null
#  last_name       :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  belongs_to :country
  has_many :addresses
  has_many :vehicles
  has_many :drivers

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :username, presence: true, length: { maximum: 15 }, uniqueness: { case_sensitive: false }
  
  validates :first_name, presence:true, length: { maximum: 25, minimum: 3 }
  validates :last_name, presence:true, length: { maximum: 35, minimum: 3 }

  before_save do
    self.email = email.downcase
    self.username = username.downcase 
  end 

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
