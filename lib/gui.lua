-- Made by 'Human' for 'CommuteOS'
-- Feel free to modify and distribute as long as I receive credit

GUI = {}	-- Makes the 'GUI' table to house the functions

GUI.w, GUI.h = term.getSize()	-- Setup the 'w' and 'h' variables that hold the width and hidth of the screen

GUI.reset = function()	-- * Resets the screen *
	term.setBackgroundColor(colors.black)
	term.setTextColor(colors.white)
	term.clear()
	term.setCursorPos(1,1)
end

GUI.clear = function()	-- * Easily clears the screen and resets the cursor in one function calls *
	term.clear()
	term.setCursorPos(1,1)
end

GUI.cPrint = function(str, ypos)				  -- * Prints a string in the center of the screen *
	term.setCursorPos(GUI.w/2-#str/2, ypos)	-- 'str' is the string to print the screen
	write(str)															-- 'ypos' is the Y position to print the string
end

GUI.rPrint = function(str, ypos) 			-- * Prints a string to the right of the screen * 
	term.setCursorPos(GUI.w-#str, ypos)	-- 'str' is the string to print to the screen
	write(str)													-- 'ypos' is the Y position to print the string
end

GUI.pixel = function(color, x, y)	-- * Draws a pixel to the screen *
	term.setCursorPos(x, y)					-- 'color' is the color from the colors API
	term.setTextColor(color)				-- 'x' is the X position of the pixel
	write(" ")											-- 'y' is the Y position of the pixel
end

GUI.setColors = function(bg, txt) -- * Sets the background and text color *
	term.setBackgroundColor(bg)			-- 'bg' is the background color
	term.setTextColor(txt)					-- 'txt' is the text color
end

GUI.line = function(color, startX, endX, y)	-- * Draws a line to the screen of a color *
	term.setBackgroundColor(color)						-- 'color' is the color from the colors API
	term.setCursorPos(startX, y)							-- 'startX' is the start of the line
	write(string.rep(" ", endX-startX))				-- 'endX' is the end of the line
end																					-- 'y' is the Y position of the line

GUI.label = function(bgColor, txtColor, str, x, y)	-- * Adds a label to the screen *
	GUI.setColors(bgColor, txtColor)								  -- 'bgColor' is the background color
	term.setCursorPos(x ,y)													  -- 'txtColor' is the text color
	write(str)																				-- 'str' is the string that is going to be written to the screen
end																									-- 'x' and 'y' are the X and Y position of the label

--[[

	menu = {
			func = ,									-- The function that is called when the button is pressed
			text = "",								-- The text that is displayed
			button = 1,								-- The type of button, either 1 for left or 2 for right
			startX = ,								-- A int to determin the start of the X axis of the button
			endX = ,									-- A int to determin the end of the X axis of the button
			startY = ,								-- A int to determin the start of the Y axis of the button
			endY = ,									-- A int to determin the end of the Y axis of the button
			textColor = colors. ,			-- A colors API value
			bgColor = colors.					-- A colors API value 
	}

]]--


GUI.button = function(menu)	-- * Adds a clickable button to the screen *
	while true do							-- 'menu' is the table that contains the data for the button
		GUI.reset()
		GUI.setColors(menu.bgColor, menu.textColor)
		term.setCursorPos(menu.startX, menu.startY)
		write(menu.text)
		event, button, x, y = os.pullEvent("mouse_click")
		if button == menu.button then
			if x >= menu.startX and x <= menu.endX and y >= menu.startY and y <= menu.endX then
				menu.func()
				break
			end
		end
	end
end																					

--[[

	menu = {
		["button"] = {							-- * Each button is a table inside a table *
			func = ,									-- The function that is called when the button is pressed
			text = "",								-- The text that is displayed
			button = 1,								-- The type of button, either 1 for left or 2 for right
			visible = true,						-- Weather the button is visable or not
			stop = false, 						-- Weather or not to stop
			startX = ,								-- A int to determin the start of the X axis of the button
			endX = ,									-- A int to determin the end of the X axis of the button
			startY = ,								-- A int to determin the start of the Y axis of the button
			endY = ,									-- A int to determin the end of the Y axis of the button
			textColor = colors. ,			-- A colors API value
			bgColor = colors.					-- A colors API value 
		}
	}

]]--

GUI.mouseMenu = function(menu)	-- * Makes a menu that is clickable with the mouse (For advanced computers) *
	while true do									-- 'menu' is the table that contains the buttons
		GUI.reset()									
		for k,v in pairs(menu) do
			if v.visible then 
				term.setCursorPos(v.startX, v.startY)
				term.setBackgroundColor(v.bgColor)
				term.setTextColor(v.textColor)
				write(v.text)
			end
			event, button, x, y = os.pullEvent("mouse_click")
			for k,v in pairs(menu) do
				if v.visible then
					if v.button == button then
						if x >= v.startX and x <= v.endX and y >= v.endX and y <= v.endX then
							v.func()
							if v.stop then
								makeStop = true
							end
						end
					end
				end
			end
		end
		if makeStop then
			break
		end
	end
end