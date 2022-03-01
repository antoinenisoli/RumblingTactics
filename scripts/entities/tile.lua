local entity = require 'scripts/entities/entity'
local turret = require 'scripts/entities/turret'

local tile = {}
tile.__index = tile
setmetatable(tile, entity)
local scale = 2

function tile.new(x,y, name)
    local instance = setmetatable({}, tile)
    instance.x = x
    instance.y = y
    instance.name = name
    instance.sprite = love.graphics.newImage("assets/sprites/tile.png")
    instance.width = instance.sprite:getWidth() * scale
    instance.height = instance.sprite:getHeight() * scale
    return instance
end

function tile:draw()
    --self:drawCollider()
    if self:OnMouse() then
        love.graphics.setColor(0,255,255,1)
    end

    love.graphics.draw(self.sprite, self.x - self.width/2, self.y - self.height/2, nil, scale, scale)
    love.graphics.setColor(255,255,255,1)
    love.graphics.print(self.name, self.x - self.width/2, self.y - self.height/2)
end

function tile:OnMouse()
    return mousePositionX < (self.x + self.width/2) 
    and mousePositionX > (self.x - self.width/2) 
    and mousePositionY < (self.y + self.height/2) 
    and mousePositionY > (self.y - self.height/2) 
end

function tile:Click()
    print(self.name)
    local newTurret = turret.new(self.x, self.y, "turret0")
    NewInstance(newTurret)
end

function tile:update(dt)
    
end

return tile