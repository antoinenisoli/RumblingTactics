local entity = require 'scripts/entities/entity'

local button = {}
button.__index = button
setmetatable(button, entity)

function button:OnMouse()
    return mousePositionX < (self.x + self.boundingBox.x/2) 
    and mousePositionX > (self.x - self.boundingBox.x/2) 
    and mousePositionY < (self.y + self.boundingBox.y/2) 
    and mousePositionY > (self.y - self.boundingBox.y/2) 
end

function button:CanClick()
    return self:OnMouse()
end

function button:Execute()
    
end

function button:Click()
    if self:CanClick() then
        self:Execute()
    end
end

return button