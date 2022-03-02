local anim8 = require 'libraries/anim8' --for animations
local entity = require 'scripts/entities/entity'
local hitFX = require 'scripts/entities/hitFX'
local explosion = require 'scripts/entities/explosion'
local rescueShip = {}
rescueShip.__index = rescueShip
setmetatable(rescueShip, entity)

local scale = 1
citizens = 100

function rescueShip.new(x, y)
    local instance = setmetatable({}, rescueShip)
    instance.sprite = love.graphics.newImage('assets/sprites/rescueShip1.png')
    instance.healthBar = love.graphics.newImage('assets/sprites/Nouveau dossier/UI/tiles/tile0010.png')
    instance.width = instance.sprite:getWidth() * scale
    instance.height = instance.sprite:getHeight() * scale

    instance.x = x - instance.width/2
    instance.y = y

    instance.fleeSpeed = 1
    instance.fleeDuration = 1
    instance.timer = instance.fleeDuration

    instance:setupShake()
    instance:setupHealth()
    return instance
end

function rescueShip:setupHealth()
    self.health = {}
    self.health.hitTimer = 0
    self.health.hitDuration = 0.1
    self.health.maxHealth = 50
    self.health.currentHealth = self.health.maxHealth
    self.health.dead = false
    self.health.hit = false
    self:setHealthbar()
end

function rescueShip:setHealthbar()
    local s = 'assets/sprites/Nouveau dossier/UI/tiles/tile00'
    local index = (self.health.currentHealth / self.health.maxHealth) * 10
    self.healthBar = love.graphics.newImage(s..tostring(math.ceil(index))..".png")
end

function rescueShip:takeDmg(amount)
    if self.health.dead then
        return
    end

    self.health.currentHealth = self.health.currentHealth - amount
    local fx = hitFX.new(self.x + love.math.random(-20, 20), self.y + love.math.random(-20, 20))
    NewInstance(fx)
    self.health.hit = true
    self:setHealthbar()
    self:shake(0.2, 5)

    if (self.health.currentHealth <= 0) then
        self:death()
    end
end

function rescueShip:death()
    self.health.dead = true
    CameraShake(0.3, 5)
    local fx = explosion.new(self.x, self.y)
    NewInstance(fx)
    RemoveInstance(self)
    mainShip = nil
end

function rescueShip:draw()
    if self.health.hit then
        love.graphics.setColor(255, 0, 0, 1)
    end

    love.graphics.draw(self.sprite, self.x + self.localX, self.y + self.localY, nil, scale, scale, self.width/2, self.height/2)
    love.graphics.setColor(255, 255, 255, 1)
    love.graphics.draw(self.healthBar, self.x, self.y, nil, scale, scale, self.healthBar:getWidth()/2, self.healthBar:getHeight()/2)
end

function rescueShip:update(dt)
    self:manageShake(dt)
    self:manageHit(dt)

    if citizens > 0 then
        self.timer = self.timer - dt * self.fleeSpeed
        if (self.timer < 0) then
            self.timer = self.fleeDuration
            citizens = citizens - 1
        end
    end
end

return rescueShip