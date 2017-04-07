local _ = require "lib.lume"

local Input = {}
Input.map = {}

function Input.register(id, keys)
  if type(id) == "table" then
    for k, v in pairs(id) do
      Input.register(k, v)
    end
    return
  end

  Input.map[id] = _.clone(keys)
end

function Input.isDown(id)
  assert(Input.map[id], "bad id")
  return sol.keyboard.isDown(unpack(Input.map[id]))
end

function Input.wasPressed(id)
  assert(Input.map[id], "bad id")
  return sol.keyboard.wasPressed(unpack(Input.map[id]))
end

return Input
