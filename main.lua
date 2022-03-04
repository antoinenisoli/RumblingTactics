local gameManager = require 'scripts/gameManager'
local rescueShip = require 'scripts/entities/rescueShip'
local hud = require 'scripts/UI/hud'
local enemySpawner = require 'scripts/enemySpawner'
local gridManager = require 'scripts/system/gridManager'
local levelProfilesBank = require 'scripts.profiles.levelProfilesBank'
local soundManager = require 'scripts.soundManager'

mousePositionX, mousePositionY = 0, 0
scaleFactor = 1
local t, shakeMagnitude = 0,0
local backGroundImage = love.graphics.newImage("assets/sprites/bg.png")
local moonshine = require 'scripts/moonshine'
local postEffect = nil

local levelCurrentIndex = 1
levelProfile = nil

local instances = {}
local allEnemies = {}
local vid = nil

local function setupPostProcess()
    postEffect = moonshine(moonshine.effects.filmgrain)
                    .chain(moonshine.effects.vignette)
                    .chain(moonshine.effects.crt)
                    .chain(moonshine.effects.scanlines)
                    .chain(moonshine.effects.chromasep)
                    postEffect.chromasep.radius = 2
                    postEffect.scanlines.opacity = 0.5
                    postEffect.filmgrain.size = 2
end

local function setupSpawners()
    for index, value in ipairs(levelProfile.levelData.layers[2].objects) do
        local s = enemySpawner.new(value.x, value.y)
        gameManager.newSpawner(s)
    end
end

local function setupGame()
    soundManager.clear()
    soundManager:load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle('Jam')
    love.window.setFullscreen(true)
    love.keyboard.keysPressed = {}
end

function love.load()
    t, shakeMagnitude = 0,0
    vid = love.graphics.newVideo("assets/videos/tuto.ogv")
    vid:play()

    levelProfile = levelProfilesBank.getProfile(levelCurrentIndex)
    backGroundImage = levelProfile.bgSprite

    hud:load()
    setupGame()
    setupPostProcess()
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

function CameraShake(duration, magnitude)
    t, shakeMagnitude = duration, magnitude 
end

function NewInstance(element)
    table.insert(instances, element)
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

function RemoveInstance(element)
    for index, value in ipairs(instances) do
        if value == element then
            table.remove(instances, index)
        end
    end

    element = nil
end

function Distance(x1, y1, x2, y2)
    local i = math.pow((x2 - x1), 2) + math.pow((y2 - y1), 2)
    return math.sqrt(i)
end

function GetAngle(x1,y1, x2,y2) 
    return math.atan2(x2-x1, y2-y1) 
end

function NewColor(r, g, b, a)
    return r, g, b, a
end

function love.draw()
    love.graphics.push()
    postEffect(function()
        love.graphics.setDefaultFilter("nearest", "nearest")

    if t > 0 then
        local dx = love.math.random(-shakeMagnitude, shakeMagnitude)
        local dy = love.math.random(-shakeMagnitude, shakeMagnitude)
        love.graphics.translate(dx, dy)
    end

    love.graphics.draw(backGroundImage, 0,0)
    love.graphics.scale(scaleFactor, scaleFactor)   -- reduce everything by 50% in both X and Y coordinates
    for index, value in ipairs(instances) do
        value:draw()
    end

    end)

    hud.draw()
    love.graphics.pop()
    if vid:isPlaying() then
        --love.graphics.draw(vid, 0, 0)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'right' then
        hud.moveIndex(1)
    elseif key == 'left' then
        hud.moveIndex(-1)
    end

    love.keyboard.keysPressed[key] = true
    gameManager.checkGameEnd()
end

function NextLevel()
    mainShip = nil
    backGroundImage = love.graphics.newImage("assets/sprites/bg.png")
    instances = {}
    allEnemies = {}
    gameEnded = false
    levelTransition = false
    levelCurrentIndex = math.fmod(levelCurrentIndex, GetLevelProfilesCount())
    if gameWin then
        levelCurrentIndex = levelCurrentIndex + 1
    end

    love.load()
end

function love.mousepressed(x, y, button)
    gameManager.checkGameEnd()
    gridManager.mousepressed(button)
end

function love.update(dt)
    hud:update(dt)
    gameManager:update(dt)

    if t >= 0 then
        t = t - dt
    end

    if not gameEnded then
        gridManager.update(dt)
        mousePositionX, mousePositionY = love.mouse.getPosition()

        for index, value in ipairs(instances) do
            value:update(dt)
        end
    end
end
