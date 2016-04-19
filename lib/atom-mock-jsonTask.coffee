module.exports =
class JsonTask

  constructor:  ->

  serialize: ->
    console.log("我")

  diffJson:(messageText) ->
    try
      object = JSON.parse(messageText)
      return true
    catch error
      return false

  destroy: ->
