# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
	$('#brand').change ->
		brand_id= $('#brand :selected').val()
		$.ajax "/brands/#{brand_id}/models",
			type: 'GET'
			dataType: 'text'
			error: (jqXHR, textStatus, errorThrown) ->
				console.log("Error #{errorThrown}")
			success: (data, textStatus, jqXHR) ->
				$('#model').empty()
				$('#version').empty()
				$('#price').empty()
				eval(data)
				
	
	$('#model').change ->
		brand_id= $('#brand :selected').val()
		model_id= $('#model :selected').val()
		$.ajax "/brands/#{brand_id}/models/#{model_id}/versions",
			type: 'GET'
			dataType: 'text'
			error: (jqXHR, textStatus, errorThrown) ->
				console.log("Error #{errorThrown}")
			success: (data, textStatus, jqXHR) ->
				$('#version').empty()
				$('#price').empty()
				eval(data)

	$('#version').change ->
		brand_id= $('#brand :selected').val()
		model_id= $('#model :selected').val()
		version_id= $('#version :selected').val()
		$.ajax "/brands/#{brand_id}/models/#{model_id}/versions/#{version_id}/prices",
			type: 'GET'
			dataType: 'text'
			error: (jqXHR, textStatus, errorThrown) ->
				console.log("Error #{errorThrown}")
			success: (data, textStatus, jqXHR) ->
				$('#price').empty()
				eval(data)
