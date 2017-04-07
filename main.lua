local Game = require "obj.game"
local Input = require "obj.input"

function sol.onLoad()
  Game.init(G.width, G.height)
  Input.register({
    ["left"]    = {"left", "a"},
    ["right"]   = {"right", "d"},
    ["up"]      = {"up", "w"},
    ["down"]    = {"down", "s"},
    ["jump"]    = {"space", "x"},
    ["select"]  = {"return", "space", "x", "c"},
    ["pause"]   = {"escape", "p"},
    ["action"]  = {"c"},
    ["mute"]    = {"m"},
  })
end

function sol.onUpdate(dt)
  Game.update(dt)
end

function sol.onDraw()
  Game.draw()
end

function sol.onKeyDown(key, char)
  Game.key(key, char)
end
