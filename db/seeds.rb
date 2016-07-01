require 'set'


def warn message
	puts "*****************************************"
	puts "* #{message}"
	puts "*****************************************"
end

def load_cities_and_cars_from_file
	if Country.find_by({name: 'Argentina'}).blank? 
		warn "Loading cities and cars..."
		countries = Oj.load(IO.read("./data_meli.json"))
		countries.each do |country_name, country_content| 
			if country_name != "Argentina"  
			#if country_name == ""  
				next
			end
			puts "Country: [#{country_name}]"

			country = Country.create({name:country_name})

			# Pick brands and states
			states = country_content['states']
			brands = country_content['brands']

			# Load Country Brands
			brands.each do |brand_name, models|
				#if brand_name!= 'ALFA ROMEO' and brand_name!= 'Alfa Romeo'# and brand_name!='PEUGEOT'
				#	next
				#end
				puts "\tBrand Name:[#{brand_name} in #{country}]"
				brand = Brand.create({name:brand_name, country:country})

				if not brand.id?
					byebug
				end

				models.each do |model_name, versions|
					#puts "\t\tModel Name: #{model_name}"
					model = Model.create({name:model_name, brand:brand})

					versions.each do |version_name, prices|
						#puts "\t\t\tVersion name: #{version_name}"
						version = Version.create({name:version_name, model:model})

						prices.each do |price_data|
							year = price_data['year']
							price = price_data['price']
							currency = price_data['currency_symbol']
							#puts "\t\t\t\t#{year}: #{currency}#{price}"
							Price.create({year:year, price:price, currency:currency, version:version})
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
	else
		warn "Skipping cities and brands..."
	end
end



def create_devices
	if TrackingDevice.find_by_serial_no('AAAA0').blank?
		warn "Creating tracking devices"

		# Create device model
		rt_tracker = DeviceModel.create({name:'RTTracker 1.0', 
						    camera:'NONE', 
						    computer:'Raspberry PI 2.0', 
						    accelerometer:'pi_accel', 
						    gps:'YES', 
						    obdi:'2.0', 
						    manufacturer:'Prototype'})

		# Create trackers
		i = 0

		for i in 0..100 do
			TrackingDevice.create({device_model: rt_tracker, serial_no: "AAAA#{i}"})
			TrackingDevice.create({device_model: rt_tracker, serial_no: "BBBB#{i}"})
		end
	else
		warn "Skipping devices"
	end
end


def pick_random_taxi_price(country)
	brands = ['VOLKSWAGEN', 'PEUGEOT', 'RENAULT', 'FIAT', 'TOYOTA', 'FORD', 'CHEVROLET']

	brand = country.brands.find_by_name(brands.sample)
	model = brand.models.order("RANDOM()").first
	version = model.versions.order("RANDOM()").first
	if version.blank?
		return pick_random_taxi_price country
	end
	price = version.prices.order("RANDOM()").first
	if price.blank? || price.year < 2005
		return pick_random_taxi_price country
	end
	puts "#{country.name}: #{brand.name} - #{model.name} - #{version.name} - #{price.year}"
	price
end


def create_su_taxi_srl
	if User.find_by_username('sutaxisrl').blank?
		warn "Creating su taxi srl fleet"
		arg = Country.find_by({name: 'Argentina'})
		# bue = Province.find_by({name:'Buenos Aires', country:arg})
		# vte_lopez = City.find_by({name:'Vicente Lopez', province:bue})

		# Users
		sutaxisrl = User.create({username: 'sutaxisrl', 
		                      email:'sutaxisrl@gmail.com', 
		                      password: 'sutaxisrl', 
		                      password_confirmation: 'sutaxisrl', 
		                      first_name:'Sergio Ezequiel', 
		                      last_name:'Gutierrez', 
		                      country:arg})
		
		np = NamePicker.new

		for i in 1..100 do
			price = pick_random_taxi_price arg
			td = TrackingDevice.find_by_serial_no("BBBB#{i}")
			Vehicle.create({user:sutaxisrl, name:"SuTaxi #{i}", 
							price:price, chasis_no:"SUTAXI#{i}", 
							engine_no: "SUTAXI#{i}", plate_no:"SUTAXI#{i}", 
							tracking_device:td})

		
			Driver.create({user:sutaxisrl, 
						   name:np.pick_name, 
						   passphrase:"Passphrase de SuTaxi #{i}", internal_id:"#{i}"})
		end

	else
		warn "Skipping dario family fleet"
	end
end


class NamePicker
	def initialize
		@apellidos = []
		@nombres = []
		
		File.open("apellidos.txt", 'r').each_line { |l| @apellidos.push l.delete("\n").delete("\t").capitalize}
		File.open("nombres.txt", 'r').each_line { |l| @nombres.push l.delete("\n").delete("\t").capitalize}

		@generated = Set.new
	end

	def pick_name
		apellido = @apellidos[rand()* @apellidos.length] 
		nombre = @nombres[rand() * @nombres.length]
		ret = "#{nombre} #{apellido}"
		if @generated.include? ret
			ret = pick_name
		end
		@generated.add ret
		return ret
	end
end


def create_dario_family_fleet
	if User.find_by_username('ldsimonassi').blank?
		warn "Creating dario family fleet"
		#LookUp references
		vento_td = TrackingDevice.find_by_serial_no('AAAA0')
		peugeot206_td = TrackingDevice.find_by_serial_no('AAAA1')

		arg = Country.find_by({name: 'Argentina'})
		
		bue = Province.find_by({name:'Buenos Aires', country:arg})
		caba = Province.find_by({name:'Capital Federal', country:arg})
		cordoba = Province.find_by({name:'Cordoba', country:arg})
		
		quilmes = City.find_by({name:'Quilmes', province:bue})
		moreno = City.find_by({name:'Moreno', province:bue})
		vte_lopez = City.find_by({name:'Vicente Lopez', province:bue})
		cordoba_capital = City.find_by({name:'Cordoba Capital', province:cordoba})
		rio_cuarto = City.find_by({name:'Rio Cuarto', province:cordoba})
		v_urq = City.find_by({name:'Villa Urquiza', province:caba})
		v_luro = City.find_by({name:'Villa Luro', province:caba})
		saavedra = City.find_by({name:'Saavedra', province:caba})

		price_vento = arg.brands.find_by_name('VOLKSWAGEN').models.find_by_name('Vento').versions.find_by_name('2.0 TSI SPORTLINE DSG (200CV) (L11)').prices.find_by_year(2011)
		price_206 = arg.brands.find_by_name('PEUGEOT').models.find_by_name('206').versions.find_by_name('3Ptas. 1.6 XS Premium').prices.find_by_year('2007')

		#### Create data ####

		# Users
		dario = User.create({username: 'ldsimonassi', 
		                      email:'ldsimonassi@gmail.com', 
		                      password: 'dario123', 
		                      password_confirmation: 'dario123', 
		                      first_name:'Luis Dario', 
		                      last_name:'Simonassi', country:arg})

		mimi = User.create({username: 'kenoe51', 
							email:'kenoe51@gmail.com', 
							password: 'mimi1951', 
							password_confirmation: 'mimi1951', 
							first_name:'Mirta Noemí', 
							last_name:'Mascareño', 
							country:arg})

		mjs = User.create({username: 'mjsimonassi', 
						   email:'mjsimonassi@gmail.com', 
						   password: 'athos2009', 
						   password_confirmation: 'athos2009', 
						   first_name:'María José', 
						   last_name:'Simonassi', 
						   country:arg})

		Driver.create({user:dario, name:'Darío Simonassi', passphrase:'pirata2013', internal_id:'01'})
		Driver.create({user:dario, name:'María José Simonassi', passphrase:'athos2009', internal_id:'02'})


		# Addresses
		dario_casa = Address.create({user: dario, name:'Casa', street:'Av Olazabal', number: '4545', directions:'4to C', zip_code:'1431', city:v_urq})
		dario_trabajo = Address.create({user: dario, name:'Trabajo', street:'Arias', number: '3751', directions:'7mo piso', zip_code:'1430', city:saavedra})

		mimi_casa = Address.create({user: mimi, name:'Casa', street:'Alsina', number: '775', directions: 'Cortada esquina 66 bis', zip_code:'1841', city:quilmes})

		mjs_casa = Address.create({user: mjs, name:'Casa', street:'Pasjae Wagner', number: '1160', directions: 'PB', zip_code:'1423', city:v_luro})

		# Vehicles
		vento_dario = Vehicle.create({user:dario, name:'Vento Negro', price:price_vento, chasis_no:"92AAJSHD123", engine_no: "8748JADHJ232", plate_no:"KJO497", tracking_device:vento_td})
		p206_dario = Vehicle.create({user:dario, name:'Perla Negra', price:price_206, chasis_no:"2874JAHD", engine_no: "23847AKJSA", plate_no:"GST389", tracking_device:peugeot206_td})
	else
		warn "Skipping dario family fleet"
	end
end

def delete_test_data
	# tables = ['users', 'tracking_devices', 'device_locations', 'vehicles', 'addresses']
	# tables.each do |t|
	# 	ActiveRecord::Base.connection.execute("TRUNCATE #{t} RESTART IDENTITY")
	# end
	Driver.destroy_all
	User.destroy_all
	TrackingDevice.destroy_all
	DeviceModel.destroy_all
	DeviceLocation.destroy_all
	DeviceTrack.destroy_all
	Vehicle.destroy_all
	Address.destroy_all
end

# Actual SetUp

load_cities_and_cars_from_file

delete_test_data

create_devices

create_dario_family_fleet

create_su_taxi_srl


