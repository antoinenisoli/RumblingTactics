local npc = require 'scripts/entities/feedbacks/npc'
currentMoney = 10000

local gameManager = {}
local spawnDelay = 0.6
local timer = 0
local gridMinX, gridMaxX, gridMinY, gridMaxY
local enemySpawning = {}

function gameManager.init(x1, x2, y1, y2)
    gridMinX, gridMaxX, gridMinY, gridMaxY = x1, x2, y1, y2

    enemySpawning = {}
    enemySpawning.timer = 0
    enemySpawning.delay = 2
    enemySpawning.currentSpawner = nil
    enemySpawning.allSpawners = {}
end

function gameManager.addMoney(amount)
    currentMoney = currentMoney + amount
end

function gameManager.canBuy(cost)
    return currentMoney >= cost
end

function gameManager.newSpawner(spawner)
    table.insert(enemySpawning.allSpawners, spawner)
end

local function randomSpawner()
    enemySpawning.currentSpawner = enemySpawning.allSpawners[love.math.random(#enemySpawning.allSpawners)]
    enemySpawning.currentSpawner:spawn()
end

local function spawnNPC()
    local x = math.random(gridMinX, gridMaxX)
    local y = math.random(gridMinY, gridMaxY)
    local character = npc.new(x, y)
    return character
end

function gameManager:update(dt)
    enemySpawning.timer = enemySpawning.timer + dt
    if enemySpawning.timer > enemySpawning.delay then
        enemySpawning.timer = 0
        randomSpawner()
    end

    timer = timer - dt
    if timer <= 0 then
        spawnNPC()
        timer = spawnDelay
    end
end

return gameManager