class TrackingDevice < ActiveRecord::Base
  belongs_to :device_model
  has_many :device_tracks
  has_many :device_locations
end
