local hud = require 'scripts/UI/hud'
local startMenu = require 'scripts.UI.startMenu'
local mainGame = require 'scripts.system.mainGame'
local moonshine = require 'scripts/moonshine'
flux = require "libraries.flux"
font = love.graphics.newFont("assets/fonts/8-bit-hud.ttf", 10)

gameState = "menu"
t, shakeMagnitude = 0,0
postEffect = nil
instances  = {}

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
    math.randomseed(os.time())
    love.keyboard.keysPressed = {}
end

function love.load()
    love.graphics.setFont(font)
    setupGame()
    setupPostProcess()

    SetGameState(gameState)
end

function SetGameState(state)
    gameState = state
    if state == "menu" then
        startMenu:load()
    elseif state == "game" then
        mainGame.load()
    end
end

function CameraShake(duration, magnitude)
    t, shakeMagnitude = duration, magnitude 
end

function NewInstance(element)
    table.insert(instances, element)
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

function scaleToScreenSize()
    love.graphics.scale(ScreenScale.x, ScreenScale.y) 
    love.graphics.translate(xoffset, yoffset)
end

local function inPostProcess()
    if t > 0 then
        local dx = love.math.random(-shakeMagnitude, shakeMagnitude)
        local dy = love.math.random(-shakeMagnitude, shakeMagnitude)
        love.graphics.translate(xoffset + dx, dy + yoffset)
    end

    mainGame.draw()
    for index, value in ipairs(instances) do
        value:draw()
    end
end

function love.draw()
    if gameState == "menu" then  
        postEffect(function() 
            love.graphics.push()
            scaleToScreenSize()
            startMenu:draw()     
            love.graphics.pop()
        end)

    elseif gameState == "game" then    
        postEffect(function()
            love.graphics.push()
            scaleToScreenSize()
            inPostProcess()
            love.graphics.pop()
        end)

        scaleToScreenSize()
        hud.draw()
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if gameState == "game" then 
        mainGame.keypressed(key)
    end
end

function love.mousepressed(x, y, button)
    if gameState == "game" then 
        mainGame.mousepressed(x, y, button)
    else
        startMenu.mousepressed(button)
    end
end

function love.update(dt)
    flux.update(dt)
    if t >= 0 then
        t = t - dt
    end

    mousePositionX, mousePositionY = love.mouse.getPosition()
    mousePositionX = mousePositionX * (desired_width / SCREEN_SIZE_X)
    mousePositionY = mousePositionY * (desired_height / SCREEN_SIZE_Y)

    if gameState == "menu" then
        startMenu:update(dt)

    elseif gameState == "game" then
        mainGame.update(dt)
        if not gameEnded then
            for index, value in ipairs(instances) do
                value:update(dt)
            end
        end
    end
end
