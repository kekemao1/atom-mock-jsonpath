{View} = require 'space-pen'
{TextEditorView} = require 'atom-space-pen-views'
JsonTask = require './atom-mock-jsonTask'

module.exports =
class JsoninputView extends View
  jsonTask: null

  initialize: ->
    @jsonTask = new JsonTask()

  @content: ->
    @jsonEditorView = new TextEditorView(placeholderText:'Input Json Content')
    @jsonEditorView.getModel().setGrammar(atom.grammars.grammarForScopeName('source.json'))

    @div =>
      @div "Type your answer:"
      @div id:'regex-type', class:'block', =>
        @subview 'jsonEditorView', @jsonEditorView
      @div class:"bottomDiv", =>
        @label outlet:"spacecraft",'一定要输入正确的JSON内容哦！'
        @button outlet: 'diffJsonButton',click: 'diffJson', class: 'btn', 'submit'


  diffJson: ->
    console.log @spacecraft
    if @jsonTask.diffJson(@jsonEditorView.getModel().getText())
      #@spacecraft.text("sadfasdf"）
      @spacecraft.text("json")
      #create frist right-panel
      @panel4json = atom.workspace.getActivePane().splitRight(copyActiveItem: false)

    else
      #@spacecraft.text("Sorry,这不是一个正确的Json"）
      @spacecraft.text("别闹，这不是一个正确的Json")




  getTitle: ->
    return "Oreo-Json-Path"
