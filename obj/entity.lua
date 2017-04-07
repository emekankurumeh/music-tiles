local _ = require "lib.lume"
local tick = require "lib.tick"
local coil = require "lib.coil"
local flux = require "lib.flux"
local shash = require "lib.shash"
local Rect = require "obj.rect"
local Game = require "obj.game"

local Entity = Rect:extend()

function Entity:new(width, height)
  Entity.super.new(self, 0, 0, 0, 0)
  self.angle = 0
  self.accel = Rect(0, 0)
  self.scale = Rect(1, 1)
  self.offset = Rect(0, 0)
  self.solid = true
  self.moves = true
  self.visible = true
  self.collidable = true
  self.velocity = Rect(0, 0)
  self.animation = nil
  self.frame_counter = 1
  self.animations = {}
  self.animation_timer = 0
  self.tween = flux.group()
  self.timer = tick.group()
  self.task = coil.group()
end

local loadImage = _.memoize(function(...)
  return juno.Buffer.fromFile(...)
end)

function Entity:loadImage(file, w, h)
  self.image = loadImage(file)
  local w = w or self.image:getWidth()
  local h = h or self.image:getHeight()
  self.frames = {}
  for y = 0, self.image:getHeight()  / h - 1 do
    for x = 0, self.image:getWidth() / w - 1 do
      table.insert(self.frames, {x = x * w, y = y * h, w = w, h = h})
    end
  end
end

function Entity:addAnimation(name, frames, fps, loop)
  self.animations[name] =  {
    frames = frames,
    period = (fps ~= 0) and 1 / math.abs(fps) or 1,
    loop = (loop == nil) and true or loop
  }
end

function Entity:play(name, reset)
  local last = self.animation
  self.animation = self.animations[name]
  if reset or self.animation ~= last then
    self.frame_counter = 1
    self.animation_timer = self.animation.period
    self.frame = self.frames[self.frame_counter]
  end
end

function Entity:stop()
  self.animation = nil
end

function Entity:setX(x)
  self.x = x
  Game.group:update(self, self.x, self.y, self.width, self.height)
end

function Entity:setY(y)
  self.y = y
  Game.group:update(self, self.x, self.y, self.width, self.height)
end

function Entity:setWidth(w)
  self.width = w
  Game.group:update(self, self.x, self.y, self.width, self.height)
end

function Entity:setHeight(h)
  self.height = h
  Game.group:update(self, self.x, self.y, self.width, self.height)
end

function Entity:updateMovement(dt)
  if dt == 0 then return end
  -- Game.group:each(self, function(obj)
  --   self.accel.x = -self.accel.x
  --   self.accel.y = -self.accel.y
  -- end)

  self.velocity.x = self.velocity.x + (self.accel.x * dt)
  self.velocity.y = self.velocity.y + (self.accel.y * dt)

  if math.abs(self.velocity.x) > 255 then
    self.velocity.x = 255 * _.sign(self.velocity.x)
  end

  if math.abs(self.velocity.y) > 255 then
    self.velocity.y = 255 * _.sign(self.velocity.y)
  end

  self.x = self.x + (self.velocity.x * dt)
  self.y = self.y + (self.velocity.y * dt)

  if self.accel.x == 0 then self.velocity.x = self.velocity.x - (self.velocity.x * .07)end
  if self.accel.y == 0 then self.velocity.y = self.velocity.y - (self.velocity.y * .07) end

  Game.group:update(self, self.x, self.y, self.width, self.height)
end

function Entity:updateAnimation(dt)
  if not self.animation then return end
  self.animation_timer = self.animation_timer - dt
  if self.animation_timer <= 0 then
    if self.frame_counter < #self.animation.frames then
      self.frame_counter = self.frame_counter + 1
    else
      if self.animation.loop then
        self.frame_counter = 1
      else
        return self:stop()
      end
    end
    self.animation_timer = self.animation_timer + self.animation.period
    self.frame = self.frames[self.frame_counter]
  end
end

function Entity:update(dt)
  self.tween:update(dt)
  self.timer:update(dt)
  self.task:update(dt)
  if self.moves then
    self:updateMovement(dt)
  end
  if self.animation then
    self:updateAnimation(dt)
  end
end

function Entity:draw()
  Game.camera:render(self.image, self.x, self.y, self.frame, self.scale.x, self.scale.y)
end

return Entity