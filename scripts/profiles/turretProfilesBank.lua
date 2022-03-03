local turretProfilesBank = {}

function turretProfilesBank.getProfile(index)
    local profiles = {
        [1] = {
            index = 1,
            sprite = love.graphics.newImage('assets/sprites/turret01.png'),
            damage = 1,
            cost = 50,
            shootRate = 0.8,
            minDistance = 300,
        };

        [2] = {
            index = 2,
            sprite = love.graphics.newImage('assets/sprites/turret02.png'),
            damage = 2,
            cost = 100,
            shootRate = 1,
            minDistance = 400,
        };

        [3] = {
            index = 3,
            sprite = love.graphics.newImage('assets/sprites/turret03.png'),
            damage = 3,
            cost = 150,
            shootRate = 1.45,
            minDistance = 400,
        };

        [4] = {
            index = 4,
            sprite = love.graphics.newImage('assets/sprites/turret04.png'),
            damage = 2,
            cost = 200,
            shootRate = 0.2,
            minDistance = 150,
        };

        [5] = {
            index = 5,
            sprite = love.graphics.newImage('assets/sprites/turret05.png'),
            damage = 5,
            cost = 220,
            shootRate = 2,
            minDistance = 3000,
        };
    }

    return profiles[index]
end

return turretProfilesBank