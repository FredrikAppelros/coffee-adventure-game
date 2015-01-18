class Camera
  constructor: (@canvas, width = 12, height = 9) ->
    @gameWidth = width
    @gameHeight = height
    @screenWidth = @canvas.width
    @screenHeight = @canvas.height

  toScreenX: (x) ->
    x / @gameWidth * @screenWidth

  toScreenY: (y) ->
    y / @gameHeight * @screenHeight

module.exports = Camera
