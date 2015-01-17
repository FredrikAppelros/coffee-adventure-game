assets = require './assets'
Simulator = require './physics'
Renderer = require './renderer'

playing = true
flapping = false
score = 0

last = new Date
dt = 0

canvas = document.getElementById 'canvas'
simulator = new Simulator
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

start = (assets) ->
  renderer = new Renderer canvas, assets
  main()

onClick = (event) ->
  flapping = true
  event.stopPropagation()

onCollision = ->
  playing = false

onScore = ->
  score++

canvas.addEventListener 'click', onClick
simulator.on 'collision', onCollision
simulator.on 'score', onScore

assets.loadAssets start
