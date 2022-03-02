local entity = {}
entity.__index = entity

function entity.new(x, y)
    local instance = setmetatable({}, entity)
    instance.x = x
    instance.y = y

    instance.width = 0
    instance.height = 0
    instance:setupShake()
    return instance
end

function entity:setupShake()
    self.localX = 0
    self.localY = 0
    self.t = 0
    self.shakeMagnitude = 0
end

function entity:drawCollider()
    love.graphics.setColor(0, 255, 0, 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.setColor(255, 255, 255, 1)
end

function entity:draw()
    self:drawCollider()
end

function entity:shake(duration, magnitude)
    self.t, self.shakeMagnitude = duration, magnitude 
end

function entity:manageShake(dt)
    if self.t >= 0 then
        self.t = self.t - dt
    end

    if self.t > 0 then
        self.localX = love.math.random(-self.shakeMagnitude, self.shakeMagnitude)
        self.localY = love.math.random(-self.shakeMagnitude, self.shakeMagnitude)
    else
        self.localX = 0
        self.localY = 0
    end
end

function entity:manageHit(dt)
    self.health.hitTimer = self.health.hitTimer - dt
    if self.health.hitTimer <= 0 then
        self.health.hit = false;
    end
end

function entity:update(dt)
    self:manageShake(dt)
end

return entity