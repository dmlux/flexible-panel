{CompositeDisposable, Disposable} = require 'atom'
FlexiblePanelView = require './flexible-panel-view'

module.exports =
class FlexiblePanelManager

  # manage ids given to views
  @panelIDs : 0

  constructor: ->
    @panels = []
    @subscriptions = new CompositeDisposable new Disposable ->
      for item in atom.workspace.getPaneItems()
        if item instanceof FlexiblePanelView
          item.destroy()

  createFlexiblePanel: (config) ->
    config.UID = FlexiblePanelManager.panelIDs++
    config.URI = "atom://flexible-panel-view-UID#{config.UID}"

    @subscriptions.add atom.workspace.addOpener (URI) =>
      if URI is "atom://flexible-panel-view-UID#{config.UID}"
        panel = new FlexiblePanelView config
        @panels.push panel
        panel

    atom.workspace.open config.URI


  hidePanels: ->
    for panel in @panels
      atom.workspace.hide panel.getURI()


  showPanels: ->
    for panel in @panels
      atom.workspace.open panel.getURI()


  destroy: ->
    @subscriptions.dispose()
