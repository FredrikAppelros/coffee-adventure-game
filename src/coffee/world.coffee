Entity = require './entity'

class World extends Entity
  constructor: (asset) ->
    super asset, 12, 9

module.exports = World
