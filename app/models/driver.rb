class Driver < ActiveRecord::Base
	belongs_to :user
	has_many :device_tracks
	has_many :alerts
end