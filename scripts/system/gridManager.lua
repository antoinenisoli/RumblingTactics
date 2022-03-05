local gameManager = require 'scripts/gameManager'
local tile = require 'scripts/entities/tile'
local turretProfilesBank = require 'scripts.profiles.turretProfilesBank'

local gridManager = {}
local grid = {}
local selectedTile = nil
local allTiles = {}
local turretProfile = nil

function gridManager.setupMap(newGrid)
    turretProfile = turretProfilesBank.getProfile(1)
    selectedTile = nil
    allTiles = {}
    grid = newGrid

    local index = 0
    local count = (grid.size.x/64 + 1) * (grid.size.y/64 + 1)
    for x = 0, grid.size.x, 64 do
        for y = 0, grid.size.y, 64 do
            index = index + 1
            local currentTile = tile.new(grid.startX + x, grid.startY + y, "tile"..tostring(index))
            NewInstance(currentTile)
            table.insert(allTiles, index, currentTile)

            for i, value in ipairs(levelProfile.rescueShip.occupiedTiles) do
                if index == value  then
                    currentTile.locked = true
                end
            end
        end
    end
end

function gridManager.setProfile(index)
    turretProfile = turretProfilesBank.getProfile(index)
end

function gridManager.mousepressed(button)
    if not gameEnded then
        if button == 1 then
            if selectedTile ~= nil then
                selectedTile:Click(turretProfile)
            end
        end
    end
end

function gridManager.update(dt)
    selectedTile = nil
    for index, value in ipairs(allTiles) do
        if (value:OnMouse() and gameManager.canBuy(turretProfile.cost)) then
            selectedTile = value
        end
    end
end

return gridManager