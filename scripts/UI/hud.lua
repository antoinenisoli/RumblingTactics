local gameManager = require 'scripts/gameManager'
local floatingText = require 'scripts/UI/floatingText'

local hud = {}
local uiElements = {}
Font = love.graphics.newFont("assets/fonts/8-bit-hud.ttf", 10)

function hud:load()
    for i = 1, 10, 1 do
        
    end
end

function hud.draw()
    love.graphics.setFont(Font)
    local scale = 3
    love.graphics.print("mouse : "..tostring(mousePositionX).." "..tostring(mousePositionY))
    love.graphics.print("Citizens : "..tostring(citizens), love.graphics.getWidth()/2, 100, nil, scale, scale)

    love.graphics.setColor(255, 255, 0, 1)
    love.graphics.print("Money : "..tostring(currentMoney), love.graphics.getWidth()/2, 50, nil, scale, scale)
    for index, value in ipairs(uiElements) do
        value:draw()
    end

    love.graphics.setColor(255, 255, 255, 1)
end

function hud.newFloatingTxt(text, x, y, duration, r,g,b,a)
    local txt = floatingText.new(text, x, y, duration, r,g,b,a)
    table.insert(uiElements, txt)
end

function RemoveUI(uiElement)
    for index, value in ipairs(uiElements) do
        if value == uiElement then
            table.remove(uiElements, index)
        end
    end
end

function hud:update(dt)
    for index, value in ipairs(uiElements) do
        value:update(dt)
    end
end

return hud