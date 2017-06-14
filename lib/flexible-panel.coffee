FlexiblePanelView = require './flexible-panel-view'
FlexibleViewManager = require './flexible-panel-manager'
{CompositeDisposable} = require 'atom'

module.exports = FlexiblePanel =
  flexiblePanelView: null

  activate: ->
    @flexibleViewManager = new FlexibleViewManager
    @consoleView = @flexibleViewManager.createFlexiblePanel {
      title: 'Console'
      defaultLocation: 'bottom',
      allowedLocations: ['bottom', 'right']
    }

    @warningsView = @flexibleViewManager.createFlexiblePanel {
      title: 'Warnings'
      defaultLocation: 'bottom',
      allowedLocations: ['bottom', 'right']
    }

    # add toggle command to subscriptions
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'flexible-panel:toggle': => @toggle()

    console.log @

  deactivate: ->
    @flexiblePanelView.destroy()
    @flexiblePanelView = null
    @subscriptions.dispose()
    @FlexibleViewManager.destroy()

  toggle: ->
