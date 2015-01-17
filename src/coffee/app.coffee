assets = require './assets'
physics = require './physics'
Renderer = require './renderer'

playing = true
flapping = false
score = 0

last = new Date
dt = 0

canvas = document.getElementById 'canvas'
renderer = undefined

main = ->
  now = new Date
  dt += (now - last) / 1000
  last = now

  while dt >= physics.dt
    physics.simulate flapping
    flapping = false
    dt -= physics.dt

  renderer.render score

  window.requestAnimationFrame main

start = (assets) ->
  renderer = new Renderer canvas, assets
  main()

onClick = (event) ->
  flapping = true
  event.stopPropagation()

canvas.addEventListener 'click', onClick
assets.loadAssets start
