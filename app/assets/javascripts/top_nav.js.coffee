TopNav = 
	init: ->
		$('body').on 'touchend', '.mobile-menu-icon', @openNav
		$('body').on 'touchend', '.top-nav-content a', @closeNav
		$('#content-left, #content-right, #conent-left-small, #content-right-large').click @closeNav

	openNav: ->
		$('.top-nav-content').show().removeClass('animated fadeOutLeftBig').addClass 'animated fadeInLeftBig'
		$('top-nav').css 'background', '#414141'
		$('.top-nav').css 'opacity', '.3'
		$('.top-nav-content').swipe	
			swipe: (event, direction, distance, duration, fingerCount) ->
				if direction == "left"
					TopNav.closeNav()
				threshold: 100 
		$('.mob-nav').swipe	
			swipe: (event, direction, distance, duration, fingerCount) ->
				if direction == "left"
					TopNav.closeNav()
				threshold: 100 
		TopNav.state = "open"

	closeNav: ->
		$('.top-nav-content').removeClass('animated fadeOutLeftBig').addClass('animated fadeOutLeftBig')		


ready = ->
	TopNav.init()
$(document).ready ready
$(document).on 'page:load', ready

