local tArgs = {...}

print("Beta version of printer client made by 1lann")

local modemPresent = false

for k,v in pairs(rs.getSides()) do
	if peripheral.getType(v) == "modem" then
		modemPresent = true
		rednet.open(v)
		break
	end
end

if not modemPresent then print("No modem found") error() end

local function copyTable(tableid)
	local newTable = {}
	for k,v in pairs(tableid) do
		newTable[k] = v
	end
	return newTable
end

local oldPeripheral = copyTable(peripheral)

if #tArgs ~= 2 then
	print("Usage: pconnect <id> <side>")
	error()
end
local printerID = tonumber(tArgs[1])
print("Connecting to printer...")
rednet.send(printerID, "printerConnect")
local startClock = os.clock()
success = false
while os.clock() - startClock < 0.2 do
	local id, msg = rednet.receive(0.2)
	if id == printerID and msg == "printerConnectSuccess" then
		success = true
		break
	end
end
if success then
	function peripheral.isPresent(side)
		if side == tArgs[2] then
			return true
		else
			return oldPeripheral.isPresent(side)
		end
	end
	function peripheral.getType(side)
		if side == tArgs[2] then
			return "printer"
		else
			return oldPeripheral.getType(side)
		end
	end
	function peripheral.getMethods(side)
		if side == tArgs[2] then
			return {"write","setCursorPos","getCursorPos","getPageSize","newPage","endPage","getInkLevel","setPageTitle","getPaperLevel"}
		else
			return oldPeripheral.getMethods(side)
		end
	end
	function peripheral.call(side, methodName, p1,p2,p3,p4,p5)
		if side == tArgs[2] then
			local tableData = {"callFunction", methodName,p1,p2,p3,p4,p5}
			rednet.send(printerID, textutils.serialize(tableData))
			local time = os.clock()
			local successAction = false
			while os.clock() - time < 1 do
				local rID, msg = rednet.receive(1)
				if rID == printerID then
					local toBeProcessed = textutils.unserialize(msg)
					if type(toBeProcessed) == "table" then
						return unpack(toBeProcessed)
					else
						return nil
					end
				end
			end	
			print("Warning: Printer connection lost!")
			return nil
		else
			return oldPeripheral.call(side, methodName, p1,p2,p3,p4,p5)
		end
	end
	print("Printer connected!")
else
	print("Could not connect to printer!")
end