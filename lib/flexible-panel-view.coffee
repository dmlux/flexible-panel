{CompositeDisposable, Disposable} = require 'atom'

module.exports =
class FlexiblePanelView

  constructor: (@config) ->
    # Create root element
    @element = document.createElement 'div'
    @element.classList.add 'flexible-panel-wrapper'
    @element.innerHTML = 'Test'

    # keep track of disposables
    @subscriptions = new CompositeDisposable

    console.log "FlexiblePanelView created with #{@config.URI} with URI = atom://flexible-panel-view-UID#{@config.UID}"
    console.log @config

  # Toggle
  toggle: ->
    atom.workspace.toggle @config.URI

  # provides a title to the panel
  getTitle: ->
    @config.title

  # the URI which corresponds to the panel
  getURI: ->
    @config.URI

  # the standard location in which dock the panel will be created
  getDefaultLocation: ->
    @config.defaultLocation

  # all locations where the panel can be placed
  getAllowedLocations: ->
    @config.allowedLocations

  # Tear down any state and detach
  destroy: ->
    @element.remove()
    @subscriptions.dispose()

  # returns the content of this view element
  getElement: ->
    @element
