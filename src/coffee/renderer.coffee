class Renderer
  constructor: (@camera, @entities, @canvas) ->
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
    entity.draw @ctx, @camera, 'endless', @entities.player, distance

  drawBackground: ->
    @drawEndless @entities.world, 2

  drawGround: ->
    @drawEndless @entities.ground, 1

  drawCrates: ->
    for stack in @entities.stacks
      if stack.isVisible @camera, @entities.player
        for c in stack.crates
          c.draw @ctx, @camera, 'moving', @entities.player

  drawPlayer: ->
    @entities.player.draw @ctx, @camera, 'player'

  drawUI: (state, score) ->
    # We could draw some text here!

  render: (state, score) ->
    @drawBackground()
    @drawGround()
    @drawCrates()
    @drawPlayer()
    @drawUI state, score

module.exports = Renderer
