# == Schema Information
#
# Table name: prices
#
#  id         :integer          not null, primary key
#  version_id :integer
#  year       :integer
#  currency   :string
#  price      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Price < ActiveRecord::Base
  belongs_to :version

  def name
  	"#{year}: #{currency}#{price}"
  end
end
