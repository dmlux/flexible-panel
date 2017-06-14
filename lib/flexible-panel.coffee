FlexiblePanelView = require './flexible-panel-view'
FlexibleViewManager = require './flexible-panel-manager'
{CompositeDisposable} = require 'atom'

module.exports = FlexiblePanel =
  activate: ->
    flexibleViewManager = new FlexibleViewManager

    # specify the columns of the view list
    cols = [
        name: "Type"
        align: "center"
      ,
        name: "Description"
      ,
        name: "Time"
        align: "right"
    ]

    # a variable that will keep the actual view
    consoleView = null

    # get the view from the view manager. Since we get a promise we have to
    # resolve it and store the resolved view element in our variable
    flexibleViewManager.createFlexiblePanel {
      title: 'Console'
      defaultLocation: 'bottom'
      allowedLocations: ['bottom', 'right']
      columns: cols
    }
    .then (view) =>
      consoleView = view
      i = 0
      while i++ < 100
        consoleView.addEntry [1]
        consoleView.addEntry ["", "Das ist ein Testtext damit was in der Tabelle steht"]
        consoleView.addEntry ["", "", 100]





    # add toggle command to subscriptions
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'flexible-panel:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()
    @FlexibleViewManager.destroy()

  toggle: ->
