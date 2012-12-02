local args = {...}

if #args ~= 2 then
  error("Usage: "..shell.getRunningProgram.." <Github File Game> <Save To>")
end

--Config

local user = "CommuteOS"
local repo = "CommuteOS"
local branch = "master"

local url = http.get("https://raw.github.com/"..user.."/"..repo.."/"..branch.."/"..args[1])
f = fs.open(args[2], "w")
f.write(url.readAll())
f.close()
print("File saved!")