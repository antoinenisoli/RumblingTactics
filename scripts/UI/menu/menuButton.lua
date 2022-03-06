local button = require 'scripts.UI.button'

local menuButton = {}
menuButton.__index = menuButton
setmetatable(menuButton, button)
local buttonScale = {
    x = 5,
    y = 2
}

function menuButton.new(x, y, name, func)
    local instance = setmetatable({}, menuButton)
    instance.x = x
    instance.y = y
    instance.name = name
    instance.func = func

    instance.sprite = love.graphics.newImage("assets/sprites/hud/buttons/buttons_4x_04.png")
    instance.width = instance.sprite:getWidth()
    instance.height = instance.sprite:getHeight()
    instance.buttonScale = {
        x = 5,
        y = 2
    }

    instance.boundingBox = {
        x = instance.width * 4,
        y = instance.height * 1.5
    }

    return instance
end

function menuButton:Execute()
    self.func()
end

function menuButton:draw()
    love.graphics.draw(self.sprite, self.x, self.y, nil, self.buttonScale.x, self.buttonScale.y, self.width/2, self.height/2)
    local w, h = self.boundingBox.x, self.boundingBox.y
    love.graphics.rectangle('line', self.x - w/2, self.y - h/2, w, h)

    local txtScale = 3
    local txt = love.graphics.newText(font, self.name)
    local width = txt:getWidth()
    local height = txt:getHeight()
    love.graphics.setColor(0,0,0,1)
    love.graphics.draw(txt, self.x, self.y, nil, txtScale, txtScale, width/2, height/2)
    love.graphics.setColor(1,1,1,1)
end

function menuButton:update(dt)
    if not self:OnMouse() then
        self.buttonScale.x = 6
        self.buttonScale.y = 2
    else
        self.buttonScale.x = 6.5
        self.buttonScale.y = 2.5
    end
end

return menuButton