--[[ FontManager.lua
    Adds functionality to load fonts with .font metadata.
]]

local HttpService = cloneref(game:GetService("HttpService"))

if not isfolder("DrawingFontCache") then
    makefolder("DrawingFontCache")
end

local FontManager = { Fonts = {} }

FontManager.create = function(FontName, FontSource)
    -- two variables like Register_Font
    local FontPath = "DrawingFontCache/" .. FontName .. ".ttf"
    local FontMeta = "DrawingFontCache/" .. FontName .. ".font"

    -- if source is a URL
    if string.match(FontSource, "https") then
        FontSource = request({ Url = FontSource .. FontName }).Body
    end

    -- write .ttf if it doesn't exist
    if not isfile(FontPath) then
        writefile(FontPath, crypt.base64.decode(FontSource))
    end

    -- rebuild .font metadata
    if isfile(FontMeta) then
        delfile(FontMeta)
    end

    local Data = {
        name = FontName,
        faces = {
            {
                name = "Regular",
                weight = 100,
                style = "normal",
                assetId = getcustomasset(FontPath),
            },
        },
    }

    writefile(FontMeta, HttpService:JSONEncode(Data))

    -- create font object
    local FontObject = Font.new(getcustomasset(FontMeta), Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    FontManager.Fonts[FontName] = FontObject

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
