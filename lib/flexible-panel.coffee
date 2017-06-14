FlexiblePanelView = require './flexible-panel-view'
FlexibleViewManager = require './flexible-panel-manager'
{CompositeDisposable} = require 'atom'

module.exports = FlexiblePanel =
  activate: ->
    @flexibleViewManager = new FlexibleViewManager

    @consoleView = null
    @flexibleViewManager.createFlexiblePanel {
      title: 'Console'
      defaultLocation: 'bottom',
      allowedLocations: ['bottom', 'right']
    }
    .then (view) =>
      @consoleView = view

    @warningsView = null
    @flexibleViewManager.createFlexiblePanel {
      title: 'Warnings'
      defaultLocation: 'bottom',
      allowedLocations: ['bottom', 'right']
    }
    .then (view) =>
      @warningsView = view

    # add toggle command to subscriptions
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'flexible-panel:toggle': => @toggle()

  deactivate: ->
    @flexiblePanelView.destroy()
    @flexiblePanelView = null
    @subscriptions.dispose()
    @FlexibleViewManager.destroy()

  toggle: ->
