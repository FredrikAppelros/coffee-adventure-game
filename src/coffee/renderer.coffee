world = require './world'
player = require './player'

class Renderer
  constructor: (@canvas, @assets) ->
    @ratio = @canvas.width / @canvas.height
    @ctx = @canvas.getContext '2d'
    @ctx.fillStyle = '#fff'
    @ctx.strokeStyle = '#000'
    @ctx.lineWidth = 4

  drawCyclic: (asset, height, distance) ->
    sx = ((player.position.x % (world.width * distance)) / (world.width * distance)) * asset.width
    sy = 0
    sw = asset.width / @ratio
    sh = asset.height
    dx = 0
    dy = @canvas.height - height
    dw = @canvas.width
    dh = height

    if sx + sw > asset.width
      osw = sw
      odw = dw
      sw = asset.width - sx
      dw = sw / osw * @canvas.width
      asset.draw @ctx, sx, sy, sw, sh, dx, dy, dw, dh
      sx = 0
      sw = osw - sw
      dx = dw
      dw = odw - dw

    asset.draw @ctx, sx, sy, sw, sh, dx, dy, dw, dh

  drawText: (text, size, pos) ->
      @ctx.font = size + 'px game-font'
      measure = @ctx.measureText text

      x = (@canvas.width - measure.width) / 2
      y = size + pos

      @ctx.fillText text, x, y
      @ctx.strokeText text, x, y

  drawBackground: ->
    @drawCyclic @assets.background, @canvas.height, 2

  drawGround: ->
    @drawCyclic @assets.ground, @canvas.height / 10, 1

  drawCrates: ->

  drawPlayer: ->
    x = (@canvas.width - @assets.bird.width) / 2
    y = (1 - (player.position.y / world.height)) * (@canvas.height - @assets.bird.height)

    tx = x + @assets.bird.width / 2
    ty = y + @assets.bird.height / 2
    @ctx.translate tx, ty
    @ctx.rotate player.rotation
    @ctx.translate -tx, -ty

    @assets.bird.draw @ctx, x, y

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
