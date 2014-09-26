UserProfile = 
	init: ->
		$('body').on 'click', '.edit-svg.edit-skill', @showEditField
		$('body').on 'click', '.edit-svg:not(.edit-skill)', @editField
		$('body').on 'ajax:success', '#skill-form, #needed-skill-form', @addSkill
		$('body').on 'click', '.skill', @deleteSkill
		$('body').on 'ajax:success', '.edit_user', @saveSettings
		$('body').on 'click', '.skill-input', @addSkillFromBox
		$('.best_in_place').bind 'ajax:success', @checkValues
		$('body').on 'ajax:success', 'a, form', @linkifyLinks
		@linkifyLinks()

	addSkillFromBox: ->
		skill = $(@).text()
		$('.skill-name').val skill
		$('#needed-skill-form').submit()

		
	linkifyLinks: ->
		$('.linkify').each ->
			linkifiedText = UserProfile.linkify $(@).text()
			$(@).html linkifiedText


	linkify: (inputText) ->
		replacePattern1 = /(\b(https?|ftp):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/gim
		replacedText = inputText.replace(replacePattern1, '<a href="$1" target="_blank">$1</a>')
		replacePattern2 = /(^|[^\/])(www\.[\S]+(\b|$))/gim
		replacedText = replacedText.replace(replacePattern2, '$1<a href="http://$2" target="_blank">$2</a>')
		replacePattern3 = /(([a-zA-Z0-9\-\_\.])+@[a-zA-Z\_]+?(\.[a-zA-Z]{2,6})+)/gim
		replacedText = replacedText.replace(replacePattern3, '<a href="mailto:$1">$1</a>')
		replacedText;



	checkValues: ->
		console.log @
		console.log $(@)
		$(@).click()

	editField: ->
		$(@).parent().next().children().first().click()

	saveSettings: ->
		$('#save-user').val('Saved!')
		setTimeout ->
			$('#save-user').val('Save')
		, 2000


	deleteSkill: ->
		return if $('.other').length > 0
		id = $(@).attr('id').slice(2)
		skill = $(@)
		if $(@).hasClass('have')
			url = "/skills/#{id}"
		else
			url = "/needed_skills/#{id}"
		$.ajax 
			url: url
			type: "delete"
			success: ->
				skill.remove()

	showEditField: ->
		$(@).parents('.field-header').next().toggle()

	addSkill: (event, data) ->
		$(@)[0].reset()
		skill = data.name
		if $('.onboarding.skills').length < 1
			skillList = $(@).parents('.field-row').next()
			
		else
			skillList = $('#skill-row')


		if $(@).attr('id') == "skill-form"
			className = "have"
		else
			className = "needed"

		if skillList.find("#s-#{data.id}").length < 1
			skillList.append("<div class='skill #{className}' id='s-#{data.id}'>#{skill},&nbsp</div>")
			skillList.find("#s-#{data.id}").addClass('animated fadeIn')
		else
			form = $(@)
			form.find('input').val('Already Added')
			setTimeout ->
				form[0].reset()
			, 1000

ready = ->
	UserProfile.init()
$(document).ready ready
$(document).on 'page:load', ready