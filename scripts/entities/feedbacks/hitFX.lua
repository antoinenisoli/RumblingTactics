local entity = require 'scripts/entities/entity'
local anim8 = require 'libraries/anim8' -- for animations
local hitFX = {}
hitFX.__index = hitFX
setmetatable(hitFX, entity)

local scale = 0.5

function hitFX.new(x,y)
    local instance = setmetatable({}, hitFX)
    instance.x = x
    instance.y = y
    instance.width = 128 * scale
    instance.height = 128 * scale
    instance:setupAnimations()
    return instance
end

function hitFX:setupAnimations()
    local random = love.math.random(0,1)
    if random > 0.5 then
        self.spriteSheet = love.graphics.newImage('assets/sprites/Hit_Effect-Sheet.png')
        self.grid = anim8.newGrid(128, 128, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
        self.animation = anim8.newAnimation(self.grid('1-6', 1), 0.05)
    else
        self.spriteSheet = love.graphics.newImage('assets/sprites/Hit_Effect_02-Sheet.png')
        self.grid = anim8.newGrid(64, 64, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
        self.animation = anim8.newAnimation(self.grid('1-5', 1), 0.05)
    end

    self.timer = self.animation.totalDuration
    self.done = false
end

function hitFX:draw()
    if not self.done then
        self.animation:draw(self.spriteSheet, self.x, self.y, self.rotation, scale, scale, self.width/2, self.height/2)
    end
end

function hitFX:update(dt)
    if not self.done then
        self.animation:update(dt)
        self.timer = self.timer - dt
        if self.timer <= 0 then
            RemoveInstance(self)
            self.done = true
        end
    end
end

return hitFX