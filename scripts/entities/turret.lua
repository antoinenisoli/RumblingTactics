local entity = require 'scripts/entities/entity'
local anim8 = require 'libraries/anim8' --for animations
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

    instance.shootTimer = 0
    instance.shootRate = 1
    instance.currentTarget = newEnemy

    instance.width = 128 * scale
    instance.height = 128 * scale
    instance:setupAnimations()
    return instance
end

function turret:setupAnimations()
    self.spriteSheet = love.graphics.newImage('assets/sprites/ground_shaker_asset/Red/Weapons/turret_01_mk1.png')
    self.grid = anim8.newGrid(128, 128, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animTimer = 0
    self.animations = {}
    self.animations.idle = anim8.newAnimation(self.grid('1-1', 1), 0.05)
    self.animations.shoot = anim8.newAnimation(self.grid('1-8', 1), 0.05)
    self.currentAnimation = self.animations.idle
end

function turret:getAngle(x1,y1, x2,y2) 
    return math.atan2(x2-x1, y2-y1) 
end

function turret:shoot()
    self.currentAnimation = self.animations.shoot
    self.animTimer = self.animations.shoot.totalDuration
    self.currentTarget:takeDmg(1)
end

function turret:draw()
    self.currentAnimation:draw(self.spriteSheet, self.x, self.y, self.rotation, scale, scale, self.width/2, self.height/2)
end

function turret:fight(dt)
    self.rotation = -self:getAngle(self.x, self.y, self.currentTarget.x, self.currentTarget.y) - 3
    self.shootTimer = self.shootTimer + dt
    if self.shootTimer > self.shootRate then
        self.shootTimer = 0
        self:shoot()
    end
end

function turret:resetIdle(dt)
    self.animTimer = self.animTimer - dt
    if self.animTimer <= 0 and self.currentAnimation ~= self.animations.idle then
        self.currentAnimation = self.animations.idle
    end
end

function turret:update(dt)
    self.currentAnimation:update(dt)
    self:resetIdle(dt)
    if newEnemy ~= nil then
        self:fight(dt)
    else
        self.currentTarget = nil
        self.animTimer = 0
    end
end

return turret