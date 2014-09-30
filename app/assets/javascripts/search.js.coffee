Search = 
	init: ->
		$('body').on 'click', '.search-svg', @submitSearch
		$('body').on 'keypress', '#people-search-form input', @submitOnEnter
		$('body').on 'click', '.follow-link', @showFollowed
		$('.result').hoverIntent @displayResultInfo, @doNothing

	showFollowed: ->
		if $(@).hasClass "unfollow"
			$(@).find('div').text('+ FOLLOW')
			$(@).removeClass().addClass('follow-link follow')
		else
			$(@).find('div').text('UNFOLLOW')
			$(@).removeClass().addClass('follow-link unfollow')


	doNothing: -> 
		return

	displayResultInfo: (event) ->
		console.log 
		id = $(@).attr('id').slice(2)
		$.get "/users/#{id}/result_info", (data) ->
			$('#content-right').html(data)
			$('#profile-content').addClass('animated fadeIn')

	submitOnEnter: (e) ->
		if e.which == 13 
			$('#people-search-form').submit()
			return false
  
	submitSearch: ->
		$('#people-search-form').submit()


		



ready = ->
	Search.init()
$(document).ready ready
$(document).on 'page:load', ready