local entity = require 'scripts/entities/entity'

local turretSlot = {}
turretSlot.__index = turretSlot
setmetatable(turretSlot, entity)

function turretSlot:new(x, y)
    local instance = setmetatable({}, turretSlot)
    instance.x = x
    instance.y = y
    instance.sprite = love.graphics.newImage()

    return instance
end

function turretSlot:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

return turretSlot