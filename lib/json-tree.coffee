parseJSONP = require './parse-jsonp'


defaults =
  classPrefix: 'jt_'
  shouldCollapse: require './should-collapse'
  onParsed: ->
  onFormatted: ->


module.exports = (text, options) ->
  # Normalise arguments

  if not options?
    options = defaults
  else for own k, v of defaults
    options[k] = v if not options[k]?

  info = parseJSONP(text)
  console.log(info)

  # Call the onParsed callback now that there is a result
  setTimeout ->
    options.onParsed(info.err, info.value, info.jsonpCallback) if options.onParsed?
  , 0

  unless info.err?
    setTimeout ->
      # Get a formatValue function primed with our collapse function
      prefix = options.classPrefix || ''
      formatValue = require('./format-value')(options.shouldCollapse, prefix)
      # Format object (using recursive valueCont builder)
      rootValueCont = formatValue(info.value, null, 0, false)

      # The whole DOM is now built.

      # Set class on root node to identify it
      rootValueCont.classList.add prefix + 'root'

      # Make div.formattedJson and append the root valueCont
      divFormattedJson = document.createElement('DIV')
      divFormattedJson.className = prefix + 'json-tree'
      divFormattedJson.appendChild rootValueCont

      # Convert it to an HTML string (shame about this step, but necessary for passing it through to the content page)
      html = divFormattedJson.outerHTML


      # Top and tail with JSONP padding if necessary
      if info.jsonpCallback?
        html = (
          '<div class="' + prefix + 'jsonp-opener">' + info.jsonpCallback + '( </div>' +
          html +
          '<div class="' + prefix + 'jsonp-closer">)</div>'
        )

      # Wrap the whole lot
      html = '<div class="' + prefix + 'json-tree-cont">' + html + '</div>'

      # Pass result to callback
      options.onFormatted(null, html, info.jsonpCallback) if options.onFormatted?
    , 0
