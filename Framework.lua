local filename = "Framework"

local Import = ({...})[1] or nil
if not Import then error("Import not provided to "..filename) end

Import("Test")
