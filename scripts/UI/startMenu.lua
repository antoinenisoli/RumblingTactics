local startMenu = {}

local splashes = {
    ["o-ten-one"]           = {module="o-ten-one"},
    ["o-ten-one: lighten"]  = {module="o-ten-one", {fill="lighten"}},
    ["o-ten-one: rain"]     = {module="o-ten-one", {fill="rain"}},
    ["o-ten-one: black"]    = {module="o-ten-one", {background={0, 0, 0}}},
  }

local splash 

local function setupSplashes()
    for name, entry in pairs(splashes) do
        entry.module = require(entry.module)
        splashes[name] = function ()
            return entry.module(unpack(entry))
        end
    end
end

function startMenu.load()
    setupSplashes()
    splash = splashes["o-ten-one: black"]()
    splash.onDone = function() 
        flux.to(splash, 1, {alpha = 0}):oncomplete(function() 
            splash = nil 
            SetGameState("game")
        end) 
    end
end

function startMenu.startGame()
    
end

function startMenu:draw()
    postEffect(function()
        if splash ~= nil then
            splash:draw()
        end
    end)
    
end

function startMenu:update(dt)
    if splash ~= nil then
        splash:update(dt)
    end
end

return startMenu