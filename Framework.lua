--[[ Framework.lua
  Main base of the repository.
]]

local fileName = "Framework"

local Import = ({...})[1] or nil
if typeof(Import) ~= "function" then
    error("Import function not provided to " .. fileName)
end

local Framework = {
    Modules     = {},
    SharedData  = {},
    Connections = {},
    Instances   = {},
    Services = setmetatable({}, {
        __index = function(self, service)
            local serviceInstance = game:GetService(service)
            rawset(self, service, serviceInstance)
            return serviceInstance
        end
    })
}

function Framework.unload()
    for _, module in pairs(Framework.Modules) do
        if module.unload then
            module.unload()
        end
    end
    Framework.Services = nil
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

do -- Instance Manager
    local InstanceManager = {}
    local signals = Framework.Modules.SignalHandler

    InstanceManager.create = function(Class: Instance, Properties: PhysicalProperties, Events: boolean, Conditions: table)
        local _Instance = type(Class) == 'string' and Instance.new(Class) or Class
        for Property, Value in next, Properties do
            _Instance[Property] = Value
        end

        -- signals
        if Events then
            local binds = {
                Enter = Instance.new("BindableEvent"),
                Leave = Instance.new("BindableEvent"),
                Press = Instance.new("BindableEvent"),
            }

            for name, bind in pairs(binds) do
                bind.Parent = _Instance
                bind.Name = name
                table.insert(Framework.Instances, _Instance)
            end

            local function checkConditions(tbl)
                if tbl == nil then return true end
                for _, func in pairs(tbl) do
                    if func() then return false end
                end
                return true
            end

            signals.connect(_Instance.MouseEnter, function()
                if checkConditions(Conditions) then binds.Enter:Fire() end
            end)
            signals.connect(_Instance.MouseLeave, function()
                if checkConditions(Conditions) then binds.Leave:Fire() end
            end)
            signals.connect(_Instance.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if checkConditions(Conditions) then binds.Press:Fire() end
                end
            end)
        end

        table.insert(Framework.Instances, _Instance)
        return _Instance
    end
    InstanceManager.unload = function()
        for _, instance in pairs(Framework.Instances) do
            instance:Destroy()
        end
    end

    Framework.Modules.InstanceManager = InstanceManager
end

return Framework
