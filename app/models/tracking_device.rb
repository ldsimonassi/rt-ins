class TrackingDevice < ActiveRecord::Base
  belongs_to :device_model
  has_many :device_tracks
  has_many :device_locations
  has_many :alerts
  has_many :vehicles
end
