Q = require 'q'

class Asset
  constructor: (src) ->
    @promise = Q.Promise (resolve) =>
      img = new Image
      img.src = src
      img.addEventListener 'load', =>
        @sprite = img
        @width = img.width
        @height = img.height
        resolve this

  draw: (ctx, x, y, w, h) ->
    ctx.drawImage @sprite, x, y, w, h

assets =
  world: new Asset 'img/world.png'
  ground: new Asset 'img/ground.png'
  bird: new Asset 'img/bird.png'
  crate: new Asset 'img/crate.png'

loadAssets = ->
  Q.all(a.promise for name, a of assets).then -> assets

exports.loadAssets = loadAssets
