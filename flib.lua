flib = {}

function flib_exists(path)
   if love then
      return love.filesystem.exists(path)
   elseif fs then
      return fs.exists(path)
   else
      local file = io.open(path, "r")

      if file ~= nil then
         file:close()
         return true
      end

      return false
   end
end

--[[
function flib_exists(path)
   if love then
      return love.filesystem.exists(path)
   else
      print "user pls"
      os.exit()
   end
end
]]

function flib_getTable(path)
   if flib_exists(path) then
      local file = io.open(path, "r")
      local lines = {}
      local i = 1
      local line = file:read("*l")
      while line ~= nil do
         lines[i] = line
         line = file:read("*l")
         i = i + 1
      end
      file:close()
      return lines
   end
   return {}
end

function flib_getLine(path, n)
   if flib_exists(path) then
      local lines = flib_getTable(path)
      return lines[n]
   end
   return ""
end

function flib_getText(path)
   if flib_exists(path) then
      local file = assert(io.open(path, "r"))
      return file:read("*a")
   end
   return ""
end

function flib_fappend(path, text)
   local file = assert(io.open(path, "a"))
   file:write(text.."\n")
   file:close()
end 

function flib_fwrite(path, text)
   local file = assert(io.open(path, "w"))
   file:write(text)
   file:close()
end

function flib_fwriteAtStart(path, text)
   local _text = flib_getText(path)
   flib_fwrite(path, text.."\n".._text)
end

function flib_fwriteFromTable(path, t)
   local text = ""
   for _, line in pairs(t) do
      text = text..line.."\n"
   end
   flib_fwrite(path, text)
end

function flib_fappendFromTable(path, t)
   local text = ""
   for _, line in pairs(t) do
      text = text..line.."\n"
   end
   flib_fappend(path, text)
end 

function flib_fwriteAtStartFromTable(path, t)
   local text = ""
   for _, line in pairs(t) do
      text = text..line.."\n"
   end
   flib_fwriteAtStart(path, text)
end

function flib_fwriteFromLine(path, n, text)
   if flib_exists(path) then
      local lines = flib_getTable(path)
      local file = io.open(path, "w")
      local count = 0

      for i = 1, n do
         file:write(lines[i].."\n")
         count = count + 1
      end

      file:write(text.."\n")

      for i = n + 1, #lines + count do
         if lines[i] ~= nil then
            file:write(lines[i].."\n")
         end
      end

      file:close()
   end
end

function flib_fwriteFromLineFromTable(path, n, _lines)
   if flib_exists(path) then
      local lines = flib_getTable(path)
      local file = io.open(path, "w")
      local count = 0

      for i = 1, n do
         file:write(lines[i].."\n")
         count = count + 1
      end

      for _, line in pairs(_lines) do
         file:write(tostring(line).."\n")
      end

      for i = n + 1, #lines + count do
         if lines[i] ~= nil then
            file:write(lines[i].."\n")
         end
      end

      file:close()
   end
end

function flib_replaceLine(path, n, text)
   local lines = flib_getTable(path)
   lines[n] = text
   flib_fwriteFromTable(path, lines)
end

function flib_getName(path)
   if flib_exists(path) then
      local lastSlashPos = 1
      for i = 1, path:len() do
         if path:sub(i, i) == "/" then
            lastSlashPos = i
         end
      end

      return path:sub(lastSlashPos + 1)
   end
   return ""
end

function flib_getPath(path)
   if flib_exists(path) then
      local lastSlashPos = 1
      for i = 1, path:len() do
         if path:sub(i, i) == "/" then
            lastSlashPos = i
         end
      end

      return path:sub(1, lastSlashPos)
   end
   return ""
end

function flib_fremove(path)
   if os.remove then
      os.remove(path)
   else
      fs.remove(path)
   end
end

function flib_getOS()
   return (os.getenv("HOME") == nil and "windows" or "unix")
end

function flib_getFiles(directory)
   if fs ~= nil then
      return fs.list(directory)
   else
      local i, t, popen = 0, {}, io.popen

      for filename in popen((flib_getOS() == "unix" and ('ls -a "' .. directory .. '"') or ('dir "' .. directory .. '" /b /ad'))):lines() do
         i = i + 1
         t[i] = filename
      end

      return t
   end
end

function flib_getWindowsPath(path)
   return path:gsub("/", "\\")
end

function flib_makeDir(path)
   if fs then
      fs.makeDir(path)
   else
      os.execute("mkdir " .. (flib_getOS() == "windows" and flib_getWindowsPath(path) or path))
   end
end

--[[
function flib_addSysVar(name, value)
   if fs then
      error("Function 'flib_addSysVar()' is not supported in ComputerCraft")
   else
      os.execute((flib_getOS() == "windows" and "set" or "export") .. " " .. name .. "=\"" .. tostring(value) .. "\"")
      print((flib_getOS() == "windows" and "set" or "export") .. " " .. name .. "=\"" .. tostring(value) .. "\"")
   end
end
]]

function flib_isDir(path)
   if fs then
      return fs.isDir(path)
   else
      local x, err = f:read(1)

      return err == "Is a directory"
   end
end

storage = {}

function readTable(t)
   local s = "{"

   for k, v in pairs(t) do
      if type(k) == "string" then
         s = s .. tostring(k) .. " = "
      end

      if type(v) == "string" then
         s = s .. "\"" .. tostring(v) .. "\"" .. ", " 
      elseif type(v) == "number" or type(v) == "boolean" then
         s = s .. tostring(v) .. ", "
      elseif type(v) == "table" then
         s = s .. readTable(v) .. ", "
      end
   end

   s = s .. "\"end\"}"
   return s
end

function save(path, value)
   if type(value) == "number" or type(value) == "boolean" then
      local s = tostring(value)
      flib_fwrite(path, "return " .. s)
   elseif type(value) == "string" then
      local s = tostring(value)
      s = "\"" .. s .. "\""
      flib_fwrite(path, "return " .. s)
   elseif type(value) == "table" then
      local s = readTable(value)
      flib_fwrite(path, "return " .. s)
   end
end

function load(path)
   if not flib_exists(path) then
      error "Bad argument #1 to 'storage.load()': file does not exist"
   end

   return require(string.sub(path, 1, #path - 4))
end