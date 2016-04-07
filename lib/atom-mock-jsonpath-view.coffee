{View} = require 'space-pen'
{TextEditorView} = require 'atom-space-pen-views'
{ScrollView} = require 'atom-space-pen-views'

module.exports =
class AtomMockJsonpathView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('atom-mock-jsonpath')

    @buttonDiv = document.createElement('div')
    @buttonDiv.textContent = "sdfasdfasdfasdfasdfasdf"
    @element.appendChild(@buttonDiv)

    # Create message element
    message = document.createElement('atom-text-editor')
    message.classList.add('message')
    @element.appendChild(message)





  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
