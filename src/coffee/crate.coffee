Entity = require './entity'
random = require './random'

class Crate extends Entity
  constructor: (asset) ->
    super asset, 1, 1

  hasCollided: (other) ->
    other.position.x >= @position.x - other.width and
    other.position.x < @position.x + @width and
    other.position.y >= @position.y - other.height and
    other.position.y < @position.y + @height

class Stack
  constructor: (asset, world, @pos = 0, gap = 3) ->
    @maxHeight = world.height - 1
    @height = @maxHeight - gap
    @crates = (new Crate asset for i in [0...@height])

  move: (pos) ->
    @pos = pos
    @cleared = false

    top = random.randInt @height
    bottom = @height - top

    for i in [0...top]
      crate = @crates[i]
      crate.position.x = @pos
      crate.position.y = @maxHeight - i
    for i in [0...bottom]
      crate = @crates[top + i]
      crate.position.x = @pos
      crate.position.y = i + 1

  isVisible: (camera, player) ->
    offset = (camera.gameWidth - player.width) / 2 + @crates[0].width
    @pos >= player.position.x - offset and
    @pos < player.position.x + offset

module.exports = Stack
