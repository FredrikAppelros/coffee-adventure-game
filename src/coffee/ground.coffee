Entity = require './entity'

class Ground extends Entity
  constructor: (asset) ->
    super asset, 1, 1

  hasCollided: (other) ->
    other.position.y < @position.y + @height

module.exports = Ground
