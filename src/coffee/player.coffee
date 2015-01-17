world = require './world'

player =
  position:
    x: 0
    y: world.height / 2
  velocity:
    x: 1
    y: 0
  rotation: 0
  mass: 1

module.exports = player
