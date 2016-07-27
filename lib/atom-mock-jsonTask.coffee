module.exports =
class JsonTask

  constructor:  ->

  serialize: ->
    console.log("test json task")

  diffJson:(messageText) ->
    try
      object = JSON.parse(messageText)
      return true
    catch error
      return false

  destroy: ->
