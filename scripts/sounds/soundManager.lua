soundManager = {}
local globalVolume = 0.1

function soundManager:load()
    local music = love.audio.newSource('assets/sounds/musics/DOS-88 - Automatav2.mp3', "stream")
    music:setVolume(globalVolume)
    music:play()
end

function soundManager.shoot(pitch)
    local sound = love.audio.newSource('assets/sounds/8bit Sound Pack/Shoot2.mp3', "static")
    sound:setVolume(globalVolume)
    sound:setPitch(pitch)
    sound:play()
end

function soundManager.playSound(path, pitch)
    local sound = love.audio.newSource(path, "static")
    sound:setVolume(globalVolume)
    sound:setPitch(pitch)
    sound:play()
end

return soundManager