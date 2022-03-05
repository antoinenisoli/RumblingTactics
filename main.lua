local gameManager = require 'scripts/gameManager'
local rescueShip = require 'scripts/entities/rescueShip'
local hud = require 'scripts/UI/hud'
local enemySpawner = require 'scripts/enemySpawner'
local gridManager = require 'scripts/system/gridManager'
local levelProfilesBank = require 'scripts.profiles.levelProfilesBank'
local soundManager = require 'scripts.soundManager'
flux = require "libraries.flux"

local splashes = {
    ["o-ten-one"]           = {module="o-ten-one"},
    ["o-ten-one: lighten"]  = {module="o-ten-one", {fill="lighten"}},
    ["o-ten-one: rain"]     = {module="o-ten-one", {fill="rain"}},
    ["o-ten-one: black"]    = {module="o-ten-one", {background={0, 0, 0}}},
  }

local splash 

mousePositionX, mousePositionY = 0, 0
local scaleFactor = 1
local t, shakeMagnitude = 0,0
local backGroundImage = love.graphics.newImage("assets/sprites/bg.png")
local moonshine = require 'scripts/moonshine'
local postEffect = nil

local levelCurrentIndex = 1
levelProfile = nil

local instances = {}
local allEnemies = {}
local vid = nil

desired_width = 1920
desired_height = 1080 
local xoffset = 0
local yoffset = 0
SCREEN_SIZE_X = 0
SCREEN_SIZE_Y = 0
ScreenScale = {}
local scaleM

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
    love.window.setFullscreen(true)
    SCREEN_SIZE_X = love.graphics.getWidth()
    SCREEN_SIZE_Y = love.graphics.getHeight()
    ScreenScale = {}
    ScreenScale.x = SCREEN_SIZE_X / desired_width
    ScreenScale.y = SCREEN_SIZE_Y / desired_height
    scaleM = math.min(ScreenScale.x, ScreenScale.y)

    xoffset = (SCREEN_SIZE_X - desired_width * scaleM)/2
    yoffset = (SCREEN_SIZE_Y - desired_height * scaleM)/2

    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle('Rumbling Tactics')
    soundManager.clear()
    soundManager:load()
    math.randomseed(os.time())
    
    love.keyboard.keysPressed = {}
end

local function setupSplashes()
    for name, entry in pairs(splashes) do
        entry.module = require(entry.module)
        splashes[name] = function ()
            return entry.module(unpack(entry))
        end
    end
end

function love.load()
    setupGame()
    setupSplashes()

    t, shakeMagnitude = 0,0
    vid = love.graphics.newVideo("assets/videos/tuto.ogv")
    vid:play()

    levelProfile = levelProfilesBank.getProfile(levelCurrentIndex)
    backGroundImage = levelProfile.bgSprite

    hud:load()
    setupPostProcess()
    gridManager.setupMap(levelProfile.grid)

    gameManager.init(levelProfile.grid.startX, levelProfile.grid.startX * 2, levelProfile.grid.startY, levelProfile.grid.startY * 4)
    mainShip = rescueShip.new(levelProfile.grid.startX * 1.5, levelProfile.grid.startY * 2)
    setupSpawners()

    splash = splashes["o-ten-one: black"]()
    splash.onDone = function() flux.to(splash, 1, {alpha = 0}):oncomplete(function() splash = nil end) end
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

local function scaleToScreenSize()
    love.graphics.scale(ScreenScale.x, ScreenScale.y) 
    love.graphics.translate(xoffset, yoffset)
end

local function inPostProcess()
    if t > 0 then
        local dx = love.math.random(-shakeMagnitude, shakeMagnitude)
        local dy = love.math.random(-shakeMagnitude, shakeMagnitude)
        love.graphics.translate(xoffset + dx, dy + yoffset)
    end

    love.graphics.draw(backGroundImage, 0, 0)
    for index, value in ipairs(instances) do
        value:draw()
    end
end

function love.draw()
    postEffect(function()
        love.graphics.push()
        scaleToScreenSize()
        inPostProcess()
        love.graphics.pop()

        
    end)

    scaleToScreenSize()
    hud.draw()
    if splash ~= nil then
        splash:draw()
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
    if gameWin then
        levelCurrentIndex = math.fmod(levelCurrentIndex, GetLevelProfilesCount())
        levelCurrentIndex = levelCurrentIndex + 1
    end

    if levelCurrentIndex <= 0 then
        levelCurrentIndex = 1
    end
    love.load()
end

function love.mousepressed(x, y, button)
    gameManager.checkGameEnd()
    gridManager.mousepressed(button)
end

function love.update(dt)
    if splash ~= nil then
        splash:update(dt)
    end

    flux.update(dt)
    hud:update(dt)
    gameManager:update(dt)

    if t >= 0 then
        t = t - dt
    end

    if not gameEnded then
        gridManager.update(dt)
        mousePositionX, mousePositionY = love.mouse.getPosition()
        mousePositionX = mousePositionX * (desired_width / SCREEN_SIZE_X)
        mousePositionY = mousePositionY * (desired_height / SCREEN_SIZE_Y)

        for index, value in ipairs(instances) do
            value:update(dt)
        end
    end
end
