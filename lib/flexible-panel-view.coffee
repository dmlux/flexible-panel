{CompositeDisposable, Disposable} = require 'atom'

PanelControls = require './panel-controls'
TableView = require './table-view'

module.exports =
class FlexiblePanelView

  constructor: (@config) ->
    @config.defaultLocation ?= 'bottom'
    @config.allowedLocations ?= ['bottom']
    @config.columns ?= []

    for col, idx in @config.columns
      col.align ?= 'left'
      col.name ?= "Column #{idx + 1}"

    @element = document.createElement 'div'
    @element.classList.add 'flexible-panel'

    panelControls = new PanelControls
    @element.appendChild panelControls.getView()

    panelControls.setSaveListener @_onSave
    panelControls.setClearListener @_onClear
    panelControls.setFilterListener @_onFilter

    @tableView = new TableView @config.columns

    @element.appendChild @tableView.getView()


  _onClear: ->
    console.log 'clear content'


  _onSave: ->
    console.log 'save content'


  _onFilter: (event) =>
    filter = event.srcElement.value

    console.log filter, @element

    event.preventDefault()
    event.stopPropagation()


  addEntry: (entry) ->
    @tableView.addRow entry


  getTitle: ->
    @config.title


  getURI: ->
    @config.URI


  getDefaultLocation: ->
    @config.defaultLocation


  getAllowedLocations: ->
    @config.allowedLocations


  destroy: ->
    @element.remove()


  getElement: ->
    @element
