local gameManager = require 'scripts/gameManager'
local rescueShip = require 'scripts/entities/rescueShip'
local hud = require 'scripts/UI/hud'
local enemySpawner = require 'scripts/enemySpawner'
local gridManager = require 'scripts/system/gridManager'
local levelProfilesBank = require 'scripts.profiles.levelProfilesBank'
local soundManager = require 'scripts.soundManager'

local mainGame = {}
mousePositionX, mousePositionY = 0, 0
local backGroundImage = love.graphics.newImage("assets/sprites/bg.png")

local levelCurrentIndex = 1
levelProfile = nil

local allEnemies = {}

local function setupSpawners()
    for index, value in ipairs(levelProfile.levelData.layers[2].objects) do
        local s = enemySpawner.new(value.x, value.y)
        gameManager.newSpawner(s)
    end
end

function mainGame.load()
    instances = {}
    allEnemies = {}

    soundManager.clear()
    soundManager:load()
    t, shakeMagnitude = 0,0

    mainShip = nil
    gameEnded = false
    levelTransition = false

    levelProfile = levelProfilesBank.getProfile(levelCurrentIndex)
    backGroundImage = levelProfile.bgSprite

    hud:load()
    gridManager.setupMap(levelProfile.grid)
    gameManager.init(levelProfile.grid.startX, levelProfile.grid.startX * 2, levelProfile.grid.startY, levelProfile.grid.startY * 4)
    mainShip = rescueShip.new(levelProfile.grid.startX * 1.5, levelProfile.grid.startY * 2)
    setupSpawners()
end

function ClosestEnemy(x, y, minDistance)
    local maxDistance = math.huge
    local closestEnemy = nil
    for index, value in ipairs(allEnemies) do
        local distance = Distance(x, y, value.x, value.y)
        if distance < minDistance and distance < maxDistance then
            closestEnemy = value
        end
    end

    return closestEnemy
end

function NewEnemy(element)
    table.insert(allEnemies, element)
end

function RemoveEnemy(enemy)
    for index, value in ipairs(allEnemies) do
        if value == enemy then
            table.remove(allEnemies, index)
        end
    end
end

function mainGame.draw()
    love.graphics.draw(backGroundImage, 0, 0)
end

function mainGame.keypressed(key)
    if key == 'right' then
        hud.moveIndex(1)
    elseif key == 'left' then
        hud.moveIndex(-1)
    end

    love.keyboard.keysPressed[key] = true
    gameManager.checkGameEnd()
end

function NextLevel()
    mainGame.load()
    backGroundImage = levelProfile.bgSprite
    if gameWin then
        levelCurrentIndex = math.fmod(levelCurrentIndex, GetLevelProfilesCount())
        levelCurrentIndex = levelCurrentIndex + 1
    end

    if levelCurrentIndex <= 0 then
        levelCurrentIndex = 1
    end
end

function mainGame.mousepressed(x, y, button)
    gameManager.checkGameEnd()
    gridManager.mousepressed(button)
end

function mainGame.update(dt)
    hud:update(dt)
    gameManager:update(dt)

    if not gameEnded then
        gridManager.update(dt)
        mousePositionX, mousePositionY = love.mouse.getPosition()
        mousePositionX = mousePositionX * (desired_width / SCREEN_SIZE_X)
        mousePositionY = mousePositionY * (desired_height / SCREEN_SIZE_Y)
    end
end

return mainGame