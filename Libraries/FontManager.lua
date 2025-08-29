--[[ FontManager.lua
    Adds functionality to load fonts from base64 data.
]]

local Framework = ({...})[1] or nil
if typeof(Framework) ~= "table" then error("framework not added") end

if Framework.Modules.FontManager then
    error("FontManager already loaded")
end

local FontManager = { Fonts = {} }
Framework.Modules.FontManager = FontManager

-- Grab dependencies
local services = Framework.Services

-- code

if not isfolder("DrawingFontCache") then
    makefolder("DrawingFontCache")
end

FontManager.create = function(FontName, FontSource)
    if string.match(FontSource,"https") then
        FontSource = request({Url = FontSource .. FontName}).Body
    end

    local FontObject

    local TempPath = services["HttpService"]:GenerateGUID(false)
    if not isfile(FontSource) then
        writefile("DrawingFontCache/" .. FontName .. ".ttf", crypt.base64.decode(FontSource))
        FontSource = "DrawingFontCache/" .. FontName .. ".ttf"
    end

    writefile(TempPath, services["HttpService"]:JSONEncode({
        ["name"] = FontName,
        ["faces"] = {
            {
                ["name"] = "Regular",
                ["weight"] = 100,
                ["style"] = "normal",
                ["assetId"] = getcustomasset(FontSource)
            }
        }
    }))

    FontObject = Font.new(getcustomasset(TempPath), Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    FontManager.Fonts[FontName] = FontObject
    delfile(TempPath)

    return FontObject
end

FontManager.unload = function()
    FontManager = nil
    Framework.Modules.FontManager = nil
end

return FontManager
