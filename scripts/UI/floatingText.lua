local entity = require 'scripts/entities/entity'

local floatingText = {}
floatingText.__index = floatingText
setmetatable(floatingText, entity)
local scale = 1

function floatingText.new(text, x, y, duration, r,g,b,a)
    local instance = setmetatable({}, floatingText)
    instance.x, instance.y, instance.duration = x, y, duration
    instance.timer = instance.duration
    instance.speed = 100
    instance.text = text
    instance.color = {
        r = r,
        g = g,
        b = b,
        a = a,
    }

    return instance
end

function floatingText:draw()
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
    love.graphics.print(self.text, self.x, self.y, nil, scale, scale)
    love.graphics.setColor(255,255,255,1)
end

function floatingText:update(dt)
    self.y = self.y - dt * self.speed
    self.timer = self.timer - dt
    if self.timer <= 0 then
        RemoveUI(self)
    end
end

return floatingText