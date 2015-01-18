assets = require './assets'
Camera = require './camera'
World = require './world'
Ground = require './ground'
Player = require './player'
crate = require './crate'
Simulator = require './physics'
Renderer = require './renderer'

playing = true
flapping = false
drawSpriteBounds = false
score = 0

last = new Date
dt = 0

canvas = document.getElementById 'canvas'
player = undefined
simulator = undefined
renderer = undefined

main = ->
  now = new Date
  dt += (now - last) / 1000
  last = now

  while playing and dt >= simulator.dt
    simulator.simulate flapping
    flapping = false
    dt -= simulator.dt

  renderer.render score, playing

  window.requestAnimationFrame main if playing

onClick = (event) ->
  flapping = true
  event.stopPropagation()

onCollision = ->
  playing = false

onScore = ->
  score++

start = (assets) ->
  camera = new Camera canvas
  entities =
    world: new World assets.world
    ground: new Ground assets.ground
    player: new Player assets.bird
    stacks: [
      crate.spawnStack(assets.crate, 7)
      crate.spawnStack(assets.crate, 12)
      crate.spawnStack(assets.crate, 17)
    ]

  simulator = new Simulator camera, entities, assets
  renderer = new Renderer camera, entities, canvas, drawSpriteBounds

  canvas.addEventListener 'click', onClick
  simulator.on 'collision', onCollision
  simulator.on 'score', onScore

  main()

assets.loadAssets start
