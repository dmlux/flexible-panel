{CompositeDisposable, Disposable} = require 'atom'

module.exports =
class FlexiblePanelView

  constructor: (@config) ->
    @element = document.createElement 'div'
    @element.classList.add 'flexible-panel'

    panelControls = document.createElement 'div'
    panelControls.classList.add 'panel-controls'

    input = document.createElement 'input'
    input.classList.add 'input-search', 'native-key-bindings'
    input.type = 'search'
    input.placeholder = 'Filter'

    clearBtn = document.createElement 'a'
    clearBtn.classList.add 'btn', 'icon', 'icon-file-text', 'inline-block-tight', 'float-right'
    clearBtn.innerHTML = 'clear'

    saveBtn = document.createElement 'a'
    saveBtn.classList.add 'btn', 'icon', 'icon-desktop-download', 'inline-block-tight'
    saveBtn.innerHTML = 'save'

    panelControls.appendChild input
    panelControls.appendChild clearBtn
    panelControls.appendChild saveBtn

    @element.appendChild panelControls

    input.addEventListener 'input', @_onFilter
    saveBtn.addEventListener 'click', @_onSave
    clearBtn.addEventListener 'click', @_onClear


  _onClear: ->
    console.log 'clear content'


  _onSave: ->
    console.log 'save content'


  _onFilter: (event) =>
    filter = event.srcElement.value

    console.log filter, @element

    event.preventDefault()
    event.stopPropagation()


  getTitle: ->
    @config.title


  getURI: ->
    @config.URI


  getDefaultLocation: ->
    @config.defaultLocation


  getAllowedLocations: ->
    @config.allowedLocations


  destroy: ->
    @element.remove()


  getElement: ->
    @element
