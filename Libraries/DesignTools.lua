--[[ DesignTools.lua
    Adds shortcuts to make design techniques shorter, optimized, and easily managable.
]]

local Framework = ({...})[1] or nil
if typeof(Framework) ~= "table" then print("framework not added") end

if Framework.DesignTools then
    error("DesignTools already loaded")
end

local services  = Framework.Services
local signals   = Framework.Modules.SignalHandler
local instances = Framework.Modules.InstanceManager
