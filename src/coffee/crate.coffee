Entity = require './entity'

class Crate extends Entity
  constructor: (asset, pos) ->
    super asset, 1, 1, pos

  hasCollided: (other) ->
    other.position.x >= @position.x - other.width and
    other.position.x < @position.x + @width and
    other.position.y >= @position.y - other.height and
    other.position.y < @position.y + @height

randInt = (max) ->
  Math.floor Math.random() * max

spawnStack = (asset, x, gap = 3) ->
  # TODO: base positions on sizes, not constants
  num = 8 - gap
  top = randInt num
  bottom = num - top

  crates = []
  for i in [0...top]
    pos =
      x: x
      y: 8 - i
    crate = new Crate asset, pos
    crates.push crate
  for i in [0...bottom]
    pos =
      x: x
      y: i + 1
    crate = new Crate asset, pos
    crates.push crate

  stack =
    pos: x
    cleared: false
    crates: crates

moveStack = (stack, x, gap = 3) ->
  num = 8 - gap
  top = randInt num
  bottom = num - top

  for i in [0...top]
    crate = stack.crates[i]
    crate.position.x = x
    crate.position.y = 8 - i
  for i in [0...bottom]
    crate = stack.crates[top + i]
    crate.position.x = x
    crate.position.y = i + 1

  stack.pos = x
  stack.cleared = false

exports.spawnStack = spawnStack
exports.moveStack = moveStack
