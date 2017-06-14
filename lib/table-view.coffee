
module.exports =
class TableView

  constructor: (@columns) ->
    @element = document.createElement 'div'
    @element.classList.add 'table-wrapper'

    table = document.createElement 'div'
    table.classList.add 'table'

    headRow = document.createElement 'div'
    headRow.classList.add 'tr'

    for col in @columns
      cell = document.createElement 'div'
      cell.classList.add 'td', "align-#{col.align}"
      cell.innerHTML = col.name
      headRow.appendChild cell

    tableHead = document.createElement 'div'
    tableHead.classList.add 'thead'
    tableHead.appendChild headRow

    @tableBody = document.createElement 'div'
    @tableBody.classList.add 'tbody'

    table.appendChild tableHead
    table.appendChild @tableBody
    @element.appendChild table

  addRow: (columns) ->
    columns.push '' while columns.length < @columns.length

    row = document.createElement 'div'
    row.classList.add 'tr'

    for value, idx in @columns
      cell = document.createElement 'div'
      cell.classList.add 'td', "align-#{value.align}"
      cell.innerHTML = columns[idx]

      row.appendChild cell

    @tableBody.appendChild row

  getView: ->
    @element
