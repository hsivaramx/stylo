class ContextMenu extends Spine.Controller
  className: 'contextMenu'

  events:
    'mousedown': 'cancel'
    'click [data-type]': 'click'

  constructor: (@stage, position) ->
    super()

    @el.css(position)
    @html(JST['app/views/context_menu'](this))

    @selectDisabled = not @stage.selection.isAny()
    @$('[data-require=select]').toggleClass('disabled', @selectDisabled)

  click: (e) ->
    e.preventDefault()
    @remove()

    item = $(e.currentTarget)
    type = item.data('type')

    unless item.hasClass('disabled')
      @[type]()

  remove: (e) ->
    @el.remove()

  cancel: -> false

  # Type

  copy: ->
    @stage.clipboard.copyInternal()

  paste: ->
    @stage.clipboard.pasteInternal()

  bringForward: ->
    @stage.bringForward()

  bringBack: ->
    @stage.bringBack()

  bringToFront: ->
    @stage.bringToFront()

  bringToBack: ->
    @stage.bringToBack()

class Context extends Spine.Controller
  events:
    'contextmenu': 'show'

  constructor: (@stage) ->
    super(el: @stage.el)
    $('body').bind('mousedown', @remove)

  show: (e) ->
    e.preventDefault()
    @remove()

    position =
      left: e.pageX + 1
      top:  e.pageY + 1

    @menu = new ContextMenu(@stage, position)
    $('body').append(@menu.el)

  remove: =>
    @menu?.remove()
    @menu = null

  release: ->
    $('body').unbind('mousedown', @remove)
    super

module.exports = Context