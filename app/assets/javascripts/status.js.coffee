Status = 
	init: ->
		$('body').on 'ajax:success', '#new_status', @addStatus
		$('body').on 'click', '.like-svg', @likeStatus
		$('body').on 'ajax:success', '#new_comment', @addComment
		$('body').on 'ajax:beforeSend', '#new_comment', @checkBody
		$('.like').on 'click', @like

	like: ->
		newCount = parseInt($(@).next().text()) + 1
		$(@).next().text newCount

	checkBody: ->
		body = $(@).find('#comment_body').val()
		if body == ""
			$('#comment_body').css 'border', '1px solid red'
			return false


	addStatus: (event, data) ->
		$('#statuses').prepend(data)
		$('.status').first().addClass('animated fadeIn')
		$(@)[0].reset()

	likeStatus: ->
		$(@).parents('.status').find('.like').click()
		

	addComment: (event, data) ->
		$(@).parents('.comment').before(data)
		$(@).parents('.comment').prev().addClass('animated fadeIn')
		count = $(@).parents('.status').find('.comment_count')
		new_count = parseInt(count.text()) + 1
		count.text new_count
		$(@)[0].reset()
	

		



ready = ->
	Status.init()
$(document).ready ready
$(document).on 'page:load', ready