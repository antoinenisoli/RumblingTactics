local floatingText = require 'scripts/UI/floatingText'
local turretSlot = require 'scripts/UI/turretSlot'
local gridManager = require 'scripts/system/gridManager'

local hud = {}
local uiElements = {}
local turretSlots = {}
local font = love.graphics.newFont("assets/fonts/8-bit-hud.ttf", 10)
local scale = 3
local index = 1

local fadeValue = 0
local fadeSpeed = 1

function hud:load()
    love.graphics.setFont(font)
    uiElements = {}
    turretSlots = {}
    local offset = 100
    local count = 4
    local index = 1
    local start = 775
    fadeValue = 0

    for i = start, start + offset * count, offset do
        local slot = turretSlot.new(i, 1025, index)
        table.insert(uiElements, slot)
        table.insert(turretSlots, slot)
        index = index + 1

        if i == start then
            slot.selected = true
        end
    end
end

function hud.moveIndex(direction)
    index = math.fmod(math.abs(index), #turretSlots)
    index = index + 1 * direction
    if index == -1 then
        index = #turretSlots - 1
    elseif index == 0 then
        index = #turretSlots
    end

    --print(index)
    gridManager.setProfile(index)
    for i, value in ipairs(turretSlots) do
        value.selected = index == i
    end
end

local function drawGameEnd()
    local text = gameWin and "Evacuation done !" or "Abort the evacuation !"
        love.graphics.setColor(0, 0, 0, fadeValue * 0.8)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.setColor(1, 1, 1, fadeValue)
        love.graphics.print(text, love.graphics.getWidth()/2 - 50 * scale, 500, nil, scale, scale)
        love.graphics.print("Press any key to go to the next level.", love.graphics.getWidth()/2 - 50 * scale, 600, nil, scale, scale)
        love.graphics.setColor(1, 1, 1, 1)
end

function hud.draw()
    if gameEnded then
        drawGameEnd()
    end

    love.graphics.print("Citizens : "..tostring(citizens), love.graphics.getWidth()/2 - 50 * scale, 100, nil, scale, scale)
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.print("Money : "..tostring(currentMoney), love.graphics.getWidth()/2 - 50 * scale, 50, nil, scale, scale)
    love.graphics.setColor(1, 1, 1, 1)

    for index, value in ipairs(uiElements) do
        value:draw()
    end
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

    if gameEnded then
        fadeValue = fadeValue + dt * fadeSpeed
        if fadeValue > 1 then
            fadeValue = 1
        end
    end
end

return hud