local Framework = ({...})[1] or nil
if Framework == nil then print("framework not added") end

--[[
local HttpService = cloneref(game:GetService("HttpService"));

if not isfolder("DrawingFontCache") then
    makefolder("DrawingFontCache")
end

local fontmanager = { Fonts = {} }

function fontmanager.create(FontName, FontSource)
    if string.match(FontSource,"https") then
        FontSource = request({Url = FontSource .. FontName}).Body
    end

    local FontObject

    local TempPath = HttpService:GenerateGUID(false)
    if not isfile(FontSource) then
        writefile(`DrawingFontCache/{FontName}.ttf`, crypt.base64.decode(FontSource))
        FontSource = `DrawingFontCache/{FontName}.ttf`
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
    fontmanager.Fonts[FontName] = FontObject
    delfile(TempPath)

    return FontObject
end

function fontmanager.list()
    for name,font in pairs(fontmanager.Fonts) do
        print(name, "=", font.Object)
    end
end

return fontmanager
]]
