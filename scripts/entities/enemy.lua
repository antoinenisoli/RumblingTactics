local anim8 = require 'libraries/anim8' --for animations
local entity = require 'scripts/entities/entity'
local scale = 1
local enemy = {}
enemy.__index = enemy
setmetatable(enemy, entity)

function enemy.new(x, y, name)
    local instance = setmetatable({}, enemy)
    instance.x = x
    instance.y = y
    instance.name = name
    instance:setupAnimations()
    instance.sprite = love.graphics.newImage('assets/sprites/ground_shaker_asset/Blue/Bodies/body_tracks.png')
    instance.width = instance.sprite:getWidth() * scale
    instance.height = instance.sprite:getHeight() * scale

    instance.shootTimer = 0
    instance.shootRate = 1

    instance.speed = 2
    instance.direction = 1

    instance:setupHealth()
    return instance
end

function enemy:setupHealth()
    self.hitTimer = 0
    self.hitDuration = 0.1
    self.maxHealth = 3
    self.currentHealth = self.maxHealth
    self.hit = false
end

function enemy:draw()
    love.graphics.draw(self.sprite, self.x - self.width/2, self.y - self.height/2, nil, scale, scale)
    self.currentAnimation:draw(self.spriteSheet, self.x, self.y - self.height/2, nil, 1, 1, self.height/2, 0)
end

function enemy:setupAnimations()
    self.spriteSheet = love.graphics.newImage('assets/sprites/ground_shaker_asset/Blue/Weapons/turret_01_mk1.png')
    self.grid = anim8.newGrid(128, 128, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animations = {}
    self.animations.idle = anim8.newAnimation(self.grid('1-8', 1), 0.05)
    self.currentAnimation = self.animations.idle
end

function enemy:manageHit(dt)
    
end

function enemy:shoot()
    
end

function enemy:move(dt)
    self.x = self.x + self.speed
end

function enemy:update(dt)
    self.currentAnimation:update(dt)
    self:manageHit(dt)
    self:move(dt)

    self.shootTimer = self.shootTimer + dt
    if self.shootTimer > self.shootRate then
        self.shootTimer = 0
        self:shoot()
    end
end

return enemy