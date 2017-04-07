local coil = require "lib.coil"
local _ = require "lib.lume"
local Entity = require "obj.entity"
local Game = require "obj.game"
local Rect = require "obj.rect"

local Camera = Entity:extend()

function Camera:new(x, y)
  Camera.super.new(self, 0, 0, Game.width, Game.height)
  self.scale = Rect(2, 2)
  self.shakeTimer = 0
  self.shakeAmount = 0
end

function Camera:shake(time, amount)
  self.shakeTimer = time
  self.shakeAmount = amount
end

function Camera:move(dx, dy)
  local x = self.x + (dx or 0)
  local y = self.y + (dy or 0)
  self:goTo(x, y)
end

function Camera:zoom(dsx, dsy)
  local dsx = dsx or 1
  self.scale.x = self.scale.x * dsx
  self.scale.y = self.scale.y * (dsy or dsx)
end

function Camera:setX(x)
  local x = self.bounds and _.clamp(x, 0, self.bounds.width) or x
  self:set(x)
end

function Camera:setY(y)
  local y = self.bounds and _.clamp(y, 0, self.bounds.height) or y
  self:set(nil, y)
end

function Camera:setWidth(width)
  self:set(nil, nil, width)
end

function Camera:setHeight(height)
  self:set(nil, nil, nil, height)
end

function Camera:goTo(x, y)
  self:setX(x)
  self:setY(y)
end

function Camera:resize(w, h)
  self:setWidth(w)
  self:setHeight(h)
end

function Camera:setScale(x, y)
  self.scale:set(x, y, nil, nil)
end

function Camera:getBounds()
  return (table.unpack or unpack)(self.bounds)
end

function Camera:setBounds(w, h)
  self.bounds = {
    width = w,
    height = h
  }
end

function Camera:update(dt)
  if self.shakeTimer ~= 0 then
    self.shakeTimer = self.shakeTimer - dt
    if self.shakeTimer <= 0 then
      self.shakeTimer = 0
      self.shakeAmount = 0
    end
  end
end

function Camera:render(obj, x, y, rect, sx, sy, ox, oy)
  rect = _.extend({x = 0, y = 0, w = obj:getWidth(), h = obj:getHeight()}, rect)
  Game.framebuffer:draw(obj, x, y, rect, nil, sx or 1, sy or sx, ox, oy)
end

return Camera