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

start = ([assets, sounds]) ->
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
    player.velocity.y = 0
    player.velocity.rot = 0

    entities.stacks = (new Stack assets.crate, world for i in [0...3])
    s.move 7 + i * 5 for s, i in entities.stacks

    score = 0
    dt = 0
    last = new Date

  onClick = (event) ->
    flapping = true
    sounds.flap.play()
    unless state is 'playing'
      reset()
      entities.player.velocity.x = 2
      state = 'playing'

    event.stopPropagation()

  onCollision = ->
    state = 'over'
    sounds.collide.play()
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

Q.all([asset.loadAssets(), sound.loadSounds()]).then start
