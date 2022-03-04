local entity = require 'scripts/entities/entity'
local anim8 = require 'libraries/anim8' --for animations
local gameManager = require 'scripts/gameManager'
local soundManager = require 'scripts.soundManager'

local turret = {}
turret.__index = turret
setmetatable(turret, entity)
local scale = 1

function turret.new(x, y, profile)
    local instance = setmetatable({}, turret)
    soundManager.playSound("newTurret", false, 0.08)
    
    instance.x = x
    instance.y = y
    instance.profile = profile
    instance.rotation = 0

    instance.shootTimer = 0
    instance.currentTarget = nil
    instance.debugRadius = false

    instance.attackDamage = profile.damage
    instance.shootRate = profile.shootRate
    instance.minDistance = profile.minDistance

    gameManager.addMoney(-profile.cost)
    instance:setupAnimations()

    return instance
end

function turret:setupAnimations()
    self.animTimer = 0
    self.animations = {}
    self.width = 128 * scale
    self.height = 128 * scale

    if self.profile.index == 1 then
        self.spriteSheet = love.graphics.newImage('assets/sprites/ground_shaker_asset/Red/Weapons/turret_01_mk1.png')
        self.grid = anim8.newGrid(128, 128, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
        
        self.animations.shoot = anim8.newAnimation(self.grid('1-8', 1), 0.05)

    elseif self.profile.index == 2 then
        self.spriteSheet = love.graphics.newImage('assets/sprites/ground_shaker_asset/Red/Weapons/turret_01_mk2.png')
        self.grid = anim8.newGrid(128, 128, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
        
        self.animations.shoot = anim8.newAnimation(self.grid('1-8', 1), 0.05)

    elseif self.profile.index == 3 then
        self.spriteSheet = love.graphics.newImage('assets/sprites/ground_shaker_asset/Red/Weapons/turret_01_mk4.png')
        self.grid = anim8.newGrid(128, 128, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
        
        self.animations.shoot = anim8.newAnimation(self.grid('1-8', 1), 0.05)

    elseif self.profile.index == 4 then
        self.spriteSheet = love.graphics.newImage('assets/sprites/ground_shaker_asset/Red/Weapons/turret_02_mk1.png')
        self.grid = anim8.newGrid(128, 128, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
        
        self.animations.shoot = anim8.newAnimation(self.grid('1-11', 1), 0.02)

    elseif self.profile.index == 5 then
        self.spriteSheet = love.graphics.newImage('assets/sprites/turret05.png')
        self.grid = anim8.newGrid(57, 77, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
        self.width = 57
        self.height = 77

        self.animations.shoot = anim8.newAnimation(self.grid('1-1', 1), 0.05)
    end

    self.animations.idle = anim8.newAnimation(self.grid('1-1', 1), 0.05)
    self.currentAnimation = self.animations.idle
end

function turret:shoot()
    soundManager.playSound(self.profile.shootSound, false)
    self.currentAnimation = self.animations.shoot
    self.animTimer = self.animations.shoot.totalDuration
    self.currentTarget:takeDmg(self.attackDamage)
end

function turret:draw()
    self.currentAnimation:draw(self.spriteSheet, self.x, self.y, self.rotation, scale, scale, self.width/2, self.height/2)
    if self.debugRadius then
        love.graphics.setColor(255,0,0,1)
        love.graphics.circle("line", self.x, self.y, self.minDistance)
        love.graphics.setColor(255,255,255,1)
    end

    if self.currentTarget ~= nil then
        love.graphics.setColor(255, 0, 0, 0.5)
        love.graphics.line(self.x, self.y, self.currentTarget.x, self.currentTarget.y)
        love.graphics.setColor(255, 255, 255, 1)
    end
end

function turret:fight(dt)
    self.rotation = -GetAngle(self.x, self.y, self.currentTarget.x, self.currentTarget.y) - 3
    self.shootTimer = self.shootTimer + dt
    if self.shootTimer > self.shootRate then
        self.shootTimer = 0
        self:shoot()
    end

    if self.currentTarget.health.currentHealth <= 0 then
        self.currentTarget = ClosestEnemy(self.x, self.y, self.minDistance)
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

    if self.currentTarget ~= nil then
        self:fight(dt)
    else
        self.currentTarget = ClosestEnemy(self.x, self.y, self.minDistance)
        self.animTimer = 0
    end
end

return turret