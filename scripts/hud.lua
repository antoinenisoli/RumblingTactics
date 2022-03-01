local hud = {}

function hud.draw()
    local scale = 3
    love.graphics.print(citizens, love.graphics.getWidth()/2, 100, nil, scale, scale)
end

return hud