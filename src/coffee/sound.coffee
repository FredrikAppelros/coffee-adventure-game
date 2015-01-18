Q = require 'q'

ctx = new AudioContext

class Sound
  constructor: (src) ->
    @promise = Q.Promise (resolve) =>
      request = new XMLHttpRequest
      request.open 'GET', src, true
      request.responseType = 'arraybuffer'

      request.addEventListener 'load', =>
        ctx.decodeAudioData request.response, (buffer) =>
          @buffer = buffer
          resolve this

      request.send()

  play: ->
    source = ctx.createBufferSource()
    source.buffer = @buffer
    source.connect ctx.destination
    source.start 0

sounds =
  flap: new Sound 'sounds/flap.wav'
  collide: new Sound 'sounds/collide.wav'

loadSounds = ->
  Q.all(s.promise for name, s of sounds).then -> sounds

exports.loadSounds = loadSounds
