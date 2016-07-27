AtomMockJsonpathView = require './atom-mock-jsonpath-view'
{CompositeDisposable} = require 'atom'
JsoninputView = require './atom-mock-jsoninputView'
JsontreeView = require './atom-mock-jsontreeView'

module.exports = AtomMockJsonpath =
  atomMockJsonpathView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomMockJsonpathView = new AtomMockJsonpathView(state.atomMockJsonpathViewState)
    # @modalPanel = atom.workspace.addModalPanel(item: @atomMockJsonpathView.getElement(), visible: false)
    @myView = new JsoninputView()
    @jsontreeView = new JsontreeView()


    #create frist right-panel
    @panel4json = atom.workspace.getActivePane().splitRight(copyActiveItem: false)
    @panel4tree = atom.workspace.getActivePane().splitRight(copyActiveItem: false)
    #@panel4jsonTree = @panel4json.splitRight(copyActiveItem: false)

    #paneElement = atom.views.getView(@panel4json)

    @panel4json.addItem(@myView)
    @panel4tree.addItem(@jsontreeView)
    @myView.setTreePaneView(@jsontreeView)

    #@newText = new TextEditorView(mini:true)
    #paneElement.appendChild(@atomMockJsonpathView.getElement())
    #paneElement.appendChild(@myView.getElement())

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
