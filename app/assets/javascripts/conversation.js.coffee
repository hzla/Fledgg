Conversation = 
	init: ->
		$('body').on 'click', '.conversation', @selectConvo
		$('.conversation').first().click()
		$('body').on 'ajax:success', '.convo-link', @displayConvo

	selectConvo: ->
		$('.conversation').removeClass('active')
		$(@).addClass('active')

	displayConvo: (event, data) ->
		$('#content-right-large').html(data)
		$('.message').addClass('animated fadeIn')





		



ready = ->
	Conversation.init()
$(document).ready ready
$(document).on 'page:load', ready