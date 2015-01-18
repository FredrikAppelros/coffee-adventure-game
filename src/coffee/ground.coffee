Entity = require './entity'

class Ground extends Entity
  constructor: (asset) ->
    pos =
      x: 0
      y: 0
    super asset, 1, 1, pos

  hasCollided: (other) ->
    other.position.y < @position.y + @height

module.exports = Ground
