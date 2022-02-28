local mousePosition = 0
TileMap = {
    {0,0,0,1,1,0,1,0},
    {0,0,1,0,0,1,1,0},
    {0,1,0,0,0,0,1,0},
    {1,1,1,1,1,1,1,1},
    {0,1,0,0,0,0,1,0},
    {0,1,0,0,0,0,1,0},
    {0,1,0,1,1,0,1,0},
    {0,1,1,1,1,1,1,0},
  }

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Jam')
    love.window.setFullscreen(true)
    love.keyboard.keysPressed = {}
end

function love.draw()
    love.graphics.print("mouse : "..tostring(mousePosition))

    local img = love.graphics.newImage("assets/Isometric Tower Defense Pack/Sprites/Landscape tiles/grass.png")
    love.graphics.setColor(50,0,50,255)

    local startX, startY = 500, 50
    for x = 1, 1000, 50 do
        for y = 1, 1000, 50 do
            TileMap[y] = {}
			TileMap[x][y].r   = math.random(0, 255)
			TileMap[x][y].g  = math.random(0, 255)
			TileMap[x][y].b = math.random(0, 255)

            love.graphics.rectangle("fill", startX + x, startY + y, 40, 40)
            --love.graphics.draw(img, x, y, nil, 0.5, 0.5)
        end
    end
    love.graphics.setColor(255,255,255,255)
end

function love.update()
    mousePosition = love.mouse.getPosition()
    if (love.keyboard.isDown("escape")) then
        love.event.quit()
    end
end
