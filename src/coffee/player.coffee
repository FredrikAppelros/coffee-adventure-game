Entity = require './entity'

class Player extends Entity
  constructor: (asset) ->
    super asset, 1, 1

    @velocity =
      x: 2
      y: 0
    @mass = 1

module.exports = Player
