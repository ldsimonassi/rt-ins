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

origin = URI::encode("Av. Olazabal 4545, CABA")
destination = URI::encode("Arias 3751, CABA")

apikey = URI::encode("AIzaSyAZwWhYZlrvNvZYnZ-hx3egf-DDemQsLGs")

url = "https://maps.googleapis.com/maps/api/directions/json?origin=#{origin}&destination=#{destination}&key=#{apikey}"
puts "[#{url}]"
ret = get_url_json(url)

r=0

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
			s_lat = step['end_location']['lat']
			s_long = step['end_location']['lng']

			puts "\t\tS#{s})Lat:#{s_lat}"
			puts "\t\tS#{s})Lon:#{s_long}"
			puts "\t\tS#{s})Time:#{s_time}"
			puts "\t\tS#{s})Dist:#{s_distance}"
			puts ""
			s += 1
		end
		l += 1
	end
	r += 1
end
