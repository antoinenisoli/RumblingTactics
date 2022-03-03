local gameManager = require 'scripts/gameManager'
local tile = require 'scripts/entities/tile'
local turretProfilesBank = require 'scripts.profiles.turretProfilesBank'

local gridManager = {}
local gridSizeX, gridSizeY = 640, 640
local startX, startY = 700, 250
local selectedTile = nil
local allTiles = {}
local turretProfile = nil

function gridManager.setupMap()
    turretProfile = turretProfilesBank.getProfile(1)
    local index = 0
    local count = (gridSizeX/64 + 1) * (gridSizeY/64 + 1)
    --local shipSize = 3
    for x = 0, gridSizeX, 64 do
        for y = 0, gridSizeY, 64 do
            index = index + 1
            local currentTile = tile.new(startX + x, startY + y, "tile"..tostring(index))
            NewInstance(currentTile)
            table.insert(allTiles, index, currentTile)

            if index > count/2 - 2 and index < count/2 + 1  then
                currentTile.locked = true
            end
        end
    end
end

function gridManager.setProfile(index)
    turretProfile = turretProfilesBank.getProfile(index)
end

function gridManager.mousepressed(button)
    if button == 1 then
        if selectedTile ~= nil then
            selectedTile:Click(turretProfile)
        end
    end
end

function gridManager.update(dt)
    selectedTile = nil
    for index, value in ipairs(allTiles) do
        if (value:OnMouse() and gameManager.canBuy(turretCost)) then
            selectedTile = value
        end
    end
end

return gridManager