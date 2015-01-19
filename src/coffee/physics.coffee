events = require 'events'
World = require './world'
Ground = require './ground'

class Simulator extends events.EventEmitter
  constructor: (@camera, @entities, @assets, @gravity = -20, hz = 100) ->
    @dt = 1 / hz
    @flapForce = 5 * hz

  detectCollisions: ->
    ground = @entities.ground
    player = @entities.player

    collided = ground.hasCollided player
    for stack in @entities.stacks
      collided = collided or c.hasCollided player for c in stack.crates

    if collided
      player.velocity.y = 0
      player.velocity.rot = Math.PI * 3

    @emit 'collision' if collided

  simulate: (state, flapping) ->
    player = @entities.player

    force = if flapping then @flapForce else 0

    a = force / player.mass + @gravity

    player.velocity.y = 0 if player.velocity.y < 0 and a > 0

    player.velocity.y += a * @dt unless state is 'start'

    if player.velocity.y < -25
      player.velocity.y = -25
    if player.velocity.y > 12
      player.velocity.y = 12

    player.position.x += player.velocity.x * @dt
    player.position.y += player.velocity.y * @dt

    player.rotation += player.velocity.rot * @dt

    @detectCollisions() if state is 'playing'

    if player.position.y < @entities.ground.height
      player.position.y = @entities.ground.height
      player.velocity.x = 0
      player.velocity.rot = 0
    if player.position.y > @camera.gameHeight - player.height
      player.position.y = @camera.gameHeight - player.height
      player.velocity.y = 0

    for stack in @entities.stacks
      if state is 'playing' and not stack.cleared and player.position.x >= stack.pos
        stack.cleared = true
        @emit 'score'
      if stack.cleared and not stack.isVisible @camera, player
        stack.move stack.pos + 15

module.exports = Simulator
