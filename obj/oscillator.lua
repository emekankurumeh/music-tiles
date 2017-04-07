local Object = require "lib.classic"

local Oscillator = Object:extend()

function Oscillator:new(fn, amp, freq)
  local mtb = {}
  local amp = amp or 1
  local tb = { amp = amp, freq = freq}
  function mtb:__call(t, ...)
    return fn(t, ...)
  end
  return setmetatable(tb, mtb)
end

function Oscillator:square(amp, freq)
  local mtb = {}
  local amp = amp or 1
  local tb = { amp = amp, freq = freq }
  function mtb:__call(t)
    local t = (self.freq * t) % 1
    return t > .5 and self.amp or -self.amp
  end
  return setmetatable(tb, mtb)
end

function Oscillator:triangle(amp, freq)
  local mtb = {}
  local amp = amp or 1
  local tb = { amp = amp, freq = freq }
  function mtb:__call(t)
    local t = (self.freq * t) % 1
    return t < .5 and self.amp * (4 * t - 1) or self.amp * (3 - 4 * t)
  end
  return setmetatable(tb, mtb)
end

function Oscillator:saw(amp, freq)
  local mtb = {}
  local amp = amp or 1
  local tb = { amp = amp, freq = freq }
  function mtb:__call(t)
    local t = (self.freq * t) % 1
    return self.amp * (2 * t - 1)
  end
  return setmetatable(tb, mtb)
end

function Oscillator:sine(amp, freq)
  local mtb = {}
  local amp = amp or 1
  local tb = { amp = amp, freq = freq }
  function mtb:__call(t)
    local t = (self.freq * t) % 1
    return self.amp * math.sin(2 * math.pi * t)
  end
  return setmetatable(tb, mtb)
end

function Oscillator:white(amp)
  local mtb = {}
  local amp = amp or 1
  local tb = { amp = amp }
  function mtb:__call(self)
    return self.amp * (math.random() * 2 - 1)
  end
  return setmetatable(tb, mtb)
end

function Oscillator:pink(amp)
  local mtb = {}
  local amp = amp or 1
  local tb = { amp = amp, last = 0 }
  function mtb:__call()
    self.last = math.max(-1, math.min(1, self.last + math.random() * 2 - 1))
    return self.amp * self.last
  end
  return setmetatable(tb, mtb)
end

return Oscillator
