local soundManager = {}
local globalVolume = 0.02
local storedSounds = {}
local allSounds = {
    [1] = {
        name = "mainTheme",
        sound = 'assets/sounds/Race to Mars.mp3',
    },

    [2] = {
        name = "engine",
        sound = 'assets/sounds/ENGINE Motor Heavy Loop 08.wav',
    },

    [3] = {
        name = "explosion",
        sound = 'assets/sounds/EXPLOSION Bang 04.wav',
    },

    [4] = {
        name = "turret1shoot",
        sound = 'assets/sounds/LASRGun_Plasma Rifle Fire_03.wav',
    },

    [5] = {
        name = "turret5shoot",
        sound = 'assets/sounds/GUNArtl_Rocket Launcher Fire_02.wav',
    },

    [6] = {
        name = "turret4shoot",
        sound = 'assets/sounds/LASRGun_Particle Compressor Fire_01.wav',
    },

    [7] = {
        name = "enemyShoot",
        sound = 'assets/sounds/GUNArtl_Rocket Launcher Fire_02.wav',
    },

    [8] = {
        name = "newCitizen",
        sound = 'assets/sounds/GetAPowerUp.wav',
    },

    [9] = {
        name = "gameWin",
        sound = 'assets/sounds/HeliShipLanging.wav',
    },

    [10] = {
        name = "earthquake",
        sound = 'assets/sounds/quake.mp3',
    },

    [11] = {
        name = "newTurret",
        sound = 'assets/sounds/MOTRSrvo_Plasma Rifle Arm_01.wav',
    },

    [12] = {
        name = "menuTheme",
        sound = 'assets/sounds/Checking Manifest.mp3',
    },
}

function soundManager.playSound(name, loop, volume, pitch)
    for index, value in ipairs(allSounds) do
        if value.name == name then
            local sound = love.audio.newSource(value.sound, "stream")
            sound:setVolume(volume or globalVolume)
            sound:setPitch(pitch or 1)
            sound:setLooping(loop or false)
            sound:play()
            table.insert(storedSounds, sound)
            return sound
        end
    end

    return nil
end

function soundManager.clear()
    for index, value in ipairs(storedSounds) do
        value:stop()
    end

    storedSounds = {}
end

function soundManager:load()
    local music = love.audio.newSource(allSounds[1].sound, "static")
    music:setVolume(0.1)
    music:setLooping(true)
    music:play()
    table.insert(storedSounds, music)
end

return soundManager