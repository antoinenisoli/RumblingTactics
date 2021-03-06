local destroyable = require 'scripts/entities/destroyable'

local rescueShip = {}
rescueShip.__index = rescueShip
setmetatable(rescueShip, destroyable)

local scale = 1

function rescueShip.new(x, y)
    local instance = setmetatable({}, rescueShip)
    instance.sprite = levelProfile.rescueShip.sprite
    scale = levelProfile.rescueShip.scale

    instance.healthBar = love.graphics.newImage('assets/sprites/hud/tiles/tile0010.png')
    instance.width = instance.sprite:getWidth()
    instance.height = instance.sprite:getHeight()

    instance.x = x - instance.width/2
    instance.y = y

    instance:setupShake()
    instance:setupHealth()
    NewInstance(instance)
    return instance
end

function rescueShip:setupHealth()
    self.health = {}
    self.health.hitTimer = 0
    self.health.hitDuration = 0.5
    self.health.maxHealth = levelProfile.rescueShip.startHealth
    self.health.currentHealth = self.health.maxHealth
    self.health.dead = false
    self.health.hit = false
    self:setHealthbar()
end

function rescueShip:setHealthbar()
    local path = 'assets/sprites/hud/tiles/tile00'
    local index = (self.health.currentHealth / self.health.maxHealth) * 10
    self.healthBar = love.graphics.newImage(path..tostring(math.ceil(index))..".png")
end

function rescueShip:takeDmg(amount)
    if self.health.dead then
        return
    end

    self.health.currentHealth = self.health.currentHealth - amount

    if self.health.currentHealth <= 0 then
        self.health.currentHealth = 0
        if not self.health.dead then
            self:death()
        end
    else
        self.health.hit = true
        self.health.hitTimer = self.health.hitDuration
        self:setHealthbar()
        self:hurtFeedback(amount)
    end
end

function rescueShip:death()
    self.health.dead = true
    self:destroy()
    mainShip = nil
    GameOver()
end

function rescueShip:draw()
    if self.health.hit then
        love.graphics.setColor(255, 0, 0, 1)
    end

    love.graphics.draw(self.sprite, self.x + self.localX, self.y + self.localY, nil, 1, 1, self.width/2, self.height/2)
    love.graphics.setColor(255, 255, 255, 1)
    love.graphics.draw(self.healthBar, self.x, self.y, nil, scale, scale, self.healthBar:getWidth()/2, self.healthBar:getHeight()/2)
end

function rescueShip:update(dt)
    self:manageShake(dt)
    self:manageHit(dt)
end

return rescueShip