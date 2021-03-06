local entity = require 'scripts/entities/entity'
local anim8 = require 'libraries/anim8' -- for animations
local soundManager = require 'scripts.soundManager'

local npc = {}
npc.__index = npc
setmetatable(npc, entity)

local scale = 1

function npc.new(x,y)
    local instance = setmetatable({}, npc)
    instance.x = x
    instance.y = y
    instance.speed = 50
    instance.distance = 10
    instance.minDistance = 5
    instance.done = false

    instance.width = 64 * scale
    instance.height = 64 * scale
    instance:setupAnimations()
    NewInstance(instance)
    return instance
end

function npc:setupAnimations()
    local random = love.math.random(0,1)
    if random > 0.5 then
        self.direction = 1
    else
        self.direction = -1
    end

    self.spriteSheet = love.graphics.newImage('assets/sprites/npc/players red x2.png')
    self.grid = anim8.newGrid(64, 64, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animation = anim8.newAnimation(self.grid('1-4', 4), 0.25)
end

function npc:draw()
    self.animation:draw(self.spriteSheet, self.x, self.y, nil, self.direction * scale, scale, self.width/2, self.height/2)
end

function npc:enterShip()
    RemoveInstance(self)
    self.done = true
    citizens = citizens - 1
    soundManager.playSound("newCitizen")
end

function npc:update(dt)
    if not self.done then
        self.animation:update(dt)
        if mainShip ~= nil then
            if self.x < mainShip.x then
                self.direction = 1
            else
                self.direction = -1
            end
    
            self.distance = Distance(self.x, self.y, mainShip.x, mainShip.y)
            if self.distance <= self.minDistance then
                self:enterShip()
            else
                self:follow(dt, mainShip)
            end
        end
    end
end

return npc