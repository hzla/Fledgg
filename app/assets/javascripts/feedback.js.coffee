Feedback = 
	init: ->
		$('body').on 'submit', '#feedback-form', @thankUser
		$('body').on 'click', '#feedback', @showForm
		$('#content-left, #user-top-bar, #green-bar, #status-bar').click @hideFeedback
		Feedback.on = false

	hideFeedback: ->
		console.log $(@)
		return false if $(@).parents('#feedback-container').length > 0
		if Feedback.on
			$('#feedback-container').hide().css('height', '40px')
			$('#feedback-container input, #feedback-container textarea').css 'opacity', '0'
			Feedback.on = false

	showForm: ->
		$('#feedback-container input, #feedback-container textarea').animate 
			opacity: '1'
		, 1500, ->
			Feedback.on = true
		$('#feedback-container').show().animate
			height: "340px"
		, 1000 


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