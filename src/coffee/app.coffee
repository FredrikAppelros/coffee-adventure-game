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

init = ([assets, sounds]) ->
  camera = new Camera canvas
  world = new World assets.world
  entities =
    world: world
    ground: new Ground assets.ground
    player: new Player assets.bird
    stacks: []
  simulator = new Simulator camera, entities, assets
  renderer = new Renderer camera, entities, canvas, drawSpriteBounds

  main = ->
    now = new Date
    dt += (now - last) / 1000
    last = now

    while dt >= simulator.dt
      simulator.simulate state, flapping
      flapping = false
      dt -= simulator.dt

    renderer.render state, score

    window.requestAnimationFrame main

  reset = ->
    player = entities.player
    player.position.x = 0
    player.position.y = 5
    player.rotation = 0
    player.velocity.x = 0
    player.velocity.y = 0
    player.velocity.rot = 0
    player.acceleration.x = 0.1

    # Perhaps we should create some stacks of crates first...
    s.move 7 + i * 5 for s, i in entities.stacks

    score = 0
    dt = 0
    last = new Date

  start = ->
    reset()
    entities.player.velocity.x = 2

  onClick = (event) ->
    flapping = true
    unless state is 'playing'
      start()
      state = 'playing'

    event.stopPropagation()

  onCollision = ->
    state = 'over'
    canvas.removeEventListener 'click', onClick
    setTimeout (->
      canvas.addEventListener 'click', onClick
      state = 'ready'
    ), 1000

  onScore = ->
    score++

  canvas.addEventListener 'click', onClick
  simulator.on 'collision', onCollision
  simulator.on 'score', onScore

  reset()
  main()

Q.all([asset.loadAssets(), sound.loadSounds()]).then init
