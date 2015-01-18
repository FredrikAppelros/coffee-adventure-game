Entity = require './entity'

class Player extends Entity
  constructor: (asset) ->
    pos =
      x: 0
      y: 5
    super asset, 1, 1, pos

    @velocity =
      x: 2
      y: 0
    @mass = 1

module.exports = Player
