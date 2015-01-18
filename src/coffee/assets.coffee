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

  draw: (ctx, sx, sy, sw, sh, dx, dy, dw, dh) ->
    if dx?
      ctx.drawImage @sprite, sx, sy, sw, sh, dx, dy, dw, dh
    else if sw?
      ctx.drawImage @sprite, sx, sy, sw, sh
    else
      ctx.drawImage @sprite, sx, sy

assets =
  world: new Asset 'img/world.png'
  ground: new Asset 'img/ground.png'
  bird: new Asset 'img/bird.png'
  crate: new Asset 'img/crate.png'

loadAssets = (callback) ->
  promises = (a.promise for name, a of assets)
  Q.all(promises).then ->
    callback assets

exports.loadAssets = loadAssets
