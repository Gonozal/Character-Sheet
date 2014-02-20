# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  FastClick.attach(document.body)
  $('.power-small').qtip
    content:
      text: ->
        $(this).next().html()
      title: ->
        $(this).attr('data-title')
    show: 'click',
    hide: 'unfocus'
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
        target.addClass('active')
      hide: (events, api) ->
        target = api.elements.target
        target.removeClass('active')
      render: (events, api) ->
        tooltip = api.elements.tooltip
        target = api.elements.target
        tooltip.addClass("qtip-" + $(target).attr('data-class'))
