local gameManager = require 'scripts/gameManager'
local rescueShip = require 'scripts/entities/rescueShip'
local hud = require 'scripts/UI/hud'
local enemySpawner = require 'scripts/enemySpawner'
local lvl = require 'levels.level01'
local gridManager = require 'scripts/system/gridManager'

mousePositionX, mousePositionY = 0, 0
scaleFactor = 1
mainShip = nil
local startX, startY = 700, 250
local t, shakeMagnitude = 0,0
local backGroundImage = love.graphics.newImage("assets/sprites/bg.png")
local moonshine = require 'scripts/moonshine'
local postEffect = nil

local instances = {}
local allEnemies = {}

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
    for index, value in ipairs(lvl.layers[2].objects) do
        local s = enemySpawner.new(value.x, value.y)
        gameManager.newSpawner(s)
    end
end

local function setupGame()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle('Jam')
    love.window.setFullscreen(true)
    love.keyboard.keysPressed = {}
end

function love.load()
    hud:load()
    setupGame()
    setupPostProcess()
    gridManager.setupMap()

    gameManager.init(startX, startX * 2, startY, startY * 4)
    mainShip = rescueShip.new(startX * 1.5, startY * 2)
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

function GameOver()
    love.event.quit('restart')
end

function GameWin()
    love.event.quit('restart')
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
end

function love.mousepressed(x, y, button)
    gridManager.mousepressed(button)
end

function love.update(dt)
    gridManager.update(dt)
    mousePositionX, mousePositionY = love.mouse.getPosition()
    hud:update(dt)
    gameManager:update(dt)

    for index, value in ipairs(instances) do
        value:update(dt)
    end

    if t >= 0 then
        t = t - dt
    end
end
