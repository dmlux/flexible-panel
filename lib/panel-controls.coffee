
module.exports =
class PanelControls

  constructor: (@config) ->
    @config ?= {}
    @config.addClearButton ?= yes
    @config.addSaveButton ?= yes

    @element = document.createElement 'div'
    @element.classList.add 'panel-controls'

    @filterInput = document.createElement 'input'
    @filterInput.classList.add 'input-search', 'native-key-bindings'
    @filterInput.type = 'search'
    @filterInput.placeholder = 'Filter list content'
    @element.appendChild @filterInput

    if @config.addClearButton
      @clearBtn = document.createElement 'a'
      @clearBtn.classList.add 'btn', 'icon', 'icon-circle-slash', 'inline-block-tight', 'float-right'
      @clearBtn.innerHTML = 'clear'
      @element.appendChild @clearBtn

    if @config.addSaveButton
      @saveBtn = document.createElement 'a'
      @saveBtn.classList.add 'btn', 'icon', 'icon-desktop-download', 'inline-block-tight'
      @saveBtn.classList.add 'float-right' if not @config.addClearButton
      @saveBtn.innerHTML = 'save'
      @element.appendChild @saveBtn

  setFilterListener: (listener) ->
    @filterInput.addEventListener 'input', listener

  setSaveListener: (listener) ->
    @saveBtn.addEventListener 'click', listener if @config.addSaveButton

  setClearListener: (listener) ->
    @clearBtn.addEventListener 'click', listener if @config.addClearButton

  getView: ->
    @element
