jQuery ->
  # Let qtips close on repeat click on opening element
  $('#powers').on "click", '.power-small.active', (event) ->
    $(this).qtip().hide()
  $('#feats').on "click", '.active', (event) ->
    $(this).qtip().hide()
  $('#rituals').on "click", '.active', (event) ->
    $(this).qtip().hide()
  $('.qul').on "click", '.qaction.active', (event) ->
    $(this).qtip().hide()
  $('#wealth').on "click", '.wlth.active', (event) ->
    $(this).qtip().hide()

  # REST in place qtip activation
  $('body').on "click", '.wlth', (event) ->
    $('.rest-in-place').restInPlace()
    # REST in place coin string replacement
      # $('#coins').html(data.coin_string)
    $('.rest-in-place').bind 'success.rest-in-place', (event, data) ->
      $('#coins').html(data.coin_string)
    # android number input debugging

  # qtip for powers
  $('#powers').on "click", '.power-small', (event) ->
    $(this).qtip
      overwrite: false
      content:
        text: ->
          $(this).nextAll(".power-card").html()
        title: ->
          $(this).next(".power-title").html()
      show:
        event: event.type
        ready: true
        delay: 0
        effect: false
      hide:
        event: 'unfocus'
        effect: false
      style:
        width: "407px"
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
      event

  # Qtips for dmg/heal/temphp and rest icons
  $('.qul>li>i').qtip
    content:
      text: ->
        $(this).next().html()
    show:
      event: 'click'
      delay: 0
      effect: false
    hide:
      event: 'unfocus'
      effect: false
    style:
      width: "200px"
      classes: 'qtip-bootstrap qtip-action'
    position:
      my: "top center"
      at: "bottom center"
      container: $(".action-qtips")
      viewport: $('body')
      adjust:
        method: "shift none"
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

  # Qtips for rituals
  $('dl.rituals').on "click", '.ritual', (event) ->
    $(this).qtip
      overwrite: false
      content:
        text: ->
          $(this).nextAll(".ritual-card").html()
        title: ->
          $(this).next(".ritual-title").html()
      show:
        event: event.type
        ready: true
        delay: 0
        effect: false
      hide:
        event: 'unfocus'
        effect: false
      style:
        width: "438px"
        classes: 'qtip-bootstrap'
      position:
        my: "left center"
        at: "right center"
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
      event

  # Qtips for feats. Kinda the same as the ritual ones, possibly refactoring needed
  $('dl.feats').on "click", '.feat', (event) ->
    $(this).qtip
      overwrite: false
      content:
        text: ->
          $(this).nextAll(".feat-card").html()
        title: ->
          $(this).next(".feat-title").html()
      show:
        event: event.type
        ready: true
        delay: 0
        effect: false
      hide:
        event: 'unfocus'
        effect: false
      style:
        width: "438px"
        classes: 'qtip-bootstrap'
      position:
        my: "left center"
        at: "right center"
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
      event

  # Qtips for wealth and coins
  $('#wealth').on "click", '.wlth', (event) ->
    $(this).qtip
      overwrite: false
      content:
        text: ->
          $(this).nextAll(".wealth-card").html()
        title: ->
          $(this).next(".wealth-title").html()
      show:
        event: event.type
        ready: true
        delay: 0
        effect: false
      hide:
        event: 'unfocus'
        effect: false
      style:
        width: "270px"
        classes: 'qtip-bootstrap'
      position:
        my: "left center"
        at: "right center"
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
          tooltip.attr('data-object', 'character')
      event
