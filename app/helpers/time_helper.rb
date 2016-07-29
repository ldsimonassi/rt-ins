module TimeHelper
	#20160615000500
	FICTION_START_TIME = Time.new(2016, 06, 16, 00, 05, 00)
	ACTUAL_START_TIME = Time.new

	def get_current_fiction_time
		current_time = Time.new
		fiction_time = FICTION_START_TIME + (current_time - ACTUAL_START_TIME) * 10
		fiction_time
	end

	def get_past_fiction_time(seconds)
		fiction_time = get_current_fiction_time
		fiction_time -= seconds
		return fiction_time
	end

	def get_past_fiction_time_str(seconds)
		fiction_time = get_past_fiction_time seconds
		return fiction_time.strftime("%Y%m%d%H%M%S")
	end

	def get_current_fiction_time_str
		fiction_time = get_current_fiction_time
		return fiction_time.strftime("%Y%m%d%H%M%S")
	end

end