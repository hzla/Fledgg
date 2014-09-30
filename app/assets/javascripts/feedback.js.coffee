Feedback = 
	init: ->
		$('body').on 'submit', '#feedback-form', @thankUser

	thankUser: ->
		$(@)[0].reset()
		$('#send-feedback').val 'Thank You!'
		setTimeout ->
			$('#send-feedback').val 'Submit'
		, 2000
		



ready = ->
	Feedback.init()
$(document).ready ready
$(document).on 'page:load', ready