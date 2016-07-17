module DriverReportHelper
	include TimeHelper
	# Dashboard del conductor:
	# 	Combo:
	# 	-----
	# 		Ultimo día
	# 		Ultima semana
	# 		Ultimo mes

	# 	- Recorrido por día.
	# 	- Horas por día.
	# 	- Diagrama de torta de autos usados.
	# 	- Histograma de aceleraciones.
	# 	- Histograma de velocidades.


	def group_by_filters(tracks, filters)
		ret = Hash.new

		ret[:distances_data] = Array.new
		ret[:max_speed_data] = Array.new
		ret[:time_data] = Array.new

		filters.map do |period|
			ret[:distances_data] << period 
			ret[:max_speed_data] << period 
			ret[:time_data] << period 
		end

		current_distance = 0 
		current_speed = 0 
		current_time = 0 

		i = 0
		byebug
		tracks.each do |track|
			byebug
			if i >= filters.length
				break
			end

			if !track.period.starts_with?(filters[i])
				byebug
				if current_time > 0
					ret[:distances_data][i] = current_distance
					ret[:max_speed_data][i] = current_speed
					ret[:time_data][i] = current_time
				end
				current_distance = 0 
				current_speed = 0 
				current_time = 0 
				i+= 1
			end
			current_time += 1
			current_distance += (track.speed_avg/60.0)
			current_speed = [current_speed, track.speed_max].max
		end

		if (current_time > 0)
			ret[:distances_data][i] = current_distance
			ret[:max_speed_data][i] = current_speed
			ret[:time_data][i] = current_time
		end

		ret
	end
end
