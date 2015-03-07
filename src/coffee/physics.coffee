events = require 'events'
World = require './world'
Ground = require './ground'

class Simulator extends events.EventEmitter
  constructor: (@camera, @entities, @assets, @gravity = -20, hz = 100) ->
    @dt = 1 / hz
    @flapForce = 5 * hz

  simulate: (state, flapping) ->
    player = @entities.player

    @calculateAcceleration flapping
    @calculateVelocity state
    @calculatePosition state

    for stack in @entities.stacks
      if state is 'playing' and not stack.cleared and player.position.x >= stack.pos
        stack.cleared = true
        @emit 'score'
      # Sometimes, the stacks need to move

  calculateAcceleration: (flapping) ->
    player = @entities.player
    force = if flapping then @flapForce else 0
    player.acceleration.y = 0 # This doesn't seem right...

  calculateVelocity: (state) ->
    player = @entities.player
    player.velocity.x += player.acceleration.x * @dt unless state is 'start'
    player.velocity.y = 0 if player.velocity.y < 0 and player.acceleration.y > 0
    player.velocity.y += player.acceleration.y * @dt unless state is 'start'
    player.velocity.y = Math.max(player.velocity.y, -25)
    player.velocity.y = Math.min(player.velocity.y, 12)

  calculatePosition: (state) ->
    player = @entities.player
    # Hmmm, seems like something is missing here
    player.position.y += player.velocity.y * @dt
    player.rotation += player.velocity.rot * @dt

    @detectCollisions() if state is 'playing'

    if player.position.y < @entities.ground.height
      player.position.y = @entities.ground.height
      player.acceleration.x = 0
      player.velocity.x = 0
      player.velocity.rot = 0
    if player.position.y > @camera.gameHeight - player.height
      player.position.y = @camera.gameHeight - player.height
      player.velocity.y = 0

  detectCollisions: ->
    player = @entities.player

    collided = false # Hmm, we should probably do something here

    if collided
      player.velocity.y = 0
      player.velocity.rot = Math.PI * 3

    @emit 'collision' if collided

module.exports = Simulator
