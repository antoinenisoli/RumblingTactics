local npc = require 'scripts/entities/feedbacks/npc'
local soundManager = require 'scripts.soundManager'

gameWin = false
gameEnded = false
levelTransition = false
currentMoney = 0
citizens = 0
mainShip = nil

local gameManager = {}
local gameEndTimer = 0
local gridMinX, gridMaxX, gridMinY, gridMaxY
local enemySpawning = {}
local npcSpawning = {}

function gameManager.init(x1, x2, y1, y2)
    currentMoney = levelProfile.money
    citizens = levelProfile.citizens
    gridMinX, gridMaxX, gridMinY, gridMaxY = x1, x2, y1, y2

    enemySpawning = {}
    enemySpawning.timer = 0
    enemySpawning.delay = 2
    enemySpawning.currentSpawner = nil
    enemySpawning.allSpawners = {}

    npcSpawning = {}
    npcSpawning.timer = 0
    npcSpawning.delay = 1
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
    npcSpawning.timer = npcSpawning.delay
    local x = math.random(gridMinX, gridMaxX)
    local y = math.random(gridMinY, gridMaxY)
    local character = npc.new(x, y)
    return character
end

local function manageTimers(dt)
    enemySpawning.timer = enemySpawning.timer + dt
        if enemySpawning.timer > enemySpawning.delay then
            enemySpawning.timer = 0
            randomSpawner()
        end

        npcSpawning.timer = npcSpawning.timer - dt
        if npcSpawning.timer <= 0 then
            spawnNPC()
        end
end

function gameManager:update(dt)
    if gameEnded then
        gameEndTimer = gameEndTimer + dt
    else
        manageTimers(dt)
        if citizens <= 0 then
            GameWin()
        end
    end
end

function gameManager.checkGameEnd()
    if gameEnded and not levelTransition then
        if gameEndTimer > 1 then
            levelTransition = true
        end
    end
end

function GameOver()
    soundManager.playSound("earthquake", true, 0.3)
    CameraShake(500, 3)
    gameWin = false
    gameEnded = true
end

function GameWin()
    soundManager.playSound("gameWin")
    gameWin = true
    gameEnded = true
end

return gameManager