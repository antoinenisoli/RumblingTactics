local levelProfilesBank = {}
local profiles = {}

function levelProfilesBank.getProfile(index)
    profiles = {
        [1] = {
            index = 1,
            bgSprite = love.graphics.newImage("assets/sprites/bg.png"),
            levelData = require 'levels.level01',
            citizens = 50,
            money = 500,

            rescueShip = {
                sprite = love.graphics.newImage('assets/sprites/rescueShip1.png'),
                startHealth = 15,
                scale = 1.3,
                occupiedTiles = {
                    59,
                    60,
                    61,
                };
            };

            grid = {
                startX = 700,
                startY = 250,
                size = {
                    x = 640,
                    y = 640,
                };
            },

            enemyStats = {
                turretSpritesheet = love.graphics.newImage('assets/sprites/BlueTurrets/turret_01_mk1.png'),
                startHealth = 15,
                damage = 1,
                speed = 60,
                shootRate = 2,
                scoreValue = 25,
                minDistance = 200
            }
        };

        [2] = {
            index = 2,
            bgSprite = love.graphics.newImage("assets/sprites/bg.png"),
            levelData = require 'levels.level02',
            citizens = 85,
            money = 100,

            rescueShip = {
                sprite = love.graphics.newImage('assets/sprites/rescueShip2.png'),
                startHealth = 25,
                scale = 1.3,
                occupiedTiles = {
                    59,
                    60,
                    61,
                };
            };

            grid = {
                startX = 700,
                startY = 250,
                size = {
                    x = 640,
                    y = 640,
                };
            },

            enemyStats = {
                turretSpritesheet = love.graphics.newImage('assets/sprites/BlueTurrets/turret_01_mk2.png'),
                startHealth = 30,
                damage = 2,
                speed = 75,
                shootRate = 1.8,
                scoreValue = 35,
                minDistance = 250
            }
        };

        [3] = {
            index = 3,
            bgSprite = love.graphics.newImage("assets/sprites/bg.png"),
            levelData = require 'levels.level03',
            citizens = 150,
            money = 100,

            rescueShip = {
                sprite = love.graphics.newImage('assets/sprites/rescueShip3.png'),
                startHealth = 50,
                scale = 1.3,
                occupiedTiles = {
                    47,
                    48,
                    49,
                    50,
                    51,
                    58,
                    59,
                    60,
                    61,
                    62,
                };
            };

            grid = {
                startX = 700,
                startY = 250,
                size = {
                    x = 640,
                    y = 640,
                };
            },

            enemyStats = {
                turretSpritesheet = love.graphics.newImage('assets/sprites/BlueTurrets/turret_01_mk4.png'),
                startHealth = 65,
                damage = 5,
                speed = 90,
                shootRate = 1.5,
                scoreValue = 50,
                minDistance = 300
            }
        };
    }

    return profiles[index]
end

function GetLevelProfilesCount()
    return #profiles
end

return levelProfilesBank