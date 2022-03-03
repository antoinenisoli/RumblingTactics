local entity = require 'scripts/entities/entity'
local hitFX = require 'scripts/entities/feedbacks/hitFX'
local explosion = require 'scripts/entities/feedbacks/explosion'
local hud = require 'scripts/UI/hud'

local destroyable = {}
destroyable.__index = destroyable
setmetatable(destroyable, entity)

function destroyable:hurtFeedback(amount)
    self:shake(0.2, 2)
    hud.newFloatingTxt(amount, self.x, self.y, 1, NewColor(255, 0, 0, 1))
    local fx = hitFX.new(self.x + love.math.random(-20, 20), self.y + love.math.random(-20, 20))
    NewInstance(fx)
end

function destroyable:destroy()
    self.health.dead = true
    CameraShake(0.3, 1)
    local fx = explosion.new(self.x, self.y)
    NewInstance(fx)
    RemoveInstance(self)
end

return destroyable