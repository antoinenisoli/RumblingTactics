local destroyable = require 'scripts/entities/destroyable'

local rescueShip = {}
rescueShip.__index = rescueShip
setmetatable(rescueShip, destroyable)

local scale = 1
citizens = 100

function rescueShip.new(x, y)
    local instance = setmetatable({}, rescueShip)
    instance.sprite = love.graphics.newImage('assets/sprites/rescueShip1.png')
    instance.healthBar = love.graphics.newImage('assets/sprites/cyberpunk/UI/tiles/tile0010.png')
    instance.width = instance.sprite:getWidth() * scale
    instance.height = instance.sprite:getHeight() * scale

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
    self.health.hitDuration = 0.1
    self.health.maxHealth = 150
    self.health.currentHealth = self.health.maxHealth
    self.health.dead = false
    self.health.hit = false
    self:setHealthbar()
end

function rescueShip:setHealthbar()
    local s = 'assets/sprites/cyberpunk/UI/tiles/tile00'
    local index = (self.health.currentHealth / self.health.maxHealth) * 10
    self.healthBar = love.graphics.newImage(s..tostring(math.ceil(index))..".png")
end

function rescueShip:takeDmg(amount)
    if self.health.dead then
        return
    end

    self.health.currentHealth = self.health.currentHealth - amount
    self.health.hit = true
    self.health.hitTimer = self.health.hitDuration
    self:setHealthbar()
    self:hurtFeedback(amount)

    if (self.health.currentHealth <= 0) then
        self:death()
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

    love.graphics.draw(self.sprite, self.x + self.localX, self.y + self.localY, nil, scale, scale, self.width/2, self.height/2)
    love.graphics.setColor(255, 255, 255, 1)
    love.graphics.draw(self.healthBar, self.x, self.y, nil, scale, scale, self.healthBar:getWidth()/2, self.healthBar:getHeight()/2)
end

function rescueShip:update(dt)
    self:manageShake(dt)
    self:manageHit(dt)

    if citizens <= 0 then
        GameWin()
    end
end

return rescueShip