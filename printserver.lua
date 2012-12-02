print("Beta version of printer hosting made by 1lann")

local modemPresent = false

for k,v in pairs(rs.getSides()) do
	if peripheral.getType(v) == "modem" then
		modemPresent = true
		rednet.open(v)
		break
	end
end

if not modemPresent then print("No modem found") error() end

local printerPresent = false
local printerMount = nil

for k,v in pairs(rs.getSides()) do
	if peripheral.getType(v) == "printer" then
		printerPresent = true
		printerMount = v
		break
	end
end

if not printerPresent then print("No printer found") error() end

local functionsAvail = {"write","setCursorPos","getCursorPos","getPageSize","newPage","endPage","getInkLevel","setPageTitle","getPaperLevel"}

local function possibleFunction(func)
	for k,v in pairs(functionsAvail) do
		if v == func then return true
		end
	end
	return false
end

print("Network printer: Ready")
print("ID: " .. os.getComputerID())
while true do
	local id,msg = rednet.receive()
	if msg == "printerConnect" then
		print("ID: ".. id .. " connected to the printer")
		rednet.send(id, "printerConnectSuccess")
	else
		local processing = textutils.unserialize(msg)
		if processing then
			if processing[1] == "callFunction" and #processing > 1 then
				if processing[2] == "setCursorPos" then
					local response = {peripheral.call(printerMount, "setCursorPos", processing[3], processing[4])}
					rednet.send(id, textutils.serialize(response))
					print("ID: " .. id .. " did " .. processing[2])
				else
					if possibleFunction(processing[2]) then
						local response = {peripheral.call(printerMount, processing[2], processing[3], processing[4], processing[5], processing[6], processing[7])}
						if #response == 0 then
							rednet.send(id, "nil")
							print("ID: " .. id .. " did " .. processing[2])
						else
							rednet.send(id, textutils.serialize(response))
							print("ID: " .. id .. " did " .. processing[2])
						end
					else
						print("ID: " .. id .. " did an unvalid action")
					end
				end
			end
		end
	end
end