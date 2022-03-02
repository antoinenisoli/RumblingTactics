local enemy = require 'scripts/entities/enemy'
local tile = require 'scripts/entities/tile'
local rescueShip = require 'scripts/entities/rescueShip'
local hud = require 'scripts/hud'
local enemySpawner = require 'scripts/enemySpawner'

mousePositionX, mousePositionY = 0, 0
scaleFactor = 1
mainShip = nil
local gridSizeX, gridSizeY = 640, 640
local startX, startY = 700, 250
local t, shakeMagnitude = 0,0
local selectedTile = nil
local allTiles = {}
local instances = {}
local allEnemies = {}
local spawners = {}

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle('Jam')
    love.window.setFullscreen(true)
    love.keyboard.keysPressed = {}

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

    mainShip = rescueShip.new(startX * 1.5, startY * 2)
    NewInstance(mainShip)

    table.insert(spawners, enemySpawner.new(0, love.graphics.getHeight()/2, 1))
    table.insert(spawners, enemySpawner.new(love.graphics.getWidth(), love.graphics.getHeight()/2, -1))
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

function love.draw()
    if t > 0 then
        local dx = love.math.random(-shakeMagnitude, shakeMagnitude)
        local dy = love.math.random(-shakeMagnitude, shakeMagnitude)
        love.graphics.translate(dx, dy)
    end

    love.graphics.push()
    love.graphics.scale(scaleFactor, scaleFactor)   -- reduce everything by 50% in both X and Y coordinates
    hud.draw()
    love.graphics.print("mouse : "..tostring(mousePositionX).." "..tostring(mousePositionY))
    if selectedTile ~= nil then
        love.graphics.print(selectedTile.name, 0, 25)
    end

    for index, value in ipairs(instances) do
        value:draw()
    end

    love.graphics.pop()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.mousepressed(x, y, button)
    if button == 1 then
        print("click")
        if selectedTile ~= nil then
            selectedTile:Click()
        end
    end
end

function love.update(dt)
    selectedTile = nil
    mousePositionX, mousePositionY = love.mouse.getPosition()

    for index, value in ipairs(spawners) do
        value:runTimer(dt)
    end

    for index, value in ipairs(instances) do
        value:update(dt)
    end

    for index, value in ipairs(allTiles) do
        if (value:OnMouse()) then
            selectedTile = value
        end
    end

    if t >= 0 then
        t = t - dt
    end
end
