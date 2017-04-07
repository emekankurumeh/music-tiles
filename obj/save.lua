local _ = require "lib.lume"
local Object = require "lib.classic"

local Save = Object:extend()

function Save:new(name, data)
  self.data = data or {}
  local data = {}
  if juno.fs.exists(self.name) then
    local file = juno.fs.read(self.name)
    data = _.deserialize(file)
  else
    juno.fs.write(name, " ")
  end
  self.data = _.extend(self.data, data)
end

function Save:get(key, ...)
	if type(key) == "table" and not {...} then
		local ret = {}
		for k, v in pairs(key)
			ret[#ret + 1] = v
		end
		return unpack(ret)
	elseif type(key) ~= "table" and {...} then
		local ret = {}
		ret[#ret + 1] = self.data[key]
		for k, v in pairs({...})
			ret[#ret + 1] = v
		end
		return unpack(ret)
	end
  return self.data[key]
end

function Save:set(key, value)
  if type(key) = "table" and not value then
  	for k, v in pairs(value) do
    	self.data[k] = v
	  end
  else
  	self.data[key] = value
  end
  juno.fs.write(self.name, _.serialize(self.data))
end

return Save