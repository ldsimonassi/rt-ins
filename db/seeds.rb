# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


countries = Oj.load(IO.read("./data_meli.json"))


countries.each do |country_name, country_content| 
	if country_name == ""  
		next
	end
	puts "Country: [#{country_name}]"

	country = Country.create({name:country_name})

	# Pick brands and states
	states = country_content['states']
	brands = country_content['brands']

	# Load Country Brands
	brands.each do |brand_name, models|
		puts "\tBrand Name:[#{brand_name}]"
		brand = Brand.create({name:brand_name, country:country})

		models.each do |model_name, versions|
			puts "\t\tModel Name: #{model_name}"
			model = Model.create({name:model_name, brand:brand})

			versions.each do |version_name, prices|
				#puts "\t\t\tVersion name: #{version_name}"
				version = Version.create({name:version_name, model:model})

				prices.each do |price_data|
					year = price_data['year']
					price = price_data['price']
					currency = price_data['currency_symbol']
					#puts "\t\t\t\t#{year}: #{currency}#{price}"
					Price.create({year:year, price:price, currency:currency})
				end
			end

		end
	end


	# Load Country States
	states.each do |state_name, state_content| 
		puts "\tState: [#{state_name}]"
		state = Province.create({name: state_name, country:country})
		cities = state_content['cities']
		i = 0
		cities.each do | city_name |
			city = City.create({name:city_name, province:state})
			i = i + 1
		end
		puts "\t\t#{i} cities inserted"
	end

end





# arg = Country.create({name: 'Argentina'})
# bue = Province.create({name:'Buenos Aires', country:arg})
# caba = City.create({name:'Ciudad de Buenos Aires', province:bue})
# quilmes = City.create({name:'Quilmes', province:bue})
# moreno = City.create({name:'Moreno', province:bue})
# vte_lopez = City.create({name:'Vicente Lopez', province:bue})
# cordoba = Province.create({name:'Cordoba', country:arg})
# cordoba_capital = City.create({name:'Cordoba Capital', province:cordoba})
# rio_cuarto = City.create({name:'Rio Cuarto', province:cordoba})

# dario = User.create({username: 'ldsimonassi', 
#                      email:'ldsimonassi@gmail.com', 
#                      password: 'dario123', 
#                      password_confirmation: 'dario123', 
#                      first_name:'Luis Dario', 
#                      last_name:'Simonassi'})

# dario_casa = Address.create({user: dario, name:'Casa', street:'Av Olazabal', number: '4545', directions:'4to C', zip_code:'1431', city:caba})
# dario_trabajo = Address.create({user: dario, name:'Trabajo', street:'Arias', number: '3751', directions:'7mo piso', zip_code:'1430', city:caba})


# mimi = User.create({username: 'kenoe51', email:'kenoe51@gmail.com', password: 'mimi1951', password_confirmation: 'mimi1951', first_name:'Mirta Noemí', last_name:'Mascareño'})
# mimi_casa = Address.create({user: mimi, name:'Casa', street:'Alsina', number: '775', directions: 'Cortada esquina 66 bis', zip_code:'1841', city:quilmes})

# mjs = User.create({username: 'mjsimonassi', email:'mjsimonassi@gmail.com', password: 'athos2009', password_confirmation: 'athos2009', first_name:'María José', last_name:'Simonassi'})
# mjs_casa = Address.create({user: mjs, name:'Casa', street:'Pasjae Wagner', number: '1160', directions: 'PB', zip_code:'1423', city:caba})

# require 'rest-client'
# url = 'https://api.mercadolibre.com/motors_prices/MLA1744/brands'
# result = RestClient.get url
# p = JSON.parse(result.body)['brands']

# p.each do |br|
# 	brand = Brand.create({name: br['name']})
# 	url = "https://api.mercadolibre.com/motors_prices/#{br['id']}/models"
# 	puts "Getting models #{url}"
# 	models= JSON.parse(RestClient.get(url).body)['models']
# 	models.each do |mod|
# 		model = Model.create({brand: brand, name: mod['name']})
# 		url = "https://api.mercadolibre.com/motors_prices/#{mod['id']}/versions"
# 		puts "	Getting Version: #{url}"
# 		versions= JSON.parse(RestClient.get(url).body)['versions']
# 		versions.each do |ver|
# 			version = Version.create({name: ver[:name], model:model})
# 			url = "https://api.mercadolibre.com/motors_prices/#{ver['id']}/prices"
# 			prices= JSON.parse(RestClient.get(url).body)['prices']
# 			prices.each do |pri|
# 				price = Price.create({version:version, year:pri['year'].to_i, currency:pri['currency_symbol'], price:pri['price'].to_i})
# 			end
# 		end
# 	end
# end
