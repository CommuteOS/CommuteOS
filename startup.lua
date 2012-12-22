-- CommuteOS startup file

-- Load libs

for k,v in pairs(fs.list("/lib")) do
	dofile(v)
end

-- Start login

dofile("/boot/loginGui.lua")