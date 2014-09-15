Conversation = 
	init: ->
		$('body').on 'click', '.conversation', @selectConvo
		@startPage()
		$('body').on 'click', '.reply-svg', @reply
		$('body').on 'ajax:success', '.convo-link', @displayConvo
		$('body').on 'ajax:success', '#new_message', @showMessages
		$('body').on 'ajax:success', '.trash-link', @trashConversation

	trashConversation: ->
		$('.conversation.active').remove()
		$('.conversation').first().click() 

	startPage: ->
		if $('#send-to').length > 0
			$('#new-message-container').show()
			$('#other_user_id').val $('#send-to').text()
			$('#message-recipient').text $('#send-name').text()
		else
			$('.conversation').first().click()

	showMessages: ->
		if $('#send-to').length > 0
			history.pushState(null, document.title, '/conversations')
			location.reload()
		$('.message').show().removeClass('animated').addClass('animated fadeIn')
		$('.conversation.active').find('.convo-subject').text $('#message-subject').val().slice(0,25)
		$('.conversation.active').find('.convo-last-message').text $('#message-body').val().slice(0,25)
		$(@)[0].reset()
		$('.conversation.active').click()


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
		$('#content-right-large').append(data)
		$('.message').addClass('animated fadeIn')





		



ready = ->
	Conversation.init()
$(document).ready ready
$(document).on 'page:load', ready