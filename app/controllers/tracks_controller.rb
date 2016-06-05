class TracksController < ApplicationController
	protect_from_forgery except: :create

# curl -X POST -H "Content-Type: application/json" -d @sample_track.json http://localhost:3000/tracks
# POST Example
# {	
# 	"serial_no": "AAAA19",
# 	"data": [
# 		{
# 			"period": "20160701234000",
# 			"speed": {
# 				"max": 100,
# 				"avg": 80,
# 				"min": 50,
# 				"p75": 90,
# 				"p25": 55
# 			},
# 			"acceleration": {
# 				"up": 0.1,
# 				"down": 0.3,
# 				"forward": 0.4,
# 				"backward": 0.1
# 			},
# 			"locations": 
# 				[
# 					{"lat": 22.1231, "long": 44.23243},
# 					{"lat": 22.1231, "long": 44.23243},
# 					{"lat": 22.1231, "long": 44.23243},
# 					{"lat": 22.1231, "long": 44.23243},
# 					{"lat": 22.1231, "long": 44.23243},
# 					{"lat": 22.1231, "long": 44.23243}
# 				]
# 		}
# 	]
# }


	def create
		serial = params['serial_no']
		device = TrackingDevice.find_by_serial_no(serial)

		data = params['data']

		data.each do |track|
			period = track[:period]
			speed = track[:speed]
			locations = track[:locations]

			acceleration = track[:acceleration]
			track = DeviceTrack.create(tracking_device: device,
										period: period,
										speed_max: speed[:max],
										speed_p75: speed[:p75],
										speed_avg: speed[:avg],
										speed_p25: speed[:p25],
										speed_min: speed[:min],
										acceleration_up: acceleration[:up],
										acceleration_down: acceleration[:down],
										acceleration_forward: acceleration[:forward],
										acceleration_backward: acceleration[:backward])

			i = 0
			locations.each do |location|
				latitude = location['lat']
				longitude = location['long']
				location_period = "#{period}#{i}0"

				location_track = DeviceLocation.create(tracking_device: device, period:location_period, latitude: latitude, longitude:longitude)

				i += 1
			end

			render nothing:true
		end
	end
end
