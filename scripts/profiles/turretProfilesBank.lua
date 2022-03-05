local turretProfilesBank = {}
local profiles = {}

function turretProfilesBank.getProfile(index)
    local profiles = {
        [1] = {
            index = 1,
            sprite = love.graphics.newImage('assets/sprites/turret01.png'),
            damage = 1,
            cost = 65,
            shootRate = 1,
            minDistance = 300,
            shootSound = "turret1shoot",
        };

        [2] = {
            index = 2,
            sprite = love.graphics.newImage('assets/sprites/turret02.png'),
            damage = 2,
            cost = 100,
            shootRate = 0.8,
            minDistance = 400,
            shootSound = "turret1shoot",
        };

        [3] = {
            index = 3,
            sprite = love.graphics.newImage('assets/sprites/turret03.png'),
            damage = 3,
            cost = 150,
            shootRate = 2.5,
            minDistance = 500,
            shootSound = "turret1shoot",
        };

        [4] = {
            index = 4,
            sprite = love.graphics.newImage('assets/sprites/turret04.png'),
            damage = 1,
            cost = 200,
            shootRate = 0.2,
            minDistance = 150,
            shootSound = "turret4shoot",
        };

        [5] = {
            index = 5,
            sprite = love.graphics.newImage('assets/sprites/turret05.png'),
            damage = 1000,
            cost = 300,
            shootRate = 5,
            minDistance = math.huge,
            shootSound = "turret5shoot",
        };
    }

    return profiles[index]
end

return turretProfilesBank