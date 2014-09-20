Meeting = 
	init: ->
		Meeting.open = false
		$('#meeting_start_time').datetimepicker
			format:'d.m.Y H:i'
			lang:'en'
			step: 30
			formatTime:'g:i a'
		$('body').on 'click', '#content-right', @hideMeetingForm
		$('body').on 'click', '.meeting-request', @showMeetingForm
		$('body').on 'ajax:success', '.meeting-link', @showMeeting 
		$('body').on 'ajax:success', '#new_meeting', @notifyMeeting
		$('body').on 'click', '.current-meeting-btn', @hideMeeting
		$('body').on 'ajax:success', 'a', @checkMeetings
		$('body').on 'mouseover', '.star-rating-container .star', @highlightStar
		$('body').on 'mouseleave', '.star-rating-container .star', @unhighlightStar
		$('body').on 'click', '.star-rating-container .star', @rate
		$('body').on 'ajax:success', '#rating-form', @thankUser
		$('body').on 'click', '#meeting-cancel', @hideMeetingForm
		Meeting.canRate = true
		@checkMeetings();

	thankUser: ->
		$('.message-body').html "<h1>Thank You for Rating!</h1>"

	rate: ->
		rating = $(@).attr('id')
		$('#rating-value').val rating
		$(@).nextAll().find('polygon').css('fill', 'white')
		Meeting.rated = true
		Meeting.canRate = false
		setTimeout ->
			Meeting.canRate = true
		, 300

	unhighlightStar: ->
		$('.star').find('polygon').css('fill', '#2ecc71') if !Meeting.rated && Meeting.canRate
		Meeting.rated = false
	
	highlightStar: ->
		$(@).nextAll().find('polygon').css('fill', 'white')
		Meeting.rated = false

	checkMeetings: ->
		if $('#current-meeting').length < 1
			$.get '/meetings/check', (data) ->
				$('body').prepend(data) if $('#current-meeting').length < 1

	hideMeeting: ->
		$('#current-meeting').remove()

	notifyMeeting: (event, data) ->
		$('body').prepend(data)
		$(@)[0].reset()
		$('#meeting-modal-container').hide()
		$('#current-meeting').addClass('animated fadeInDown')

	showMeeting: (event, data) ->
		$('#content-left-small').hide() if $('.mobile').length > 0
		$('#content-right-large').show().html(data)
		$('.message').addClass('animated fadeIn')
		

	hideMeetingForm: ->
		$('#meeting-modal-container').hide() if Meeting.open = true
		Meeting.open = false
		return true

	showMeetingForm: ->
		id = $(@).attr('id')
		btn = $(@)
		setTimeout ->
			$('#meeting-modal-container').show().removeClass('animated').addClass('animated fadeInLeft')
			Meeting.open = true
			if btn.hasClass('result-meeting-request')
				$('#meeting_recipient').val id
		, 10
		$('#meeting-modal-container, #meeting-modal-content').swipe	
			swipe: (event, direction, distance, duration, fingerCount) ->
				if direction == "left"
					Meeting.hideMeetingForm()
				threshold: 100 


		



ready = ->
	Meeting.init()
$(document).ready ready
$(document).on 'page:load', ready