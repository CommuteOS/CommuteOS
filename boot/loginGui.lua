term.clear()
term.setCursorPos(1,1)
GUI.line(colors.red, 1, GUI.w, 1)
GUI.line(colors.red, 1, GUI.w, GUI.h)

for i = 2, GUI.h-1 do
	GUI.pixel(colors.red, 1, i)
end

for i = 2, GUI.h-1 do
	GUI.pixel(colors.red, GUI.w, i)
end

GUI.setColors(colors.black, colors.red)
GUI.cPrint("CommuteOS Login", 3)
