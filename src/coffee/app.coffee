Q = require 'q'
asset = require './asset'
sound = require './sound'
Camera = require './camera'
World = require './world'
Ground = require './ground'
Player = require './player'
Stack = require './crate'
Simulator = require './physics'
Renderer = require './renderer'

flapping = false
drawSpriteBounds = false

score = 0
last = 0
dt = 0

state = 'start'

canvas = document.getElementById 'canvas'
entities = undefined
simulator = undefined
renderer = undefined

main = ->
  now = new Date
  dt += (now - last) / 1000
  last = now

  while state is 'playing' and dt >= simulator.dt
    simulator.simulate flapping
    flapping = false
    dt -= simulator.dt

  renderer.render state, score

  window.requestAnimationFrame main

reset = ->
  entities.player.position.x = 0
  entities.player.position.y = 5
  entities.player.velocity.y = 0
  s.move 7 + i * 5 for s, i in entities.stacks
  score = 0
  dt = 0
  last = new Date

start = ([assets, sounds]) ->
  camera = new Camera canvas
  world = new World assets.world
  entities =
    world: world
    ground: new Ground assets.ground
    player: new Player assets.bird
    stacks: [
      new Stack assets.crate, world
      new Stack assets.crate, world
      new Stack assets.crate, world
    ]
  simulator = new Simulator camera, entities, assets
  renderer = new Renderer camera, entities, canvas, drawSpriteBounds

  reset()

  onClick = (event) ->
    flapping = true
    sounds.flap.play()
    unless state is 'playing'
      reset()
      state = 'playing'

    event.stopPropagation()

  onCollision = ->
    state = 'over'
    sounds.collide.play()

  onScore = ->
    score++

  canvas.addEventListener 'click', onClick
  simulator.on 'collision', onCollision
  simulator.on 'score', onScore

  main()

Q.all([asset.loadAssets(), sound.loadSounds()]).then start
