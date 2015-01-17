world = require './world'
ground = require './ground'
crates = require './crates'
player = require './player'

class Renderer
  constructor: (@canvas, @assets) ->
    @offsetX = (@canvas.width - @assets.bird.width) / 2
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

  drawCyclic: (asset, y, distance) ->
    x = -(player.position.x / world.width / distance * @canvas.width) % asset.width

    while x < @canvas.width
      asset.draw @ctx, x, y
      x += asset.width

  drawBackground: ->
    @drawCyclic @assets.background, 0, 2

  drawGround: ->
    y = (world.height - ground.height) / world.height * @canvas.height
    @drawCyclic @assets.ground, y, 1

  drawCrates: ->
    asset = @assets.crate

    size = crates.height / world.height * @canvas.height
    x = (crates.position.x - player.position.x) / world.width * @canvas.width + @offsetX

    y = 0
    for i in [0...crates.top]
      asset.draw @ctx, x, y, size, size
      y += size

    y = (world.height - ground.height - crates.height) / world.height * @canvas.height
    for i in [0...crates.bottom]
      asset.draw @ctx, x, y, size, size
      y -= size

  drawPlayer: ->
    x = @offsetX
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
