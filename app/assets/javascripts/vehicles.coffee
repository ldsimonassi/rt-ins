# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
	$('#brand_id').change ->
		brand_id= $('#brand_id :selected').val()
		$.ajax "/brands/#{brand_id}/models",
			type: 'GET'
			dataType: 'text'
			error: (jqXHR, textStatus, errorThrown) ->
				console.log("Error #{errorThrown}")
			success: (data, textStatus, jqXHR) ->
				$('#model_id').empty()
				$('#version_id').empty()
				$('#price_id').empty()
				eval(data)
				
	
	$('#model_id').change ->
		brand_id= $('#brand_id :selected').val()
		model_id= $('#model_id :selected').val()
		$.ajax "/brands/#{brand_id}/models/#{model_id}/versions",
			type: 'GET'
			dataType: 'text'
			error: (jqXHR, textStatus, errorThrown) ->
				console.log("Error #{errorThrown}")
			success: (data, textStatus, jqXHR) ->
				$('#version_id').empty()
				$('#price_id').empty()
				eval(data)

	$('#version_id').change ->
		brand_id= $('#brand_id :selected').val()
		model_id= $('#model_id :selected').val()
		version_id= $('#version_id :selected').val()
		$.ajax "/brands/#{brand_id}/models/#{model_id}/versions/#{version_id}/prices",
			type: 'GET'
			dataType: 'text'
			error: (jqXHR, textStatus, errorThrown) ->
				console.log("Error #{errorThrown}")
			success: (data, textStatus, jqXHR) ->
				$('#price_id').empty()
				eval(data)
