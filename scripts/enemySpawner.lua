local enemy = require 'scripts/entities/enemy'
local entity = require 'scripts/entities/entity'

local enemySpawner = {}
enemySpawner.__index = enemySpawner
setmetatable(enemySpawner, entity)

function enemySpawner.new(x,y, direction)
    local instance = setmetatable({}, enemySpawner)
    instance.spawnPosX, instance.spawnPosY = x, y

    instance.timer = 0
    instance.index = 0
    instance.delay = 10
    instance.direction = direction
    instance.allEnemies = {}

    return instance
end

function enemySpawner:runTimer(dt)
    self.timer = self.timer - dt
    if self.timer <= 0 then
        self.timer = self.delay
        self.index = self.index + 1
        self:spawn()
    end
end

function enemySpawner:spawn()
    local newEnemy = enemy.new(self.spawnPosX, self.spawnPosY, "enemy"..tostring(self.index))
    newEnemy.direction = self.direction
    NewInstance(newEnemy)
    NewEnemy(newEnemy)
    table.insert(self.allEnemies, newEnemy)
    return newEnemy
end

return enemySpawner