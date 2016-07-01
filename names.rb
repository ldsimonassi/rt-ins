require 'byebug'

class NamePicker
	def initialize
		@apellidos = []
		@nombres = []
		
		File.open("apellidos.txt", 'r').each_line { |l| @apellidos.push l.delete("\n").delete("\t").capitalize}
		File.open("nombres.txt", 'r').each_line { |l| @nombres.push l.delete("\n").delete("\t").capitalize}

	end

	def pick_name
		apellido = @apellidos[rand()* @apellidos.length] 
		nombre = @nombres[rand() * @nombres.length]
		return "#{nombre} #{apellido}"
	end
end

np = NamePicker.new

for i in 0..100 do
	puts np.pick_name
end