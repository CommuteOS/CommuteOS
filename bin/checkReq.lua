if term.isColor() == nil or term.isColor() == false then
	term.clear()
	term.setCursorPos(1,1)
        print [[
This system does not meet one or more of the
minimum requirements needed to install this
product. 

System Requirements:
- 7 Golden Ingots
- 1 Redstone
- 1 Glass Pane

If you need a step-by-step guide on how to build
the computer, please put your computer back in
the box and return it to your nearest retailer
for a refund.]]

print("Press any key to shutdown...")
os.pullEvent("key")
os.shutdown()
end
