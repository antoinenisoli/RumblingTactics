local entity = {}
entity.__index = entity

function entity.new(x, y)
    local instance = setmetatable({}, entity)
    instance.x = x
    instance.y = y
    instance.width = 0
    instance.height = 0
    return instance
end

function entity:drawCollider()
    love.graphics.setColor(0, 255, 0, 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.setColor(255, 255, 255, 1)
end

function entity:draw()
    self:drawCollider()
end

function entity:update(dt)
    
end

return entity