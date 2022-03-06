local menuButton = require 'scripts.UI.menu.menuButton'
local soundManager = require 'scripts.soundManager'

local startMenu = {}
local logoScale = {
    x = 1.5,
    y = 1.5,
}

local introductionLines = {}
local test = true
local buttons = {}

local menuState = "menu"
local logoImage = love.graphics.newImage("assets/sprites/logo.png")
local splash
local splashes = {
    ["o-ten-one"]           = {module="o-ten-one"},
    ["o-ten-one: lighten"]  = {module="o-ten-one", {fill="lighten"}},
    ["o-ten-one: rain"]     = {module="o-ten-one", {fill="rain"}},
    ["o-ten-one: black"]    = {module="o-ten-one", {background={0, 0, 0}}},
  }

local function SetMenuState(state)
    menuState = state
end

local function setupSplashes()
    for name, entry in pairs(splashes) do
        entry.module = require(entry.module)
        splashes[name] = function ()
            return entry.module(unpack(entry))
        end
    end
end

local function tween()
    if test then
        flux.to(logoScale, 2.5, {x = 1.3, y = 1.3}):ease("linear"):oncomplete(tween)
    else
        flux.to(logoScale, 2.5, {x = 1.5, y = 1.5}):ease("linear"):oncomplete(tween)
    end

    test = not test
end

local function newButton(x,y,name,func)
    local button = menuButton.new(x,y,name,func)
    table.insert(buttons, button)
end

local function setupButtons()
    local spacing = 150
    local startY = 350

    newButton(desired_width/2, startY + spacing, "Start", function()
        startMenu.startGame()
    end)

    newButton(desired_width/2, startY + spacing*2, "Quit", function()
        love.event.quit()
    end)

    newButton(desired_width/2, startY + spacing*3, "Instructions", function()
        SetMenuState("gameIntro")
    end)
end

function startMenu:load()
    for line in love.filesystem.lines("data.txt") do
        table.insert(introductionLines, line)
    end

    setupButtons()
    tween()
    soundManager.playSound("menuTheme", true, 0.3)
    setupSplashes()
    splash = splashes["o-ten-one: black"]()
    
    splash.onDone = 
    function() 

        flux.to(splash, 1, {alpha = 0}):oncomplete(function() 
            self.startMenu()
        end) 

    end
end

function startMenu.startGame()
    splash = nil 
    SetGameState("game")
end

function startMenu.startMenu()
    SetMenuState("menu")
end

function startMenu.mousepressed(button)
    if button == 1 then
        for index, value in ipairs(buttons) do
            if value:OnMouse() then
                value:Click()
            end
        end
    end
end

function startMenu:draw()
    if menuState == "menu" then
        love.graphics.draw(logoImage, desired_width/2, logoImage:getHeight()/2 + 100, nil, logoScale.x, logoScale.y, logoImage:getWidth()/2, logoImage:getHeight()/2)
        for index, value in ipairs(buttons) do
            value:draw()
        end

    elseif menuState == "gameIntro" then
        local scale = 1.5
        for index, value in ipairs(introductionLines) do
            local txt = love.graphics.newText(font, value)
            local width = txt:getWidth() * scale
            local height = txt:getHeight() * scale

            love.graphics.draw(txt, desired_width/2 + 75 * scale, 25 - scale + height * index, nil, scale, scale, width/2, height/2)
        end
    else
        if splash ~= nil then
            splash:draw()
        end
    end
end

function startMenu:update(dt)
    if splash ~= nil then
        splash:update(dt)
    end

    for index, value in ipairs(buttons) do
        value:update(dt)
    end
end

return startMenu