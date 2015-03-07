Entity = require './entity'

class Ground extends Entity
  constructor: (asset) ->
    super asset, 1, 1

  hasCollided: (other) ->
    false # We never collide!

module.exports = Ground
