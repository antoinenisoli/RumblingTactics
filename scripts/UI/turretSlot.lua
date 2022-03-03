local entity = require 'scripts/entities/entity'
local turretProfilesBank = require 'scripts.profiles.turretProfilesBank'

local turretSlot = {}
turretSlot.__index = turretSlot
setmetatable(turretSlot, entity)

local scale = 1

function turretSlot.new(x, y, index)
    local instance = setmetatable({}, turretSlot)
    instance.x = x
    instance.y = y

    print(index)
    instance.profile = turretProfilesBank.getProfile(index)
    instance.selectedSprite = love.graphics.newImage("assets/sprites/hud/Layer 2.png")
    instance.sprite = love.graphics.newImage("assets/sprites/hud/Layer 3.png")
    instance.turretSprite = instance.profile.sprite

    instance.width = instance.sprite:getWidth()
    instance.height = instance.sprite:getHeight()
    instance.text = tostring(instance.profile.cost)

    instance.selected = false

    return instance
end

function turretSlot:draw()
    if self.selected then
        love.graphics.draw(self.selectedSprite, self.x, self.y, nil, 1 * scale, 1 * scale, self.selectedSprite:getWidth()/2, self.selectedSprite:getWidth()/2)
    else
        love.graphics.draw(self.sprite, self.x, self.y, nil, 1 * scale, 1 * scale, self.sprite:getWidth()/2, self.sprite:getWidth()/2)
    end

    love.graphics.print(self.text, self.x - 15, self.y - 70, nil, scale, scale)
    love.graphics.draw(self.turretSprite, self.x, self.y - 18, nil, 1 * scale, 1 * scale, self.turretSprite:getWidth()/2, self.turretSprite:getWidth()/2)
end

return turretSlot