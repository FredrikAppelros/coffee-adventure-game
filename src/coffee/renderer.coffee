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

  drawRepeated: (entity, distance) ->
    entity.draw @ctx, @camera, @drawSpriteBounds, @entities.player, true, distance

  drawBackground: ->
    @drawRepeated @entities.world, 2

  drawGround: ->
    @drawRepeated @entities.ground, 1

  drawCrates: ->
    for stack in @entities.stacks
      c.draw @ctx, @camera, @drawSpriteBounds, @entities.player, false for c in stack.crates

  drawPlayer: ->
    @entities.player.draw @ctx, @camera, @drawSpriteBounds

  drawUI: (score, playing) ->
    @drawText score, 40, 20
    @drawText 'Game Over', 80, (@canvas.height - 80) / 2 if not playing

  render: (score, playing) ->
    @drawBackground()
    @drawGround()
    @drawCrates()
    @drawPlayer()
    @drawUI score, playing

module.exports = Renderer
