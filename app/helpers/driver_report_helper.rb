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


	def get_driver_device_tracks(driver)
		from = get_past_fiction_time_str(86400) # Last day
		tracks = driver.device_tracks.where("period > #{from}")
		
		periods = Hash.new 

		tracks.each do |track|
			period = track.period[0..9]
			puts "#{period} #{track.period}"
			# 1st time
			if !periods[period]
				periods[period] = Hash.new 
				periods[period][:speed_max] = 0
				periods[period][:distance] = 0.0
				periods[period][:minutes] = 0
			end

			periods[period][:minutes] += 1
			periods[period][:distance] += (track.speed_avg/60.0)
			periods[period][:speed_max] = [periods[period][:speed_max], track.speed_max].max

			# tracking_device_id
			# period
			# speed_max
			# speed_p75
			# speed_avg
			# speed_p25
			# speed_min
			# acceleration_up
			# acceleration_down
			# acceleration_forward
			# acceleration_backward
			# created_at
			# updated_at
			# driver_id

		end

		periods
	end


end
