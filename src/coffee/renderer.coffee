class Renderer
  constructor: (@camera, @entities, @canvas, @drawSpriteBounds) ->
    @ctx = @canvas.getContext '2d'
    @ctx.fillStyle = '#fff'
    @ctx.strokeStyle = '#000'
    @ctx.lineWidth = 4

  drawText: (text, size, pos) ->
      @ctx.font = size + 'px game-font'
      measure = @ctx.measureText text

      x = (@canvas.width - measure.width) / 2
      y = size + pos

      @ctx.fillText text, x, y
      @ctx.strokeText text, x, y

  drawEndless: (entity, distance) ->
    entity.draw @ctx, @camera, @drawSpriteBounds, 'endless', @entities.player, distance

  drawBackground: ->
    @drawEndless @entities.world, 2

  drawGround: ->
    @drawEndless @entities.ground, 1

  drawCrates: ->
    for stack in @entities.stacks
      if stack.isVisible @camera, @entities.player
        for c in stack.crates
          c.draw @ctx, @camera, @drawSpriteBounds, 'moving', @entities.player

  drawPlayer: ->
    @entities.player.draw @ctx, @camera, @drawSpriteBounds, 'player'

  drawUI: (state, score) ->
    @drawText 'Tap to flap', 80, (@canvas.height - 80) / 2 if state is 'start'
    @drawText score, 40, 20 unless state is 'start'
    @drawText 'Game Over', 80, (@canvas.height - 80) / 2 if state is 'over'

  render: (state, score) ->
    @drawBackground()
    @drawGround()
    @drawCrates()
    @drawPlayer()
    @drawUI state, score

module.exports = Renderer
