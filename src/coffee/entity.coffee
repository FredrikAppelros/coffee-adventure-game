class Entity
  constructor: (@asset, @width, @height) ->
    @position =
      x: 0
      y: 0
    @rotation = 0

  draw: (ctx, camera, type, player, distance) ->
    w = camera.toScreenX @width
    h = camera.toScreenY @height

    x = 0
    switch type
      when 'endless'
        x = -camera.toScreenX(player.position.x / distance) % w
      when 'moving'
        x = camera.toScreenX(@position.x - player.position.x + (camera.gameWidth - player.width) / 2)
      when 'player'
        x = camera.toScreenX(camera.gameWidth - @width ) / 2

    y = camera.toScreenY(camera.gameHeight - @position.y) - h

    if @rotation != 0
      tx = x + @asset.width / 2
      ty = y + @asset.height / 2
      ctx.translate tx, ty
      ctx.rotate @rotation
      ctx.translate -tx, -ty

    draw = =>
      @asset.draw ctx, x, y, w, h
      x += w

    draw()
    draw() while type is 'endless' and x < camera.screenWidth

    ctx.resetTransform()

  hasCollided: (other) -> throw new Error 'Not implemented'

module.exports = Entity
