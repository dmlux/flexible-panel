{CompositeDisposable, Disposable} = require 'atom'
FlexiblePanelView = require './flexible-panel-view'

module.exports =
class FlexiblePanelManager

  # manage ids given to views
  @panelIDs : 0

  constructor: ->
    @panels = []
    @subscriptions = new CompositeDisposable

  createFlexiblePanel: (config) ->
    config.UID = FlexiblePanelManager.panelIDs++
    config.URI = "atom://flexible-panel-view-UID#{config.UID}"

    @subscriptions.add atom.workspace.addOpener (URI) =>
      if URI is "atom://flexible-panel-view-UID#{config.UID}"
        panel = new FlexiblePanelView config
        @panels.push panel
        panel

    atom.workspace.toggle(config.URI)

  destroy: ->
    panel.destroy() for panel in @panels
    @subscriptions.dispose()
