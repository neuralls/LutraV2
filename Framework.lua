--[[ Framework.lua
  Main base of the repository.
]]

local filename = "Framework"

local Import = ({...})[1] or nil
if typeof(Import) ~= "function" then
  error("Import not provided to "..filename)
end
