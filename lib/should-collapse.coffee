###
  The default shouldCollapse function, used to decide whether a given array/object should start out collapsed.

  TODO: this needs to be cleverer. Base decision on bredth of the current thing AND bredth of the parent collection (ie, if this one has loads of siblings that are also collections, maybe determine how much height you'd save by making all of them collapsed).

###

nativeKeys = (typeof Object.keys is 'function')
maxBredth = 20
maxDepth = 10

module.exports = (collection, isArray, currentDepth) ->
  if currentDepth > maxDepth
    return true
  if isArray
    if collection.length > maxBredth
      return true
  else
    if nativeKeys
      console.log 'shouldCollapse', collection
      if Object.keys(collection).length > maxBredth
        return true
    else
      size = 0
      size++ for own k of object
      if Object.keys(collection).length > maxBredth
        return true
  return false
