world = require './world'
ground = require './ground'

crates =
  width: 1
  height: 1
  position:
    x: world.width
    y: ground.height
  top: 2
  bottom: 2
  cleared: false

module.exports = crates
