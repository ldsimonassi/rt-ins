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
			period_tracks = tracks.select("sum(speed_avg/60) as distances_data, max(speed_max) as max_speed_data, count(*)/60 as time_data").where("period like '#{period}%'")

			period_tracks.each do |trk|
				ret[:distances_data][i] = trk.distances_data.blank? ? 0.0 : trk.distances_data
				ret[:max_speed_data][i] = trk.max_speed_data.blank? ? 0.0 : trk.max_speed_data
				ret[:time_data][i] = trk.time_data
			end
		end
		

		ret

	end
end
