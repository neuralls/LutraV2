--[[ FontManager.lua
    Adds functionality to load fonts with .font metadata.
]]

local HttpService = cloneref(game:GetService("HttpService"))

if not isfolder("DrawingFontCache") then
    makefolder("DrawingFontCache")
end

local FontManager = { Fonts = {} }

FontManager.create = function(FontName, FontSource)
    local FontPath = "DrawingFontCache/" .. FontName .. ".ttf"
    local FontMeta = "DrawingFontCache/" .. FontName .. ".font"
    
    if string.match(FontSource, "^https") then
        FontSource = game:HttpGet(FontSource)
    end

    if not isfile(FontPath) then
        writefile(FontPath, crypt.base64.decode(FontSource))
    end

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
