local anim8 = require 'libraries/anim8' --for animations
local entity = require 'scripts/entities/entity'
local hitFX = require 'scripts/entities/hitFX'
local explosion = require 'scripts/entities/explosion'
local enemy = {}
enemy.__index = enemy
setmetatable(enemy, entity)

local scale = 1

function enemy.new(x, y, name)
    local instance = setmetatable({}, enemy)
    instance.currentTarget = nil
    instance.x = x
    instance.y = y
    instance.name = name
    instance:setupAnimations()
    instance.sprite = love.graphics.newImage('assets/sprites/ground_shaker_asset/Blue/Bodies/body_tracks.png')
    instance.width = instance.sprite:getWidth() * scale
    instance.height = instance.sprite:getHeight() * scale

    instance.shootTimer = 0
    instance.shootRate = 1
    instance.animTimer = 0

    instance.speed = 80
    instance.direction = 1

    instance:setupHealth()
    return instance
end

function enemy:setupHealth()
    self.health = {}
    self.health.hitTimer = 0
    self.health.hitDuration = 0.1
    self.health.maxHealth = 18
    self.health.currentHealth = self.health.maxHealth
    self.health.dead = false
    self.health.hit = false
end

function enemy:draw()
    if self.health.hit then
        love.graphics.setColor(255, 0, 0, 1)
    end

    love.graphics.draw(self.sprite, self.x - self.width/2, self.y - self.height/2, nil, scale, scale)
    self.currentAnimation:draw(self.spriteSheet, self.x, self.y - self.height/2, nil, scale, scale, self.height/2, 0)
    love.graphics.setColor(255, 255, 255, 1)
end

function enemy:setupAnimations()
    self.spriteSheet = love.graphics.newImage('assets/sprites/ground_shaker_asset/Blue/Weapons/turret_01_mk1.png')
    self.grid = anim8.newGrid(128, 128, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animations = {}
    self.animations.idle = anim8.newAnimation(self.grid('1-1', 1), 0.05)
    self.animations.shoot = anim8.newAnimation(self.grid('1-8', 1), 0.05)
    self.currentAnimation = self.animations.idle
end

function enemy:takeDmg(amount)
    self.health.currentHealth = self.health.currentHealth - amount
    local fx = hitFX.new(self.x + love.math.random(-20, 20), self.y + love.math.random(-20, 20))
    NewInstance(fx)
    self.health.hit = true

    if (self.health.currentHealth <= 0 and not self.health.dead) then
        self:death()
    end
end

function enemy:death()
    print("death")
    self.health.dead = true
    newEnemy = nil
    CameraShake(0.3, 5)
    local fx = explosion.new(self.x, self.y)
    NewInstance(fx)

    RemoveInstance(self)
end

function enemy:manageHit(dt)
    self.health.hitTimer = self.health.hitTimer - dt
    if self.health.hitTimer <= 0 then
        self.health.hit = false;
    end
end

function enemy:shoot()
    self.currentAnimation = self.animations.shoot
    self.animTimer = self.animations.shoot.totalDuration
end

function enemy:move(dt)
    self.x = self.x + self.speed * dt
end

function enemy:resetIdle(dt)
    self.animTimer = self.animTimer - dt
    if self.animTimer <= 0 and self.currentAnimation ~= self.animations.idle then
        self.currentAnimation = self.animations.idle
    end
end

function enemy:update(dt)
    self.currentAnimation:update(dt)
    self:manageHit(dt)
    self:move(dt)
    self:resetIdle(dt)
    self.shootTimer = self.shootTimer + dt
    if self.shootTimer > self.shootRate then
        self.shootTimer = 0
        self:shoot()
    end
end

return enemy