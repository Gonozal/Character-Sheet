# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  FastClick.attach(document.body)
  $('a.power-small').qtip
    content:
      text: ->
        $(this).attr('data-content');
      title: ->
        $(this).attr('data-title');
    show: 'click',
    hide: 'unfocus'
    style:
      width: "400px"
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
      render: (events, api) ->
        tooltip = api.elements.tooltip
        target = api.elements.target
        tooltip.addClass("qtip-" + $(target).attr('data-class'))
