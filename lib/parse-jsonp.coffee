###
  This synchronous function accepts a string of either JSON or JSONP, and returns an object detailing it.

  Returned object has these properties:

    - err - string, only if an err was encountered
    - jsonpCallback eg 'app.load' or whatever, or null
    - value - the parsed JSON object/array
###

stripComments = require './strip-comments'

firstJSONCharIndex = (s) ->
  arrayIdx = s.indexOf("[")
  objIdx = s.indexOf("{")
  idx = 0
  idx = arrayIdx  if arrayIdx isnt -1
  if objIdx isnt -1
    if arrayIdx is -1
      idx = objIdx
    else
      idx = Math.min(objIdx, arrayIdx)
  idx

module.exports = (text) ->
  switch typeof text
    when 'object', 'array'
      return {
        jsonpCallback: null
        err: null
        value: text
      }
    when 'string'
    else throw new Error 'Expected string, object or array'

  result =
    err: null
    jsonpCallback: null
    value: null
  strippedText = text.substring(firstJSONCharIndex(text))


  try
    result.value = JSON.parse(strippedText)

  catch e

    # Not JSON; could still be JSONP though...
    # Try stripping 'padding' (if any), and try parsing it again

    # First strip whitespace
    text = text.trim()

    # Find where the first paren is (and exit if none)
    indexOfParen = text.indexOf("(")
    if not indexOfParen
      result.err = 'NOT JSON'
      return result
    
    # Get the substring up to the first "(", with any comments/whitespace stripped out

    firstBit = stripComments(text.substring(0, indexOfParen)).trim()

    unless firstBit.match(/^[a-zA-Z_$][\.\[\]'"0-9a-zA-Z_$]*$/)
      
      # The 'firstBit' is NOT a valid function identifier.
      result.err = 'NOT JSON(P): first bit not a valid function name'
      return result
    
    # Find last parenthesis (exit if none)
    indexOfLastParen = undefined
    unless indexOfLastParen = text.lastIndexOf(")")
      result.err = 'NOT JSON(P): no closing paren'
      return result
    
    # Check that what's after the last parenthesis is just whitespace, comments, and possibly a semicolon (exit if anything else)
    lastBit = stripComments(text.substring(indexOfLastParen + 1)).trim()
    if lastBit isnt '' and lastBit isnt ';'
      result.err = 'NOT JSON(P): last closing paren followed by invalid characters'
      return result
    
    # So, it looks like a valid JS function call, but we don't know whether it's JSON inside the parentheses...
    # Check if the 'argument' is actually JSON (and record the parsed result)
    text = text.substring(indexOfParen + 1, indexOfLastParen)
    try
      result.value = JSON.parse(text)

      # validJsonText = text
    catch e2
      
      # It's just some other text that happens to be inside what looks like a function call.
      # Respond as not JSON, and exit
      result.err = 'NOT JSON(P): looks like a function call, but the parameter is not valid JSON'
      return result

    result.jsonpCallback = firstBit
  
  # If still running, we now have result.value, which is valid JSON.
  
  # Ensure it's not a number or string (technically valid JSON, but we're only interested in objects and arrays)
  switch typeof result.value
    when 'object', 'array'
    else
      result.err = 'NOT JSON(P): technically JSON, but not an object or array'
      return result
  
  return result
