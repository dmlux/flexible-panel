FlexiblePanelView = require './flexible-panel-view'
FlexibleViewManager = require './flexible-panel-manager'
{CompositeDisposable} = require 'atom'

module.exports = FlexiblePanel =
  activate: ->
    flexibleViewManager = new FlexibleViewManager

    # specify the columns for the flexible panel view
    cols = [
        name: "Type", align: "center", fixedWidth: 65, type: "text"
      ,
        name: "Description", indentWrappedText: yes
      ,
        name: "Time", align: "center", fixedWidth: 65, type: "time"
    ]

    # a variable that will keep the actual view
    consoleView = null

    # get the view from the view manager. Since we get a promise we have to
    # resolve it and store the resolved view element in our variable
    promise = flexibleViewManager.createFlexiblePanel {
      title: 'Console'
      defaultLocation: 'bottom'
      allowedLocations: ['bottom', 'right']
      addClearButton: yes
      addSaveButton: yes
      maxLines: 50
      hideTableHead: no
      hideCellBorders: no
      hideVerticalCellBorders: no
      hideHorizontalCellBorders: no
      columns: cols
    }

    # resolve promise to actual view element
    promise.then (view) =>
      consoleView = view
      for i in [1..100]
        consoleView.addEntry ["#{i}", "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren", "Sparta!", "Test"]


    # add toggle command to subscriptions
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'flexible-panel:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()
    @FlexibleViewManager.destroy()

  toggle: ->
