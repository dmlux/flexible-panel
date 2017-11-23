
{CompositeDisposable, Disposable} = require 'atom'
App = require('electron').remote;
fs = require 'fs'

PanelControls = require './panel-controls'
TableView = require './table-view'

module.exports =
class FlexiblePanelView

  constructor: (@config) ->
    @config.defaultLocation ?= 'bottom'
    @config.defaultLocation = 'bottom' if not (@config.defaultLocation in ['bottom', 'top', 'left', 'right', 'center'])
    @config.allowedLocations ?= ['bottom']
    @config.allowedLocations = @config.allowedLocations.filter (location) -> location in ['bottom', 'top', 'left', 'right', 'center']
    @config.columns ?= []
    @config.labels ?= []

    for col, idx in @config.columns
      col.name ?= "Column #{idx + 1}"
      col.fixedWidth ?= 0
      col.indentWrappedText ?= no
      col.align ?= 'left'
      col.align = 'left' if not (col.align in ['left', 'center', 'right'])
      col.type ?= 'text'
      col.type = 'text' if not (col.type in ['text', 'time', 'label'])

    for lbl in @config.labels
      lbl.type ?= 'none'
      lbl.background ?= 'inherit'
      lbl.color ?= 'inherit'

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
    tableConfig.useMonospaceFont = @config.useMonospaceFont if @config.useMonospaceFont?

    @tableView = new TableView @config.columns, @config.labels, tableConfig
    @element.appendChild @tableView.getView()

  _onClear: (event) =>
    @tableView.clear()

    event.preventDefault()
    event.stopPropagation()

  _onSave: (event) =>
    headRows = @tableView.tableHead.children
    bodyRows = @tableView.tableBody.children
    text = ''

    for row in headRows
      rowText = ''
      tds = row.querySelectorAll 'div.td'
      rowText += "#{td.innerHTML} " for td in tds
      text += "#{rowText}\n"

    for row in bodyRows
      rowText = ''
      spans = row.querySelectorAll 'span'
      rowText += "#{span.innerHTML} " for span in spans
      text += "#{rowText}\n"

    dialog = App.dialog;

    dialog.showSaveDialog (filename) =>
      if not filename?
        atom.notifications.addInfo "#{@config.title} content not saved",
          detail: 'You did not entered a file name'
      else
        fs.writeFile filename, text, (err) =>
          if err?
            atom.notifications.addError "Could not save #{@config.title} content",
              detail: "An error ocurred creating the file #{err.message}"

    event.preventDefault()
    event.stopPropagation()


  _onFilter: (event) =>
    filter = event.srcElement.value.toLowerCase()
    rows = @tableView.tableBody.children

    visibleElements = @tableView.childCount

    for row in rows
      tds = row.children
      contains = []

      for td in tds
        content = td.querySelector('span').innerHTML
        content = content.replace /<(?:.|\n)*?>/gm, " "
        content = content.toLowerCase()

        if content.indexOf(filter) isnt -1
          contains.push td

      if contains.length is 0 and not row.classList.contains 'hidden-row'
        row.classList.add 'hidden-row'
        visibleElements--

      else if contains.length isnt 0 and row.classList.contains 'hidden-row'
        row.classList.remove 'hidden-row'
        visibleElements++

    @tableView.bodyWrapper.scrollTop = @tableView.bodyWrapper.scrollHeight

    if visibleElements is 0
      @tableView.noMatchMessage.classList.remove 'hidden'
      @tableView.emptyMessage.classList.add 'hidden' if not @tableView.emptyMessage.classList.contains 'hidden'
    else
      @tableView.noMatchMessage.classList.add 'hidden'
      @tableView.emptyMessage.classList.add 'hidden' if @tableView.childCount > 0

    if filter is ''
      @tableView.noMatchMessage.classList.add 'hidden' if not @tableView.noMatchMessage.classList.contains 'hidden'
      @tableView.emptyMessage.classList.remove 'hidden' if visibleElements is 0

    event.preventDefault()
    event.stopPropagation()


  addListEntry: (title, entry) ->
    # console.log "addListEntry", title, entry
    @tableView.addListRow title, entry


  addEntry: (entry) ->
    # console.log entry
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
