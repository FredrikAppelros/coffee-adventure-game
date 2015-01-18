class Entity
  constructor: (@asset, @width, @height, @position, @rotation = 0) ->

  draw: (ctx, camera, stroke, player, repeat, distance) ->
    w = camera.toScreenX @width
    h = camera.toScreenY @height
    x = 0
    if player?
      if repeat
        x = -camera.toScreenX(player.position.x / distance) % w
      else
        x = camera.toScreenX(@position.x - player.position.x + (camera.gameWidth - player.width) / 2)
    else
      x = camera.toScreenX(camera.gameWidth - @width ) / 2
    y = camera.toScreenY(camera.gameHeight - @position.y) - h

    if @rotation != 0
      tx = x + @asset.width / 2
      ty = y + @asset.height / 2
      ctx.translate tx, ty
      ctx.rotate @rotation
      ctx.translate -tx, -ty

    if repeat
      while x < camera.screenWidth
        @asset.draw ctx, x, y, w, h
        ctx.strokeRect x, y, w, h if stroke
        x += w
    else
      @asset.draw ctx, x, y, w, h
      ctx.strokeRect x, y, w, h if stroke

    ctx.resetTransform()

  hasCollided: (other) -> throw new Error 'Not implemented'

module.exports = Entity
