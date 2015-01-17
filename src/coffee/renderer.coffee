world = require './world'
player = require './player'

font =
  height: 40
  family: 'game-font'

class Renderer
  constructor: (@canvas, @assets) ->
    @ratio = @canvas.width / @canvas.height
    @ctx = @canvas.getContext '2d'
    @ctx.font = font.height + 'px ' + font.family
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

  drawScore: (score) ->
    text = @ctx.measureText score
    x = (@canvas.width - text.width) / 2
    y = font.height + 20

    @ctx.fillText score, x, y
    @ctx.strokeText score, x, y

  render: (score) ->
    @drawBackground()
    @drawGround()
    @drawCrates()
    @drawPlayer()
    @drawScore score

module.exports = Renderer
