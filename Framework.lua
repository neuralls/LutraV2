--[[ Framework.lua
  Main base of the repository.
]]

local moduleName = "Framework"

local Import = ({...})[1] or nil
if typeof(Import) ~= "function" then
    error("Dependency loader not provided to " .. moduleName)
end

local Framework = {
    Modules = {
        --[[
            Name = Table
        ]]
    },
    SharedData = {},
    Connections = {}
}

function Framework.unload()
    for _, module in pairs(Framework.Modules) do
        if module.Unload then
            module.Unload()
        end
    end
end

do -- Signal Handling
    local SignalHandler = {}

    SignalHandler.connect = function(signal: RBXScriptSignal, callback)
        local connection = signal:Connect(callback)
        table.insert(Framework.Connections, connection)
        return connection
    end
    SignalHandler.unload = function()
        for _, connection in ipairs(Framework.Connections) do
            connection:Disconnect()
        end
    end

    Framework.Modules.SignalHandler = SignalHandler
end

return Framework
