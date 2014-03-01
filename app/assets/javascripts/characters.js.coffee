# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('body').on 'touchmove', (event) ->
    event.preventDefault()
  $('#feats').on 'touchmove', (event) ->
    event.stopPropagation()
  $('#powers').on 'touchmove', (event) ->
    event.stopPropagation()
  $('#rituals').on 'touchmove', (event) ->
    event.stopPropagation()

  # Handle using a power when clicking on the "link" in the title
  $('body').on 'click', '.use-power', (event) ->
    target_attribute = $(this).parents('.qtip').attr("id")
    target = $(".power-small[aria-describedby=#{target_attribute}]")[0]
    target = $(target)
    id = target.attr("id").replace( /^\D+/g, '')
    if $(this).text() == "Use"
      action = "increase_usage"
      if !target.hasClass("at-will")
        $(this).html("Restore")
        target.next(".power-title").children("span").html("Restore")
    else
      action = "decrease_usage"
      $(this).html("Use")
      target.next(".power-title").children("span").html("Use")
    change_power_usage(target, id, action)

  # Handle using a power by swiping
  $(".power-small").hammer({swipe_velocity: 0.2}).on "swipe", (event) ->
    event.preventDefault()
    id = $(this).attr("id").replace( /^\D+/g, '')
    # Decide if power should increase in use or decrease
    if event.gesture.direction == Hammer.DIRECTION_RIGHT
      action = "increase_usage"
    else if event.gesture.direction == Hammer.DIRECTION_LEFT
      action = "decrease_usage"

    target = $(this)
    # Update power and toggle used
    change_power_usage(target, id, action)

  change_power_usage = (target, id, action) ->
    $.ajax({
      type: "PUT",
      url: "/powers/#{id}",
      data: { power: { action: action} },
      success:(data) ->
        if data.used < data.uses
          target.removeClass('used');
          $("#log").html(data.log)
        else
          target.addClass('used')
          $("#log").html(data.log)
        return false
    })

  FastClick.attach(document.body)
