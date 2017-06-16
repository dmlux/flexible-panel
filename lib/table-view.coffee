elementResizeDetectorMaker = require 'element-resize-detector'

module.exports =
class TableView

  constructor: (@columns, @config) ->
    @config ?= {}

    @element = document.createElement 'div'
    @element.classList.add 'table-wrapper'

    headWrapper = document.createElement 'div'
    headWrapper.classList.add 'table-head-wrapper'

    headTable = document.createElement 'div'
    headTable.classList.add 'table'

    headRow = document.createElement 'div'
    headRow.classList.add 'tr'

    for col in @columns
      cell = document.createElement 'div'
      cell.classList.add 'td', "align-#{col.align}"
      cell.innerHTML = col.name
      headRow.appendChild cell

    @tableHead = document.createElement 'div'
    @tableHead.classList.add 'thead'
    @tableHead.appendChild headRow

    headTable.appendChild @tableHead
    headWrapper.appendChild headTable
    @element.appendChild headWrapper

    @bodyWrapper = document.createElement 'div'
    @bodyWrapper.classList.add 'table-body-wrapper'

    bodyTable = document.createElement 'div'
    bodyTable.classList.add 'table', 'native-key-bindings'
    bodyTable.tabIndex = -1

    @tableBody = document.createElement 'div'
    @tableBody.classList.add 'tbody'

    bodyTable.appendChild @tableBody
    @bodyWrapper.appendChild bodyTable
    @element.appendChild @bodyWrapper

    #@element.onresize = @_onResize
    ERD = elementResizeDetectorMaker()
    ERD.listenTo @element, @_onResize

  _onResize: (event) =>
    if @tableBody.lastChild?
      row = @tableBody.lastChild
      bodyCells = row.querySelectorAll 'div.td'
      headCells = @tableHead.querySelectorAll 'div.td'

      for cell, idx in bodyCells
        headCells[idx].style['width'] = "#{cell.offsetWidth}px"
        headCells[idx].style['min-width'] = "#{cell.offsetWidth}px"
        headCells[idx].style['max-width'] = "#{cell.offsetWidth}px"

  addRow: (columns) ->
    columns.push '' while columns.length < @columns.length

    row = document.createElement 'div'
    row.classList.add 'tr'

    for value, idx in @columns
      cellText = document.createElement 'span'
      cellText.innerHTML = columns[idx]

      cell = document.createElement 'div'
      cell.classList.add 'td', "align-#{value.align}"
      cell.appendChild cellText

      row.appendChild cell

    @tableBody.appendChild row
    @bodyWrapper.scrollTop = @bodyWrapper.scrollHeight
    @_onResize()

  clear: ->
    @tableBody.removeChild @tableBody.firstChild while @tableBody.firstChild

  getView: ->
    @element
