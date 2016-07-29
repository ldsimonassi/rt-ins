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

		ret[:distances_data] = Array.new(filters.length, 0.0)
		ret[:max_speed_data] = Array.new(filters.length, 0.0)
		ret[:time_data] = Array.new(filters.length, 0.0)

		filters.each_with_index do |period, i|
			period_tracks = tracks.select("sum(speed_avg/60.0) as distances_data, max(speed_max) as max_speed_data, count(*) as time_data").where("period like '#{period}%' and speed_max > 0")

			period_tracks.each do |trk|
				ret[:distances_data][i] = trk.distances_data.blank? ? 0.0 : trk.distances_data
				ret[:max_speed_data][i] = trk.max_speed_data.blank? ? 0.0 : trk.max_speed_data
				ret[:time_data][i] = trk.time_data #/ 60.0
			end
		end
		ret
	end

	def group_by_cars(tracks, filters)
		ret = Hash.new
		
		vehicles_minutes = tracks.select("tracking_device_id as id, count(*) as time_data")

		vehicles_minutes.each do |vehicle_minutes|
			vid = vehicle_minutes.id
			vehicle = Vehicle.find_by_tracking_device_id(vid)
			price = vehicle.price
			version = price.version
			model = version.model
			brand = model.brand

			desc = "#{vehicle.name} - #{brand.name} #{model.name} #{version.name} #{price.year}"
			ret[desc] = vehicle_minutes.time_data / 60.0 # En Horas
		end
		return ret.keys, ret.values
	end

    def get_alerts_by_type(from, to)

    end

end
