{View} = require 'space-pen'
{TextEditorView} = require 'atom-space-pen-views'
JsonTask = require './atom-mock-jsonTask'

module.exports =
class JsoninputView extends View
  jsonTask: null
  jsontreeView: null
  jsonObject: null
  treePaneView:null

  initialize: ->
    @jsonTask = new JsonTask()


  setTreePaneView:(treePaneView) ->
    @treePaneView = treePaneView

  @content: ->
    @jsonEditorView = new TextEditorView(placeholderText:'Input Json Content')
    @jsonEditorView.getModel().setGrammar(atom.grammars.grammarForScopeName('text.weex'))

    @div =>
      @div "Type your answer:"
      @div id:'regex-type', class:'block', =>
        @subview 'jsonEditorView', @jsonEditorView
      @div class:"bottomDiv", =>
        @label outlet:"spacecraft",'Please a real json input!'
        @button outlet: 'diffJsonButton',click: 'diffJson', class: 'btn', 'submit'
        

  diffJson: ->
    if @jsonTask.diffJson(@jsonEditorView.getModel().getText())
      #@spacecraft.text("sadfasdf"）
      @jsonObject = @jsonEditorView.getModel().getText()
      @treePaneView.viewJsonTree(@jsonObject)
      @spacecraft.text("generated done!")

    else
      #@spacecraft.text("Sorry,这不是一个正确的Json"）
      @spacecraft.text("Please，this is not real json!")

  getTitle: ->
    return "Oreo-Json-Path"

  getJson: ->
    return @jsonObject
