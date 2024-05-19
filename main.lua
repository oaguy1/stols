-- Load libraries
fennel = require("lib.fennel")

-- Use fennel's tracebacks, makes things intelligeble
debug.traceback = fennel.traceback

-- Allow require to load fennel files
table.insert(package.loaders, function(filename)
   if love.filesystem.getInfo(filename) then
      return function(...)
         return fennel.eval(love.filesystem.read(filename), {env=_G, filename=filename}, ...), filename
      end
   end
end)

-- dump function for tables
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

-- Load main fennel file
require("game.fnl")
