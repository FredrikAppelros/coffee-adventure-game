events = require 'events'
world = require './world'
ground = require './ground'
crates = require './crates'
player = require './player'

class Simulator extends events.EventEmitter
  constructor: (@gravity = -20, hz = 100) ->
    @dt = 1 / hz
    @flapForce = 5 * hz

  detectCollisions: ->
    collided = player.position.y <= ground.height

    @emit 'collision' if collided

  simulate: (flapping) ->
    force = if flapping then @flapForce else 0

    a = force / player.mass + @gravity

    player.velocity.y = 0 if player.velocity.y < 0 and a > 0

    player.velocity.y += a * @dt

    if player.velocity.y < -25
      player.velocity.y = -25
    if player.velocity.y > 12
      player.velocity.y = 12

    player.position.x += player.velocity.x * @dt
    player.position.y += player.velocity.y * @dt

    if player.position.y < 0
      player.position.y = 0
      player.velocity.y = 0
    if player.position.y > world.height
      player.position.y = world.height
      player.velocity.y = 0

    if not crates.cleared and player.position.x >= crates.position.x
      crates.cleared = true
      @emit 'score'

    @detectCollisions()

module.exports = Simulator
