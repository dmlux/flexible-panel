elementResizeDetectorMaker = require 'element-resize-detector'

module.exports =
class TableView

  constructor: (@columns, @config) ->
    @config ?= {}
    @config.maxLines ?= 500
    @config.hideTableHead ?= no
    @config.hideCellBorders ?= no
    @config.hideVerticalCellBorders ?= no
    @config.hideHorizontalCellBorders ?= no

    @element = document.createElement 'div'
    @element.classList.add 'table-wrapper'

    @childCount = 0

    headWrapper = document.createElement 'div'
    headWrapper.classList.add 'table-head-wrapper'
    headWrapper.classList.add 'visibility-hidden' if @config.hideTableHead

    headTable = document.createElement 'div'
    headTable.classList.add 'table'

    headRow = document.createElement 'div'
    headRow.classList.add 'tr'

    for col in @columns
      cell = document.createElement 'div'
      cell.classList.add 'td', "align-#{col.align}"
      cell.classList.add 'no-borders' if @config.hideCellBorders
      cell.classList.add 'no-vertical-borders' if @config.hideVerticalCellBorders
      cell.classList.add 'no-horizontal-borders' if @config.hideHorizontalCellBorders

      if col.fixedWidth > 0
        cell.style.width = "#{col.fixedWidth}px"
        cell.style.minWidth = "#{col.fixedWidth}px"
        cell.style.maxWidth = "#{col.fixedWidth}px"

      cell.innerHTML = col.name
      headRow.appendChild cell

    @tableHead = document.createElement 'div'
    @tableHead.classList.add 'thead'
    @tableHead.appendChild headRow

    headTable.appendChild @tableHead
    headWrapper.appendChild headTable
    @element.appendChild headWrapper

    @emptyMessage = document.createElement 'div'
    @emptyMessage.classList.add 'empty-message'
    @emptyMessage.innerHTML = 'No data to show'
    @element.appendChild @emptyMessage

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
        if @columns[idx].fixedWidth == 0 and not @config.hideTableHead
          headCells[idx].style.width = "#{cell.offsetWidth}px"
          headCells[idx].style.minWidth = "#{cell.offsetWidth}px"
          headCells[idx].style.maxWidth = "#{cell.offsetWidth}px"


  addRow: (columns) ->
    columns.push '' while columns.length < @columns.length

    if @tableBody.childElementCount >= @config.maxLines
      @tableBody.removeChild @tableBody.firstChild
      @childCount--

    row = document.createElement 'div'
    row.classList.add 'tr'

    for value, idx in @columns
      cellContent = document.createElement 'div'
      cellContent.classList.add 'indent-wrapped-text' if @columns[idx].indentWrappedText
      cellContent.classList.add 'cell-content'

      cellText = document.createElement 'span'
      cellText.innerHTML = columns[idx]

      #cellContent.innerHTML = columns[idx]
      pseudo = document.createElement 'div'
      pseudo.classList.add 'pseudo'

      cellContent.appendChild pseudo
      cellContent.appendChild cellText

      cell = document.createElement 'div'
      cell.classList.add 'td', "align-#{value.align}"
      cell.classList.add 'no-thead' if @config.hideTableHead
      cell.classList.add 'no-borders' if @config.hideCellBorders
      cell.classList.add 'no-vertical-borders' if @config.hideVerticalCellBorders
      cell.classList.add 'no-horizontal-borders' if @config.hideHorizontalCellBorders

      if @columns[idx].fixedWidth > 0
        cell.style.width = "#{@columns[idx].fixedWidth}px"
        cell.style.minWidth = "#{@columns[idx].fixedWidth}px"
        cell.style.maxWidth = "#{@columns[idx].fixedWidth}px"

      cell.appendChild cellContent
      row.appendChild cell

    @emptyMessage.classList.add 'hidden' if not @emptyMessage.classList.contains 'hidden'
    @tableBody.appendChild row

    @childCount++
    @bodyWrapper.scrollTop = @bodyWrapper.scrollHeight

    @_onResize()

  clear: ->
    @tableBody.removeChild @tableBody.firstChild while @tableBody.firstChild
    @childCount = 0

    headCells = @tableHead.querySelectorAll 'div.td'

    for td, idx in headCells
      td.removeAttribute 'style' if @columns[idx].fixedWidth == 0

    @emptyMessage.classList.remove 'hidden'

  getView: ->
    @element
