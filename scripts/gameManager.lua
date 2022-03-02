local npc = require 'scripts/entities/feedbacks/npc'
currentMoney = 100

local gameManager = {}
local spawnDelay = 0.6
local timer = 0
local gridMinX, gridMaxX, gridMinY, gridMaxY

function gameManager.init(x1, x2, y1, y2)
    gridMinX, gridMaxX, gridMinY, gridMaxY = x1, x2, y1, y2
end

function gameManager.addMoney(amount)
    currentMoney = currentMoney + amount
end

function gameManager.canBuy(cost)
    return currentMoney >= cost
end

function gameManager:update(dt)
    timer = timer - dt
    if timer <= 0 then
        self.spawnNPC()
        timer = spawnDelay
    end
end

function gameManager.spawnNPC()
    local x = math.random(gridMinX, gridMaxX)
    local y = math.random(gridMinY, gridMaxY)
    local character = npc.new(x, y)
    NewInstance(character)
    return character
end

return gameManager