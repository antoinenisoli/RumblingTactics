local entity = require 'scripts/entities/entity'
local anim8 = require 'libraries/anim8' -- for animations
local explosion = {}
explosion.__index = explosion
setmetatable(explosion, entity)

local scale = 3

function explosion.new(x,y)
    local instance = setmetatable({}, explosion)
    instance.x = x
    instance.y = y
    instance.width = 32
    instance.height = 32
    instance:setupAnimations()
    return instance
end

function explosion:setupAnimations()
    self.spriteSheet = love.graphics.newImage('assets/sprites/turret_01_explosion.png')
    self.grid = anim8.newGrid(32, 32, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animation = anim8.newAnimation(self.grid('1-5', 1), 0.05)

    self.timer = self.animation.totalDuration
    self.done = false
end

function explosion:draw()
    if not self.done then
        self.animation:draw(self.spriteSheet, self.x, self.y, self.rotation, scale, scale, self.width/2, self.height/2)
    end
end

function explosion:update(dt)
    if not self.done then
        self.animation:update(dt)
        self.timer = self.timer - dt
        if self.timer <= 0 then
            RemoveInstance(self)
            self.done = true
        end
    end
end

return explosion