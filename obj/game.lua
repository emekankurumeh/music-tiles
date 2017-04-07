local Game = require "lib.classic"
local _  = require "lib.lume"
local shash = require "lib.shash"
local Rect = require "obj.rect"
local Color = require "obj.color"

function Game:new()
  error("use Game.init() instead")
end

function Game.init(width, height, color)
  Game.bgcolor = {.15, .15, .15}
  -- Game.bgcolor = Color[color] and Color[color] or Color["dark-grey"]
  Game.width = width or G.width
  Game.height = height or G.height
  Game.framebuffer = sol.Buffer.fromBlank(G.width, G.height)
  Game.postbuffer = Game.framebuffer:clone()
  local Camera = require "obj.camera"
  Game.camera = Camera(0, 0)
  local Save = require "obj.save"
  Game.save = Save("save.dat", {})
  Game.group = shash.new(2)
  Game.cursor = Rect(sol.mouse.getX(),sol.mouse.getY(), 16, 16)
  Game.add(Game.cursor, Game.cursor.x, Game.cursor.y, Game.cursor.width, Game.cursor.height)
  Game.tile = {}
  for x = 0, 3 do
    Game.tile[x + 1] = {}
    for y = 0, 3 do
      local tile = Rect(x * 128, y * 128, 128, 128)
      Game.add(tile, tile.x, tile.y, tile.width, tile.height)
      tile.color = Color[x + 1][y + 1]
      Game.tile[x + 1][y + 1] = tile
    end
  end
end

function Game.add(e)
  if not e then error("expected entity") end
  Game.group:add(e, e.x, e.y, e.width, e.height)
end

function Game.remove(e)
  if not e then error("expected entity") end
  Game.group:remove(e)
end

function Game.update(dt)
  require("lib.stalker").update()
  Game.camera:update()
  Game.cursor:set(sol.mouse.getPosition())
  Game.group:each(Game.cursor, function(obj)
    if sol.mouse.isDown("left") then
      Game.cursor:reject(obj)
      obj:reject(Game.cursor)
    end
  end)
  collectgarbage()
  collectgarbage()
end

function Game.draw()
  Game.postbuffer = Game.framebuffer:clone()
  Game.framebuffer:clear(unpack(Game.bgcolor))
  Game.framebuffer:reset()
  -- do drawing of members
  for x = 1, 4 do
    for y = 1, 4 do
      local tile = Game.tile[x][y]
      Game.framebuffer:drawRect(tile.x, tile.y, tile.width, tile.height, unpack(tile.color))
    end
  end
  -- Game.framebuffer:drawBox(Game.cursor.x, Game.cursor.y, Game.cursor.width, Game.cursor.height)
  sol.graphics.copyPixels(Game.framebuffer, 0, 0)
end

function Game.key(key, char)
  if key == "tab" then
    local mode = not sol.debug.getVisible()
    sol.debug.setVisible(G.debug and mode)
  elseif key == "`" then
    local mode = not sol.debug.getFocused()
    sol.debug.setFocused(G.debug and mode)
  elseif key == "escape" then
    sol.system.quit()
  elseif key == "r" and G.debug then
    sol.onLoad()
  end
end

return Game
