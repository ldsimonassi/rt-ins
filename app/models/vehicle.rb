class Vehicle < ActiveRecord::Base
  belongs_to :price
  belongs_to :user
  belongs_to :country

  before_save :set_country

  def set_country  
  	self.country = price.version.model.brand.country
  	true
  end

end
