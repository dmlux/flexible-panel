elementResizeDetectorMaker = require 'element-resize-detector'

module.exports =
class TableView

  constructor: (@columns, @labels, @config) ->
    @config ?= {}
    @config.maxLines ?= 500
    @config.hideTableHead ?= no
    @config.hideCellBorders ?= no
    @config.hideVerticalCellBorders ?= no
    @config.hideHorizontalCellBorders ?= no
    @config.useMonospaceFont ?= no

    @element = document.createElement 'div'
    @element.classList.add 'table-wrapper'

    @childCount = 0

    headWrapper = document.createElement 'div'
    headWrapper.classList.add 'table-head-wrapper'
    headWrapper.classList.add 'visibility-hidden' if @config.hideTableHead

    headTable = document.createElement 'div'
    headTable.classList.add 'table'
    headTable.classList.add 'monospace-font' if @config.useMonospaceFont

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

    @noMatchMessage = document.createElement 'div'
    @noMatchMessage.classList.add 'no-match-message', 'hidden'
    @noMatchMessage.innerHTML = 'No match found'
    @element.appendChild @noMatchMessage

    @bodyWrapper = document.createElement 'div'
    @bodyWrapper.classList.add 'table-body-wrapper'

    bodyTable = document.createElement 'div'
    bodyTable.classList.add 'table', 'native-key-bindings'
    bodyTable.classList.add 'monospace-font' if @config.useMonospaceFont
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
        if @columns[idx].fixedWidth is 0 and not @config.hideTableHead
          headCells[idx].style.width = "#{cell.offsetWidth}px"
          headCells[idx].style.minWidth = "#{cell.offsetWidth}px"
          headCells[idx].style.maxWidth = "#{cell.offsetWidth}px"


  addRow: (columns) ->
    columns.push '' while columns.length < @columns.length
    # console.log columns

    if @tableBody.childElementCount >= @config.maxLines
      @tableBody.removeChild @tableBody.firstChild
      @childCount--

    row = document.createElement 'div'
    row.classList.add 'tr'

    for value, idx in @columns
      cellContent = document.createElement 'div'
      cellContent.classList.add 'cell-content'
      cellContent.classList.add 'indent-wrapped-text' if @columns[idx].indentWrappedText

      cellText = document.createElement 'span'

      if @columns[idx].type is 'text'
        cellText.innerHTML = columns[idx]

      else if @columns[idx].type is 'time'
        cellText.innerHTML = @getTime()

      else if @columns[idx].type is 'label'
        label = (e for e in @labels when e.type is columns[idx])[0]

        if label?
          cellText.innerHTML = columns[idx]
          cellContent.style.background = label.background
          cellContent.style.color = label.color

        else
          cellText.innerHTML = 'undefined'
          cellContent.style.background = '#cc0000'
          cellContent.style.color = '#ffffff'

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
    td.removeAttribute 'style' for td, idx in headCells when @columns[idx].fixedWidth is 0

    @emptyMessage.classList.remove 'hidden'

  getView: ->
    @element

  getTime: ->
    date = new Date

    hours = date.getHours()
    minutes = date.getMinutes()
    seconds = date.getSeconds()
    milliseconds = date.getMilliseconds()

    hours = "0#{hours}" if hours < 10
    minutes = "0#{minutes}" if minutes < 10
    seconds = "0#{seconds}" if seconds < 10
    milliseconds = "0#{milliseconds}" if milliseconds < 10
    milliseconds = "0#{milliseconds}" if milliseconds < 100

    "#{hours}:#{minutes}:#{seconds}.#{milliseconds}"
