local Object = require "lib.classic"

local State = Object:extend()

function State:new()
  State.super.new(self)
  if self.new ~= State.new then
    error("State's constructor overridden. override State:create() instead")
  end
end


function State:create()

end


function State:destroy()

end