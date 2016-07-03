class Alert < ActiveRecord::Base
  belongs_to :tracking_device
  belongs_to :driver
  belongs_to :alert_type
end
