local enemy = require 'scripts/entities/enemy'
local entity = require 'scripts/entities/entity'

local enemySpawner = {}
enemySpawner.__index = enemySpawner
setmetatable(enemySpawner, entity)

function enemySpawner.new(x,y)
    local instance = setmetatable({}, enemySpawner)
    instance.spawnPosX, instance.spawnPosY = x, y

    instance.index = 0
    instance.allEnemies = {}

    NewInstance(instance)
    return instance
end

function enemySpawner:update(dt)
    
end

function enemySpawner:spawn()
    local newEnemy = enemy.new(self.spawnPosX, self.spawnPosY, "enemy"..tostring(self.index))
    NewInstance(newEnemy)
    NewEnemy(newEnemy)
    table.insert(self.allEnemies, newEnemy)
    self.index = self.index + 1
    return newEnemy
end

return enemySpawner