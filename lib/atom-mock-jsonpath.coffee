AtomMockJsonpathView = require './atom-mock-jsonpath-view'
{CompositeDisposable} = require 'atom'

module.exports = AtomMockJsonpath =
  atomMockJsonpathView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomMockJsonpathView = new AtomMockJsonpathView(state.atomMockJsonpathViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomMockJsonpathView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-mock-jsonpath:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomMockJsonpathView.destroy()

  serialize: ->
    atomMockJsonpathViewState: @atomMockJsonpathView.serialize()

  toggle: ->
    console.log 'AtomMockJsonpath was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
