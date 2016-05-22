# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

arg = Country.create({name: 'Argentina'})
bue = Province.create({name:'Buenos Aires', country:arg})
caba = City.create({name:'Ciudad de Buenos Aires', province:bue})
quilmes = City.create({name:'Quilmes', province:bue})
moreno = City.create({name:'Moreno', province:bue})
vte_lopez = City.create({name:'Vicente Lopez', province:bue})
cordoba = Province.create({name:'Cordoba', country:arg})
cordoba_capital = City.create({name:'Cordoba Capital', province:cordoba})
rio_cuarto = City.create({name:'Rio Cuarto', province:cordoba})

dario = User.create({username: 'ldsimonassi', 
                     email:'ldsimonassi@gmail.com', 
                     password: 'dario123', 
                     password_confirmation: 'dario123', 
                     first_name:'Luis Dario', 
                     last_name:'Simonassi'})

dario_casa = Address.create({user: dario, name:'Casa', street:'Av Olazabal', number: '4545', directions:'4to C', zip_code:'1431', city:caba})
dario_trabajo = Address.create({user: dario, name:'Trabajo', street:'Arias', number: '3751', directions:'7mo piso', zip_code:'1430', city:caba})


mimi = User.create({username: 'kenoe51', email:'kenoe51@gmail.com', password: 'mimi1951', password_confirmation: 'mimi1951', first_name:'Mirta Noemí', last_name:'Mascareño'})
mimi_casa = Address.create({user: mimi, name:'Casa', street:'Alsina', number: '775', directions: 'Cortada esquina 66 bis', zip_code:'1841', city:quilmes})

mjs = User.create({username: 'mjsimonassi', email:'mjsimonassi@gmail.com', password: 'athos2009', password_confirmation: 'athos2009', first_name:'María José', last_name:'Simonassi'})
mjs_casa = Address.create({user: mjs, name:'Casa', street:'Pasjae Wagner', number: '1160', directions: 'PB', zip_code:'1423', city:caba})
