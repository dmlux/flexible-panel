FlexiblePanelView = require './flexible-panel-view'
FlexibleViewManager = require './flexible-panel-manager'
{CompositeDisposable} = require 'atom'

module.exports = FlexiblePanel =
  activate: ->
    flexibleViewManager = new FlexibleViewManager

    # specify the columns for the flexible panel view
    cols = [
        name: 'Type', align: 'center', fixedWidth: 65, type: 'label'
      ,
        name: 'Description', indentWrappedText: yes
      ,
        name: 'Time', align: 'center', fixedWidth: 115, type: 'time'
    ]

    # specify the labels that can be used within the view
    lbls = [
        type: 'command', background: '#e67e22', color: '#ffffff'
      ,
        type: 'message', background: '#3498db', color: '#ffffff'
      ,
        type: 'error', background: '#c0392b'
      ,
        type: 'warning', color: '#ffffff'
      ,
        type: 'plain', background: 'transparent', color: '#ffffff'
    ]

    # a variable that will keep the actual view
    consoleView = null

    # get the view from the view manager. Since we get a promise we have to
    # resolve it and store the resolved view element in our variable
    promise = flexibleViewManager.createFlexiblePanel {
      title: 'Console'                        # The title of the corresponding view tab
      defaultLocation: 'left'               # Specifies the dock in which the view should be opened
      allowedLocations: ['left', 'bottom', 'center']  # Specifies other allowed docks for the view
      addClearButton: yes                     # Adds a button that can clear the contents
      addSaveButton: yes                      # Adds a button that will save the table contents
      maxLines: 50                            # Represents the max number of lines that are allowed
      hideTableHead: no                       # Hides the fixed header
      hideCellBorders: no                     # Hides any borders of each table cells
      hideVerticalCellBorders: no             # Hides only the vertical borders of each table cell
      hideHorizontalCellBorders: no           # Hides only the horizontal borders of each table cell
      useMonospaceFont: no                    # Uses monospace font for the table
      columns: cols                           # An array with column specifications
      labels: lbls                            # An array with label specifications
    }

    # resolve promise to actual view element
    promise.then (view) =>
      consoleView = view
      for i in [1..25]
        consoleView.addEntry ["command", "#{i} Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren", "Sparta!", "Test"]
        consoleView.addEntry ["message", "#{i} Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren", "Sparta!", "Test"]
        consoleView.addEntry ["error", "#{i} Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren", "Sparta!", "Test"]
        consoleView.addEntry ["warning", "#{i} Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren", "Sparta!", "Test"]

    # add toggle command to subscriptions
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'flexible-panel:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()
    @FlexibleViewManager.destroy()

  toggle: ->
