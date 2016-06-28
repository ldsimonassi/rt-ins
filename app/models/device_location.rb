class DeviceLocation < ActiveRecord::Base
  belongs_to :tracking_device
  belongs_to :driver
end
