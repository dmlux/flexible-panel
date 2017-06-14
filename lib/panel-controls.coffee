
module.exports =
class PanelControls

  constructor: ->
    @element = document.createElement 'div'
    @element.classList.add 'panel-controls'

    @filterInput = document.createElement 'input'
    @filterInput.classList.add 'input-search', 'native-key-bindings'
    @filterInput.type = 'search'
    @filterInput.placeholder = 'Filter list content'

    @clearBtn = document.createElement 'a'
    @clearBtn.classList.add 'btn', 'icon', 'icon-file-text', 'inline-block-tight', 'float-right'
    @clearBtn.innerHTML = 'clear'

    @saveBtn = document.createElement 'a'
    @saveBtn.classList.add 'btn', 'icon', 'icon-desktop-download', 'inline-block-tight'
    @saveBtn.innerHTML = 'save'

    @element.appendChild @filterInput
    @element.appendChild @clearBtn
    @element.appendChild @saveBtn

  setFilterListener: (listener) ->
    @filterInput.addEventListener 'input', listener

  setSaveListener: (listener) ->
    @saveBtn.addEventListener 'click', listener

  setClearListener: (listener) ->
    @clearBtn.addEventListener 'click', listener

  getView: ->
    @element
