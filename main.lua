mousePositionX, mousePositionY = 0, 0
scaleFactor = 1
local gridSizeX, gridSizeY = 640, 640
local enemy = require 'scripts/entities/enemy'
local tile = require 'scripts/entities/tile'
local selectedTile = nil
local allTiles = {}
local instances = {}

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Jam')
    love.window.setFullscreen(true)
    love.keyboard.keysPressed = {}

    local startX, startY = 700, 250
    for x = 0, gridSizeX, 64 do
        for y = 0, gridSizeY, 64 do
            local currentTile = tile.new(startX + x, startY + y, "tile"..tostring(x+y))
            NewInstance(currentTile)
            table.insert(allTiles, currentTile)
        end
    end

    newEnemy = enemy.new(0, startY*2, "enemy0")
    NewInstance(newEnemy)
end

function NewInstance(element)
    table.insert(instances, element)
end

function love.draw()
    love.graphics.push()

    love.graphics.scale(scaleFactor, scaleFactor)   -- reduce everything by 50% in both X and Y coordinates
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
    for index, value in ipairs(instances) do
        value:update(dt)
    end

    for index, value in ipairs(allTiles) do
        if (value:OnMouse()) then
            selectedTile = value
        end
    end
end
