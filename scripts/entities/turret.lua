local entity = require 'scripts/entities/entity'
local anim8 = require 'libraries/anim8' --for animations
local gameManager = require 'scripts/gameManager'
local turret = {}
turret.__index = turret
setmetatable(turret, entity)
local scale = 1
turretCost = 50

function turret.new(x, y, name)
    gameManager.addMoney(-turretCost)
    local instance = setmetatable({}, turret)
    
    instance.x = x
    instance.y = y
    instance.name = name
    instance.rotation = 0

    instance.attackDamage = 1
    instance.shootTimer = 0
    instance.shootRate = 1
    instance.minDistance = 300
    instance.currentTarget = nil

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

function turret:shoot()
    self.currentAnimation = self.animations.shoot
    self.animTimer = self.animations.shoot.totalDuration
    self.currentTarget:takeDmg(self.attackDamage)
end

function turret:draw()
    self.currentAnimation:draw(self.spriteSheet, self.x, self.y, self.rotation, scale, scale, self.width/2, self.height/2)
    if self.currentTarget ~= nil and self.shootTimer < 0.3 then
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
    self.currentTarget = ClosestEnemy(self.x, self.y, self.minDistance)

    if self.currentTarget ~= nil then
        self:fight(dt)
    else
        self.currentTarget = nil
        self.animTimer = 0
    end
end

return turret