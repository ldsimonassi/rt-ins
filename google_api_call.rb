require 'rest-client'
require 'json'
require 'byebug'
require 'typhoeus'
require 'oj'
require 'future'
require 'open-uri'
require 'byebug'







def get_url_json(url)

	max_http = 2
	max_timeouts = 10
	response = nil
	success = false
	loop do
		response = Typhoeus.get(url, timeout: 5, connecttimeout:5)

		if response.success?
			break
		elsif response.timed_out? || response.code == 0
			puts "Timeout or no code #{url} #{max_timeouts}"
			max_timeouts = max_timeouts - 1
			sleep 2
		else
			puts "HTTP error code for #{url} was #{response.code.to_s} #{max_http}"
			max_http = max_http - 1
		end
	
		if max_http == 0 || max_timeouts==0
			$stderr.puts "Maxerrors achieved for #{url} HTTP:#{max_http} TO:#{max_timeouts}" 
			return nil
		end
	end
	Oj.load(response.body)
end

destination = URI::encode("Av. Cordoba 374, CABA")
origin = URI::encode("-34.573,-58.4801")

apikey = URI::encode("AIzaSyAZwWhYZlrvNvZYnZ-hx3egf-DDemQsLGs")

url = "https://maps.googleapis.com/maps/api/directions/json?origin=#{origin}&destination=#{destination}&key=#{apikey}"
puts "[#{url}]"
ret = get_url_json(url)

r=0


ret['start']
ret['routes'].each do | route |
	puts "Route #{r}"
	l =0 
	route['legs'].each do | leg |
		puts "\t#{r} -> #{l}"
		distance = leg['distance']['value']
		duration = leg['duration']['value']
		puts "\tDistance #{distance} meters"
		puts "\tTime #{duration} seconds"
		s = 0
		leg['steps'].each do |step|
			s_distance = step['distance']['value']
			s_time = step['duration']['value']

			ss_lat = step['start_location']['lat']
			ss_lng = step['start_location']['lng']
			sf_lat = step['end_location']['lat']
			sf_lng = step['end_location']['lng']

			puts "\t\tS#{s})Start:(#{ss_lat}, #{ss_lng})"
			puts "\t\tS#{s})End:(#{sf_lat}, #{sf_lng})"
			puts "\t\tS#{s})Time:#{s_time}"
			puts "\t\tS#{s})Dist:#{s_distance}"

			puts ""
			s += 1
		end
		l += 1
	end
	r += 1
end

# geocoded_waypoints
# routes
# 	bounds
# 	copyrights
# 	legs
# 		distance
# 		duration
# 		end_address
# 		end_location
# 		start_address
# 		start_location
# 		steps
# 		traffic_speed_entry
# 		via_waypoint
# 	overview_polyline
# 	summary
# 	warnings
# 	waypoint_order
# status





