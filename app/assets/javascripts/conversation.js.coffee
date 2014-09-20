Conversation = 
	init: ->
		$('body').on 'click', '.conversation', @selectConvo
		$('body').on 'click', '.reply-svg', @reply
		$('body').on 'ajax:success', '.convo-link', @displayConvo
		$('body').on 'ajax:success', '#new_message', @showMessages
		$('body').on 'ajax:beforeSend', '#new_message', @checkMessage
		$('body').on 'ajax:success', '.trash-link', @trashConversation
		$('body').on 'click', '.bar-section', @changeTab
		$('body').on 'ajax:success', '#meetings-link', @showMeetings
		@startPage()

	showMeetings: (event, data) ->
		$('#content').html(data) 
		$('.conversation').first().click() if $('.mobile').length < 1


	changeTab: ->
		$('.bar-section').removeClass('active')
		$(@).addClass('active')

	checkMessage: ->
		if $('#message-body').val() == ""
			$('#message-body').css 'border', '2px solid red'
			$('#message-body').css 'width', '-=8px'
			$('#message-body').css 'height', '-=2px'

			return false

	trashConversation: ->
		$('.conversation.active').remove()
		$('#messages-section').click() if $('.mobile').length > 0


	startPage: ->
		if $('#send-to').length > 0
			$('#new-message-container').show()
			$('#other_user_id').val $('#send-to').text()
			$('#message-recipient').text $('#send-name').text()
			if $('.mobile').length > 0
				$('#content-left-small').hide()
				$('#content-right-large').show()
		else if $('#go-meetings').length > 0
			$('#meetings-section').click()
		else
			$('.convo-link').first().click() if $('.mobile').length < 1

	showMessages: ->
		if $('#send-to').length > 0
			history.pushState(null, document.title, '/conversations')
			location.reload()
		$('.message').show().removeClass('animated').addClass('animated fadeIn')
		$('.conversation.active').find('.convo-subject').text $('#message-subject').val().slice(0,25)
		$('.conversation.active').find('.convo-last-message').text $('#message-body').val().slice(0,25)
		$(@)[0].reset()
		$('.conversation.active .convo-link').click()
		$('#new-message-container').hide()


	selectConvo: ->
		$('.conversation').removeClass('active')
		$(@).addClass('active')

	reply: ->
		$('.message').hide()
		$('#new-message-container').show().removeClass().addClass('animated fadeIn')
		$('#other_user_id').val $('.conversation.active').attr('id').slice(2)
		$('#message_conversation_id').val $(@).attr('id')
		name = $('.conversation.active').find('.convo-name').text()
		$('#message-recipient').text name

	displayConvo: (event, data) ->
		$('.message').remove()
		$('#new-message-container').hide()
		$('#content-left-small').hide() if $('.mobile').length > 0
		$('#content-right-large').show().append(data)
		$('.message').addClass('animated fadeIn')





		



ready = ->
	Conversation.init()
$(document).ready ready
$(document).on 'page:load', ready