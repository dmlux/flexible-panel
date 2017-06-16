FlexiblePanelView = require './flexible-panel-view'
FlexibleViewManager = require './flexible-panel-manager'
{CompositeDisposable} = require 'atom'

module.exports = FlexiblePanel =
  activate: ->
    flexibleViewManager = new FlexibleViewManager

    # specify the columns of the view list
    cols = [
        name: "Type", align: "center"
      ,
        name: "Description"
      ,
        name: "Time", align: "right"
      ,
        name: "Dummy", align: "left"
    ]

    # a variable that will keep the actual view
    consoleView = null

    # get the view from the view manager. Since we get a promise we have to
    # resolve it and store the resolved view element in our variable
    flexibleViewManager.createFlexiblePanel {
      title: 'Console'
      defaultLocation: 'bottom'
      allowedLocations: ['bottom', 'right']
      addClearButton: no
      columns: cols
    }
    .then (view) =>
      consoleView = view
      for i in [1..100]
        consoleView.addEntry ["Das", "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren", "Sparta!"]

    otherView = null

    # get the view from the view manager. Since we get a promise we have to
    # resolve it and store the resolved view element in our variable
    flexibleViewManager.createFlexiblePanel {
      title: 'Warnings'
      defaultLocation: 'bottom'
      allowedLocations: ['bottom', 'right']
      addClearButton: yes
      addSaveButton: yes
      columns: cols
    }
    .then (view) =>
      otherView = view
      for i in [1..100]
        otherView.addEntry ["Das", "Ist", "Sparta!"]


    # add toggle command to subscriptions
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'flexible-panel:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()
    @FlexibleViewManager.destroy()

  toggle: ->
