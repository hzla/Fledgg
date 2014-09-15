Search = 
	init: ->
		$('body').on 'click', '.search-svg', @submitSearch
		$('body').on 'keypress', '#people-search-form input', @submitOnEnter
		$('.result').hoverIntent @displayResultInfo, @doNothing

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