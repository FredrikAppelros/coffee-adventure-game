world = require './world'

player =
  width: 1
  height: 1
  position:
    x: 0
    y: world.height / 2
  velocity:
    x: 2
    y: 0
  rotation: 0
  mass: 1

module.exports = player
