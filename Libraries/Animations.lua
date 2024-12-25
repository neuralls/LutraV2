--[[ Animations.lua
    animations 🤷‍♂️.
]]

local Framework = ({...})[1] or nil
if typeof(Framework) ~= "table" then error("framework not added") end

if Framework.Modules.Animations then
    error("Animations already loaded")
end

local Animations = { Fonts = {} }
Framework.Modules.Animations = Animations

-- Grab dependencies
local services = Framework.Services
local signals  = Framework.Modules.SignalHandler

-- code
local Animations = {
    Info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), -- default setting
}

Animations.Tween = function(object, goal, callback)
    local tween = services["TweenService"]:Create(object, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), goal)
    signals.connect(tween.Completed, callback or function() end)
    tween:Play()
end

return Animations
