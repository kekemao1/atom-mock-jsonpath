JsonTask = require './atom-mock-jsonTask'

module.exports =
class AtomMockJsonpathView
  callback: null
  element: null
  editorElement: null
  editor: null
  message: null
  jsonTask: null

  constructor: (serializedState) ->

    # Create root element
    @element = document.createElement('div')
    @element.classList.add('atom-mock-jsonpath')

    @TopDiv = document.createElement('div')
    @TopDiv.textContent = "sdfasdfasdfasdfasdfasdf"
    @TopDiv.classList.add('TopDiv')
    @element.appendChild(@TopDiv)

    @CentDiv = document.createElement('div')
    @CentDiv.classList.add('CentDiv')

    # Create message element
    @message = document.createElement('atom-text-editor')
    @editor = atom.workspace.buildTextEditor({
      mini: false,  # １行のみのエディタ
      lineNumberGutterVisible: true,  # 行番号は非表示
      placeholderText: '请输入Json内容'    # 説明文
    })

    @editor.setGrammar(atom.grammars.grammarForScopeName('source.json'))
    @message.setModel(@editor)

    @message.classList.add('message')
    @CentDiv.appendChild(@message)
    @element.appendChild(@CentDiv)

    @buttomDiv = document.createElement('div')
    @buttomDiv.textContent = "   分析上述Json内容，并以树形结构展示，请保证上述内容是正确的Json   "
    @buttomDiv.classList.add('buttomDiv')
    @element.appendChild(@buttomDiv)

    @button = document.createElement('button')
    @button.classList.add('button')
    @buttomDiv.appendChild(@button)
    @button.innerText = "提交分析"

    @jsonTask = new JsonTask()

    @button.onclick = (event,element) =>
      if @jsonTask.diffJson(@message.getModel().getText())
        console.log "sdfasdfasdfasdfasdfasdf"
      else
        console.log "sdfasdfsadf"


      #console.log(@message.getModel().getText())
      #try
      #  object = JSON.parse(@message.getModel().getText())
      #  console.log(object)
      #catch error
      #  return console.error(error)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    callback: null
    editorElement: null
    editor: null
    message: null
    jsonTask: null
    @element.remove()

  getElement: ->
    @element
