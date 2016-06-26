require 'rest-client'
require 'json'
require 'byebug'
require 'typhoeus'
require 'oj'
require 'future'

interrupted = false
trap 'INT' do
  exit Signal.list["INT"] if interrupted
  interrupted = true
  if RUBY_VERSION =~ /^1\.8\./
    STDERR.puts "Current thread: #{Thread.inspect}"
    STDERR.puts caller.join("\n    \\_ ")  
  else
    Thread.list.each do |thread|
      STDERR.puts "Thread-#{thread.object_id.to_s(36)}"
      STDERR.puts thread.backtrace.join("\n    \\_ ")
    end
  end
  puts "Press Ctrl+C again to exit..."
  sleep 1
  interrupted = false
end

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

def iterate_map(url, field)
	ret = Hash.new
	iterable = get_url_json(url)
	if iterable.nil?
		return ret
	end

	if field != nil 
		iterable = iterable[field]
	end

	futures = Array.new
	
	iterable.each do |element|
		k, v = future { yield(element) }
		ret[k] = v
	end
	ret
end


def iterate_array(url, field)
	ret = Array.new
	iterable = get_url_json(url)

	if iterable.nil?
		return ret
	end
	
	if field != nil 
		iterable = iterable[field]
	end


	iterable.each do |element|
		ret << yield(element)
	end
	ret
end

def iterate_map_parallel(url, field)
	ret = Hash.new
	iterable = get_url_json(url)
	
	if iterable.nil?
		return ret
	end
	
	if field != nil 
		iterable = iterable[field]
	end

	futures = Array.new


	iterable.each do |element|
		futures << future { yield(element) }
	end

	futures.each do |future|
		k, v = future
		ret[k] = v
	end
	ret
end


def iterate_array_parallel(url, field)
	ret = Array.new
	iterable = get_url_json(url)

	if iterable.nil?
		return ret
	end
	
	if field != nil 
		iterable = iterable[field]
	end

	iterable.each do |element|
		ret << future { yield(element) }
	end
	ret
end


def iterate_typhoeus(url, field, &operation)
	fails = 0
	max_fails = 15
	response = nil
	success = false
	loop do
		response = Typhoeus.get(url, timeout: 5, connecttimeout:2)

		if response.success?
			break
		elsif response.timed_out?
			$stderr.puts "Timeout #{url} retrying #{fails} of #{max_fails}"
			sleep 10
		elsif response.code == 0
			$stderr.puts "No HTTP error code message: ${response.return_message} for #{url} retrying #{fails} of #{max_fails} "
		else
			$stderr.puts "HTTP error code for #{url} was #{response.code.to_s} retrying #{fails} of #{max_fails}"
		end
		fails = fails + 1
		if fails >= 15
			$stderr.puts "#{url}"
			return
		end
	end

	iterable = Oj.load(response.body)
	if field!=nil
		iterable = iterable[field]
	end
	iterable.each &operation
end

def get_countries
	countries = iterate_map 'https://api.mercadolibre.com/countries', nil do |country|
		name = country['name']
		id = country['id']
		if ['AR', 'BR', 'VE', 'CO', 'MX'].include? id
		#if ['CO'].include? id
			ret = Hash.new
			ret['brands'] = get_brands id, name
			ret['states'] = get_states id, name

			next name, ret
		else
			puts "Discarding country #{name}"
		end
	end
	countries
end

def get_states(country_id, country_name)
	puts "Getting states of #{country_id}:#{country_name}"
	states = iterate_map "https://api.mercadolibre.com/countries/#{country_id}", 'states' do |state|
		name = state['name']
		id = state['id']
		ret = Hash.new
		ret['cities'] = get_cities id, name
		next name, ret
	end
	states
end

def get_cities(state_id, state_name)
	puts "\tGetting cities of #{state_id}:#{state_name}"
	cities = iterate_array "https://api.mercadolibre.com/states/#{state_id}", 'cities' do |city|
		name = city['name']
		id = city['id']
		next name
	end
	cities	
end

def get_brands(country_id, country_name)
	puts "Getting brands for #{country_id}:#{country_name}"
	categories = {
		'AR' => 'MLA1744',
		'BR' => 'MLB1744',
		'VE' => 'MLV1744',
		'CO' => 'MCO1744', 
		'MX' => 'MLM1744'
	}
	brands = iterate_map_parallel "https://api.mercadolibre.com/motors_prices/#{categories[country_id]}/brands", 'brands' do |brand|
		name = brand['name']
		id = brand['id']
		next name, get_models(id, name)
	end	
	brands	
end

def get_models(brand_id, brand_name)
	puts "\tGetting models for brand #{brand_id}:#{brand_name}"
	models = iterate_map "https://api.mercadolibre.com/motors_prices/#{brand_id}/models", 'models' do |model|
		name = model['name']
		id = model['id']
		next name, get_versions(id, name)
	end
	models
end

def get_versions(model_id, model_name)
	puts "\t\tGetting version for model #{model_id}:#{model_name}"
	versions = iterate_map "https://api.mercadolibre.com/motors_prices/#{model_id}/versions", 'versions' do |version|
		name = version['name']
		id = version['id']

		next name, get_prices(id, name)
	end
	versions
end

def get_prices(version_id, version_name)
	puts "\t\t\tGetting prices for version #{version_id}:#{version_name}"
	prices = iterate_array "https://api.mercadolibre.com/motors_prices/#{version_id}/prices", 'prices' do |price|
		pr = Hash.new
		pr['year']= price['year'].to_i
		pr['price']= price['price'].to_i
		pr['currency_symbol']= price['currency_symbol']
		pr['currency_name']= price['currency_name']
		next pr
	end
	prices
end

def generate_countries_and_cars_file
	c = get_countries
	j = c.to_json
	File.open("data_meli.json","w") do |f|
		f.write(j)
end

generate_countries_and_cars_file
