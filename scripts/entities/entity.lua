local entity = {}
entity.__index = entity

function entity.new(x, y)
    local instance = setmetatable({}, entity)
    instance.x = x
    instance.y = y

    instance.width = 0
    instance.height = 0
    instance.speed = 0
    instance:setupShake()
    return instance
end

function entity:setupShake()
    self.localX = 0
    self.localY = 0
    self.t = 0
    self.shakeMagnitude = 0
end

function entity:draw()
    
end

function entity:follow(dt, target)
    if self.x < target.x then 						-- If the rectangle is to the left of the circle:
        self.x = self.x + self.speed * dt			-- Rectangle moves towards the right.
    end
    
    if self.x > target.x then 						-- If the rectangle is to the right of the circle:
        self.x = self.x - self.speed * dt			-- Rectangle moves towards the left.
    end
    
    if self.y < target.y then 						-- If the rectangle is above the circle:
        self.y = self.y + self.speed * dt			-- Rectangle moves downward.
    end
    
    if self.y > target.y then 						-- If the rectangle is below the circle:
        self.y = self.y - self.speed * dt			-- Rectangle moves upward.
    end
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
    if self.health.hit then
        self.health.hitTimer = self.health.hitTimer - dt
        if self.health.hitTimer <= 0 then
            self.health.hit = false;
        end
    end
    
end

function entity:update(dt)
    
end

return entity