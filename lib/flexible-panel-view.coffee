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
      col.fixedWidth ?= 0
      col.indentWrappedText ?= no
      col.type ?= 'text'

    @element = document.createElement 'div'
    @element.classList.add 'flexible-panel'

    panelConfig = {}
    panelConfig.addSaveButton = @config.addSaveButton if @config.addSaveButton?
    panelConfig.addClearButton = @config.addClearButton if @config.addClearButton?

    panelControls = new PanelControls panelConfig
    @element.appendChild panelControls.getView()

    panelControls.setFilterListener @_onFilter
    panelControls.setClearListener @_onClear
    panelControls.setSaveListener @_onSave

    tableConfig = {}
    tableConfig.maxLines = @config.maxLines if @config.maxLines?
    tableConfig.hideTableHead = @config.hideTableHead if @config.hideTableHead?
    tableConfig.hideCellBorders = @config.hideCellBorders if @config.hideCellBorders?
    tableConfig.hideVerticalCellBorders = @config.hideVerticalCellBorders if @config.hideVerticalCellBorders?
    tableConfig.hideHorizontalCellBorders = @config.hideHorizontalCellBorders if @config.hideHorizontalCellBorders?

    @tableView = new TableView @config.columns, tableConfig
    @element.appendChild @tableView.getView()

  _onClear: (event) =>
    console.log 'clear content'

    @tableView.clear()

    event.preventDefault()
    event.stopPropagation()

  _onSave: (event) =>
    console.log 'save content'

    event.preventDefault()
    event.stopPropagation()


  _onFilter: (event) =>
    filter = event.srcElement.value

    console.log filter

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
