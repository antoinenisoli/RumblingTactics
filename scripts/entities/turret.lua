local entity = require 'scripts/entities/entity'
local turret = {}
turret.__index = turret
setmetatable(turret, entity)
local scale = 1

function turret.new(x,y, name)
    local instance = setmetatable({}, turret)
    instance.x = x
    instance.y = y
    instance.name = name
    instance.rotation = 0
    instance.sprite = love.graphics.newImage("assets/sprites/turret_01_mk1.png")
    instance.width = instance.sprite:getWidth() * scale
    instance.height = instance.sprite:getHeight() * scale
    return instance
end

function turret:getAngle(x1,y1, x2,y2) 
    return math.atan2(x2-x1, y2-y1) 
end

function turret:draw()
    love.graphics.draw(self.sprite, self.x, self.y, self.rotation, scale, scale, self.width/2, self.height/2)
end

function turret:update(dt)
    if newEnemy ~= nil then
        self.rotation = -self:getAngle(self.x, self.y, newEnemy.x, newEnemy.y) - 3
    end
end

return turret