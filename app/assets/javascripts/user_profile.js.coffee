UserProfile = 
	init: ->
		$('body').on 'click', '.edit-svg.edit-skill', @showEditField
		$('body').on 'click', '.edit-svg:not(.edit-skill)', @editField
		$('body').on 'ajax:success', '#skill-form, #needed-skill-form', @addSkill
		$('body').on 'click', '.skill', @deleteSkill
		$('body').on 'ajax:success', '.edit_user', @saveSettings
		$('.best_in_place').bind 'ajax:success', @checkValues

	checkValues: ->
		console.log @
		console.log $(@)

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
		skillList = $(@).parents('.field-row').next()
		skill = data.name

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