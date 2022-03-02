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

        local newEnemy = self:spawn()
        table.insert(self.allEnemies, newEnemy)
        NewInstance(newEnemy)
        NewEnemy(newEnemy)
    end
end

function enemySpawner:spawn()
    local e = enemy.new(self.spawnPosX, self.spawnPosY, "enemy"..tostring(self.index))
    e.direction = self.direction
    return e
end

return enemySpawner