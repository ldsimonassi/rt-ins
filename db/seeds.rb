# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


def load_cities_and_cars_from_file
	countries = Oj.load(IO.read("./data_meli.json"))
	countries.each do |country_name, country_content| 
		#if country_name != "Brasil"  
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
			#if brand_name!= 'ALFA ROMEO' and brand_name!= 'Alfa Romeo'# and brand_name!='PEUGEOT'
			#	next
			#end
			puts "\tBrand Name:[#{brand_name} in #{country}]"
			brand = Brand.create({name:brand_name, country:country})

			if not brand.id?
				byebug
			end

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
end

load_cities_and_cars_from_file

rt_tracker = DeviceModel.create({name:'RTTracker 1.0', 
				    camera:'NONE', 
				    computer:'Raspberry PI 2.0', 
				    accelerometer:'pi_accel', 
				    gps:'YES', 
				    obdi:'2.0', 
				    manufacturer:'Prototype'})



i = 0

for i in 0..100 do
	TrackingDevice.create({device_model: rt_tracker, serial_no: "AAAA#{i}"})
end
vento_td = TrackingDevice.first
peugeot206_td = TrackingDevice.last

arg = Country.find_by({name: 'Argentina'})
bue = Province.find_by({name:'Buenos Aires', country:arg})
caba = Province.find_by({name:'Capital Federal', country:arg})

quilmes = City.find_by({name:'Quilmes', province:bue})
moreno = City.find_by({name:'Moreno', province:bue})
vte_lopez = City.find_by({name:'Vicente Lopez', province:bue})
cordoba = Province.find_by({name:'Cordoba', country:arg})
cordoba_capital = City.find_by({name:'Cordoba Capital', province:cordoba})
rio_cuarto = City.find_by({name:'Rio Cuarto', province:cordoba})

v_urq = City.find_by({name:'Villa Urquiza', province:caba})
v_luro = City.find_by({name:'Villa Luro', province:caba})
saavedra = City.find_by({name:'Saavedra', province:caba})

dario = User.create({username: 'ldsimonassi', 
                      email:'ldsimonassi@gmail.com', 
                      password: 'dario123', 
                      password_confirmation: 'dario123', 
                      first_name:'Luis Dario', 
                      last_name:'Simonassi', country:arg})

dario = User.find_by_username('ldsimonassi')


dario_casa = Address.create({user: dario, name:'Casa', street:'Av Olazabal', number: '4545', directions:'4to C', zip_code:'1431', city:v_urq})
dario_trabajo = Address.create({user: dario, name:'Trabajo', street:'Arias', number: '3751', directions:'7mo piso', zip_code:'1430', city:saavedra})

mimi = User.create({username: 'kenoe51', email:'kenoe51@gmail.com', password: 'mimi1951', password_confirmation: 'mimi1951', first_name:'Mirta Noemí', last_name:'Mascareño', country:arg})
mimi_casa = Address.create({user: mimi, name:'Casa', street:'Alsina', number: '775', directions: 'Cortada esquina 66 bis', zip_code:'1841', city:quilmes})

mjs = User.create({username: 'mjsimonassi', email:'mjsimonassi@gmail.com', password: 'athos2009', password_confirmation: 'athos2009', first_name:'María José', last_name:'Simonassi', country:arg})
mjs_casa = Address.create({user: mjs, name:'Casa', street:'Pasjae Wagner', number: '1160', directions: 'PB', zip_code:'1423', city:v_luro})



price_vento = arg.brands.find_by_name('VOLKSWAGEN').models.find_by_name('Vento').versions.find_by_name('2.0 TSI SPORTLINE DSG (200CV) (L11)').prices.find_by_year(2011)



vento_dario = Vehicle.create({user:dario, name:'Vento Negro', price:price_vento, chasis_no:"92AAJSHD123", engine_no: "8748JADHJ232", plate_no:"KJO497", tracking_device:vento_td})

peugeot = arg.brands.find_by_name('PEUGEOT')
peu_206 = peugeot.models.find_by_name('206')
price_206 = peu_206.versions.find_by_name('3Ptas. 1.6 XS Premium').prices.find_by_year('2007')

p206_dario = Vehicle.create({user:dario, name:'Perla Negra', price:price_206, chasis_no:"2874JAHD", engine_no: "23847AKJSA", plate_no:"GST389", tracking_device:peugeot206_td})



