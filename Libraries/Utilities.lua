--[[ Utilities.lua
    Adds shortcuts to make code shorter, more optimized, and less redundant.
]]

local Framework = ({...})[1] or nil
if typeof(Framework) ~= "table" then error("framework not added") end

if Framework.Modules.Utilities then
    error("Utilities already loaded")
end

local Utilities = {}
Framework.Modules.Utilities = Utilities

-- Grab dependencies
local services  = Framework.Services
local signals   = Framework.Modules.SignalHandler
local instances = Framework.Modules.InstanceManager

-- code

Utilities.Stroke    = function(params: table)
    local props = {
        Object      = params.Object or nil,
        Inner       = params.Inner or false,
        Padding     = params.Padding or 0,
        Element     = params.Element or false,
        Thickness   = params.Thickness or 1,
        _ZIndex     = params._ZIndex or 1,
        Color       = params.Color or Color3.new(1, 1, 1),
        JoinMode    = params.JoinMode or Enum.LineJoinMode.Miter,
        StrokeMode  = params.StrokeMode or Enum.ApplyStrokeMode.Border,
    }
    local Stroke
    if props.Inner and props.Padding then
        local strokeholder = instances.create("Frame", {
            Parent = props.Object,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -props.Padding, 1, -props.Padding),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            ZIndex = props._ZIndex
        })
        Stroke = instances.create("UIStroke", {
            Parent = strokeholder,
            Color = props.Color,
            Thickness = props.Thickness,
            ApplyStrokeMode = props.StrokeMode,
            LineJoinMode = props.JoinMode
        })
    else
        Stroke = instances.create("UIStroke", {
            Parent = props.Object,
            Color = props.Color,
            Thickness = props.Thickness,
            ApplyStrokeMode = props.StrokeMode,
            LineJoinMode = props.JoinMode
        })
    end
    return Stroke
end
Utilities.Draggable = function(object: GuiObject, ignored: GuiObject)
    local hover = false
    if ignored then
        signals.connect(ignored.MouseEnter, function()
            hover = true
        end)
        signals.connect(ignored.MouseLeave, function()
            hover = false
        end)
    end

    local dragStart, startPos, dragging
    signals.connect(object.InputBegan, function(input)
        if ignored and hover ~= true or not ignored then
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = object.Position
            end
        end
    end)
    signals.connect(services["UserInputService"].InputChanged, function(input)
        if not hover then
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                local newX = startPos.X.Offset + delta.X
                local newY = startPos.Y.Offset + delta.Y

                object.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
            end
        end
    end)
    signals.connect(services["UserInputService"].InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end
Utilities.Resizable = function(object: GuiObject, button: GuiObject)
    local dragging, currentsize
    local presetsize = object.Size
    signals.connect(button.MouseButton1Down, function(input)
        dragging = true
    end)
    signals.connect(services["Players"].LocalPlayer:GetMouse().Move, function(input)
        if dragging then
            local MouseLocation = game:GetService("UserInputService"):GetMouseLocation()
            local X = math.clamp(MouseLocation.X - object.AbsolutePosition.X, presetsize.X.Offset, 9999)
            local Y = math.clamp((MouseLocation.Y - 36) - object.AbsolutePosition.Y, presetsize.Y.Offset, 9999)
            currentsize = UDim2.new(0, X, 0, Y)
            object.Size = currentsize
        end
    end)
    signals.connect(services["UserInputService"].InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end
Utilities.unload = function()
    Framework.Modules.Utilities = nil
    Utilities = nil
end

return Utilities
