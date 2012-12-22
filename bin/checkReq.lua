if term.isColor() == nil or term.isColor() == false then
	term.clear()
	term.setCursorPos(1,1)
	term.setTextColor(colors.red)
	print("To use CommuteOS you must have a advanced computer.")
	term.setTextColor(colors.white)
	term.setCursorPos(1,3)
	print("Crafting a advanced computer: ")
	print("III")
	print("IRI")
	print("IGI")
	print("I = gold ingot, R = redstone and G = glass pane")
end

print("Press any key to shutdown...")
os.pullEvent("key")
os.shutdown()