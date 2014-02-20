# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('body').on 'touchmove', (event) ->
    event.preventDefault()
  $('#feats').on 'touchmove', (event) ->
    event.stopPropagation()

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
    $.ajax({
      type: "PUT",
      url: "/powers/#{id}",
      data: { power: { action: action} },
      success:(data) ->
        console.log data
        if data.used < data.uses or target.hasClass("at-will")
          target.removeClass('used');
        else
          target.addClass('used')
        return false
    })

  window.onresize = ->
    $('#feats > .feats').height(window.innerHeight - 260)
  window.onresize()

  FastClick.attach(document.body)
  $('.power-small').qtip
    content:
      text: ->
        $(this).next().html()
      title: ->
        $(this).attr('data-title')
    show:
      event: 'click'
      delay: 0
      effect: false
    hide:
      event: 'unfocus'
      effect: false
    style:
      width: "405px"
      classes: 'qtip-bootstrap'
    position:
      my: "right center"
      at: "left center"
      container: ->
        $(this)
      viewport: $('body')
      adjust:
        method: "none shift"
    events:
      show: (events, api) ->
        target = api.elements.target
        setTimeout(->
          target.addClass('active')
        , 0)
      hide: (events, api) ->
        target = api.elements.target
        target.removeClass('active')
      render: (events, api) ->
        tooltip = api.elements.tooltip
        target = api.elements.target
        tooltip.addClass("qtip-" + $(target).attr('data-class'))
  $('#powers').on "click", '.power-small.active', (event) ->
    $(this).qtip().hide()
    console.log "click..?"
