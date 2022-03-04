local levelProfilesBank = {}
local profiles = {}

function levelProfilesBank.getProfile(index)
    profiles = {
        [1] = {
            index = 1,
            bgSprite = love.graphics.newImage("assets/sprites/bg.png"),
            levelData = require 'levels.level01',
            citizens = 100,
            money = 1000,

            rescueShip = {
                sprite = love.graphics.newImage('assets/sprites/rescueShip1.png'),
                startHealth = 1,
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
            }
        };

        [2] = {
            index = 2,
            bgSprite = love.graphics.newImage("assets/sprites/bg.png"),
            levelData = require 'levels.level02',
            citizens = 100,
            money = 100,

            rescueShip = {
                sprite = love.graphics.newImage('assets/sprites/rescueShip2.png'),
                startHealth = 50,
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
            }
        };

        [3] = {
            index = 3,
            bgSprite = love.graphics.newImage("assets/sprites/bg.png"),
            levelData = require 'levels.level03',
            citizens = 100,
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
            }
        };
    }

    return profiles[index]
end

function GetLevelProfilesCount()
    return #profiles
end

return levelProfilesBank