Entity = require './entity'

class World extends Entity
  constructor: (asset) ->
    pos =
      x: 0
      y: 0
    super asset, 12, 9, pos

module.exports = World
