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

    instance.locked = false
    instance.myTurret = nil

    return instance
end

function tile:draw()
    --self:drawCollider()
    if self:OnMouse() then
        love.graphics.setColor(0,255,255,1)
    end

    if self.myTurret ~= nil then
        self.myTurret.debugRadius = self:OnMouse()
    end

    if self.locked then
        love.graphics.setColor(0.8,0.8,0.8, 1)
    end

    love.graphics.draw(self.sprite, self.x - self.width/2, self.y - self.height/2, nil, scale, scale)
    love.graphics.setColor(255,255,255,1)
    --love.graphics.print(self.name, self.x - self.width/2, self.y - self.height/2, nil, 0.7, 0.7)
end

function tile:OnMouse()
    return mousePositionX < (self.x + self.width/2) 
    and mousePositionX > (self.x - self.width/2) 
    and mousePositionY < (self.y + self.height/2) 
    and mousePositionY > (self.y - self.height/2) 
end

function tile:Click(profile)
    if not self.locked then
        self.myTurret = turret.new(self.x, self.y, profile)
        NewInstance(self.myTurret)
        self.locked = true
    end
end

function tile:update(dt)
    
end

return tile