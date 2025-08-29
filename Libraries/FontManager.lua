--[[ FontManager.lua
    Adds functionality to load fonts from base64 data.
]]

local HttpService = cloneref(game:GetService("HttpService"))

local FontManager = { Fonts = {} }

if not isfolder("DrawingFontCache") then
    makefolder("DrawingFontCache")
end

FontManager.create = function(FontName, FontSource)
    if string.match(FontSource, "https") then
        FontSource = request({ Url = FontSource .. FontName }).Body
    end

    local FontObject
    local TempPath = HttpService:GenerateGUID(false)

    if not isfile(FontSource) then
        local FontPath = "DrawingFontCache/" .. FontName .. ".ttf"
        writefile(FontPath, crypt.base64.decode(FontSource))
        FontSource = FontPath
    end

    writefile(TempPath, HttpService:JSONEncode({
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

FontManager.list = function()
    for name, font in pairs(FontManager.Fonts) do
        print(name, "=", font)
    end
end

FontManager.unload = function()
    FontManager = nil
end

return FontManager
