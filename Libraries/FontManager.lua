--[[ FontManager.lua
    Minimal, optimized font loader with caching and unload functionality.
]]

local Framework = ({...})[1] or nil
if typeof(Framework) ~= "table" then error("framework not added") end

if Framework.Modules.FontManager then
    error("FontManager already loaded")
end

local Utilities = {}
Framework.Modules.Utilities = Utilities

-- Grab dependencies
local services  = Framework.Services

if not isfolder("DrawingFontCache") then
    makefolder("DrawingFontCache")
end

local FontManager = { Fonts = {} }

function FontManager.create(name, source)
    if source:match("https") then
        source = request({Url = source .. name}).Body
    end

    local path = isfile(source) and source or `DrawingFontCache/{name}.ttf`
    if not isfile(path) then writefile(path, crypt.base64.decode(source)) end

    local temp = services.HttpService:GenerateGUID(false)
    writefile(temp, services.HttpService:JSONEncode({
        name = name,
        faces = {{name = "Regular", weight = 100, style = "normal", assetId = getcustomasset(path)}}
    }))

    local font = Font.new(getcustomasset(temp), Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    FontManager.Fonts[name] = font
    delfile(temp)
    return font
end

function FontManager.unload(name, removeFile)
    if FontManager.Fonts[name] then
        FontManager.Fonts[name] = nil
        if removeFile and isfile(`DrawingFontCache/{name}.ttf`) then
            delfile(`DrawingFontCache/{name}.ttf`)
        end
    end
end

function FontManager.list()
    for n, f in pairs(FontManager.Fonts) do
        print(n, "=", f)
    end
end

return FontManager
