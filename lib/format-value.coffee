###
  Recursive function that returns the HTML for a single JSON value (including its corresponding key, if applicable).
  (The HTML it returns is a "valueCont" element.)

  collection - an array or object
  options - object
    collapse - function that will be passed the bredth and depth of the current collection, and should
      return true/false depending on whether this node should now collapse
  depth - integer saying how deep we currently are
  collapsed - whether the parent node is already collapsed (in which case this one is automatically collapsed)
###

module.exports = (shouldCollapse, prefix) ->
  # Build templates
  baseSpan = document.createElement("span")
  getSpan = (className, text) ->
    span = baseSpan.cloneNode(false)
    span.className = prefix + className
    span.innerText = text if text?
    span
  t_valueCont      = getSpan 'value-cont'
  t_collapser      = getSpan 'collapser'
  t_key            = getSpan 'key'
  t_string         = getSpan 'string'
  t_number         = getSpan 'number'
  t_null           = getSpan 'null', 'null'
  t_true           = getSpan 'boolean', 'true'
  t_false          = getSpan 'boolean', 'false'
  t_oBrace         = getSpan 'bracket', '{'
  t_cBrace         = getSpan 'bracket', '}'
  t_oSquareBracket = getSpan 'bracket', '['
  t_cSquareBracket = getSpan 'bracket', ']'
  t_ellipsis       = getSpan 'ellipsis'
  t_blockInner     = getSpan 'block-inner'
  t_colonAndSpace  = document.createTextNode ': '
  t_commaText      = document.createTextNode ','
  t_dblqText       = document.createTextNode '\"'

  formatValue = (value, keyName, depth) ->
    # Establish value type
    type = typeof value
    switch type
      when 'object'
        switch value
          # when true, false
          #   type = 'boolean'
          when null
            type = 'null'
          else
            if Array.isArray value
              type = 'array'
      when 'string', 'number', 'boolean'
      else throw new Error "Unexpected type: #{type}"

    # Root node for this valueCont
    valueCont = t_valueCont.cloneNode(false)

    # Add an 'expander' first (if this is object/array with non-zero size)
    switch type
      when 'object', 'array'
        nonZeroSize = false
        for own k of value
          nonZeroSize = true
          break # no need to keep counting; only need one
        valueCont.appendChild t_collapser.cloneNode(false) if nonZeroSize

        # Add the `collapsed` class if necessary
        if shouldCollapse
          if shouldCollapse == true || shouldCollapse(value, (type == 'array'), depth)
            valueCont.classList.add prefix + 'collapsed'

    # If there's a key, add that before the value
    if typeof keyName is 'string' # "" is a legal name, apparently
      # This valueCont must be an object property
      valueCont.classList.add "object-property"
      
      # Create a span for the key name
      keySpan = t_key.cloneNode(false)
      keySpan.textContent = JSON.stringify(keyName).slice(1, -1) # remove quotes
      # Add it to valueCont, with quote marks
      valueCont.appendChild t_dblqText.cloneNode(false)
      valueCont.appendChild keySpan
      valueCont.appendChild t_dblqText.cloneNode(false)
      
      # Also add ":&nbsp;" (colon and non-breaking space)
      valueCont.appendChild t_colonAndSpace.cloneNode(false)
    else
      
      # This is an array element instead
      valueCont.classList.add "array-element"
    
    # Generate DOM for this value
    switch type
      when 'string'
        # If string is a URL, get a link, otherwise get a span
        innerStringEl = baseSpan.cloneNode(false)
        escapedString = JSON.stringify(value)
        escapedString = escapedString.substring(1, escapedString.length - 1) # remove quotes
        if (
          value.charAt(0) is "h" &&
          (value.substring(0, 7) is 'http://' || value.substring(0, 8) is 'https://')
        )
          innerStringA = document.createElement("A")
          innerStringA.className = prefix + 'link'
          innerStringA.href = value
          innerStringA.innerText = escapedString
          innerStringEl.appendChild innerStringA
        else
          innerStringEl.innerText = escapedString
        valueElement = t_string.cloneNode(false)
        valueElement.appendChild t_dblqText.cloneNode(false)
        valueElement.appendChild innerStringEl
        valueElement.appendChild t_dblqText.cloneNode(false)
        valueCont.appendChild valueElement

      when 'number'
        # Simply add a number element (span.n)
        valueElement = t_number.cloneNode(false)
        valueElement.innerText = value
        valueCont.appendChild valueElement

      when 'object'
        # Add opening brace
        valueCont.appendChild t_oBrace.cloneNode(true)
        
        # If any properties, add a blockInner containing k/v pair(s)
        if nonZeroSize
          
          # Add ellipsis (empty, but will be made to do something when valueCont is collapsed)
          valueCont.appendChild t_ellipsis.cloneNode(false)
          
          # Create blockInner, which indents (don't attach yet)
          blockInner = t_blockInner.cloneNode(false)
          
          # For each key/value pair, add as a valueCont to blockInner
          comma = null
          childValueCont = null
          for own k, v of value
            childValueCont = formatValue(v, k, depth + 1, false)
            
            # Add comma
            comma = t_commaText.cloneNode()
            childValueCont.appendChild comma
            blockInner.appendChild childValueCont
          
          # Now remove the last comma
          childValueCont.removeChild comma
          
          # Add blockInner
          valueCont.appendChild blockInner
        
        # Add closing brace
        valueCont.appendChild t_cBrace.cloneNode(true)

      when 'array'
        
        # Add opening bracket
        valueCont.appendChild t_oSquareBracket.cloneNode(true)
        
        # If non-zero length array, add blockInner containing inner vals
        if nonZeroSize
          
          # Add ellipsis
          valueCont.appendChild t_ellipsis.cloneNode(false)
          
          # Create blockInner (which indents) (don't attach yet)
          blockInner = t_blockInner.cloneNode(false)
          
          # For each key/value pair, add the markup
          i = 0
          length = value.length
          lastIndex = length - 1
          while i < length
            # Make a new valueCont, with no key
            childValueCont = formatValue(value[i], null, depth + 1, false)
            
            # Add comma if not last one
            childValueCont.appendChild t_commaText.cloneNode()  if i < lastIndex
            
            # Append the child valueCont
            blockInner.appendChild childValueCont
            i++
          
          # Add blockInner
          valueCont.appendChild blockInner
        
        # Add closing bracket
        valueCont.appendChild t_cSquareBracket.cloneNode(true)

      when 'boolean'
        if value
          valueCont.appendChild t_true.cloneNode(true)
        else
          valueCont.appendChild t_false.cloneNode(true)

      when 'null'
        valueCont.appendChild t_null.cloneNode(true)

    return valueCont

  return formatValue
