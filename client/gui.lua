Menu = {}
Menu.GUI = {}
Menu.buttonCount = 0
Menu.selection = 0
Menu.hidden = true
MenuTitle = "Menu"

function Menu.addButton(name, func,args,extra,damages,bodydamages,fuel)

	local yoffset = 0.25
	local xmin = 0.0
	local xmax = 0.15
	local ymin = 0.03
	local ymax = 0.03
	Menu.GUI[Menu.buttonCount+1] = {}
	if extra ~= nil then
		Menu.GUI[Menu.buttonCount+1]["extra"] = extra
	end
	if damages ~= nil then
		Menu.GUI[Menu.buttonCount+1]["damages"] = damages
		Menu.GUI[Menu.buttonCount+1]["bodydamages"] = bodydamages
		Menu.GUI[Menu.buttonCount+1]["fuel"] = fuel
	end

	Menu.GUI[Menu.buttonCount+1]["name"] = name
	Menu.GUI[Menu.buttonCount+1]["func"] = func
	Menu.GUI[Menu.buttonCount+1]["args"] = args
	Menu.GUI[Menu.buttonCount+1]["active"] = false
	Menu.GUI[Menu.buttonCount+1]["xmin"] = xmin
	Menu.GUI[Menu.buttonCount+1]["ymin"] = ymin * (Menu.buttonCount + 0.01) +yoffset
	Menu.GUI[Menu.buttonCount+1]["xmax"] = xmax
	Menu.GUI[Menu.buttonCount+1]["ymax"] = ymax
	Menu.buttonCount = Menu.buttonCount+1
end


function Menu.updateSelection()
	if IsControlJustPressed(1, 173) then -- Down Arrow
		if(Menu.selection < Menu.buttonCount -1 ) then
			Menu.selection = Menu.selection +1
		else
			Menu.selection = 0
		end
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	elseif IsControlJustPressed(1, 27) then -- Up Arrow
		if(Menu.selection > 0)then
			Menu.selection = Menu.selection -1
		else
			Menu.selection = Menu.buttonCount-1
		end
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	elseif IsControlJustPressed(1, 215) then
		MenuCallFunction(Menu.GUI[Menu.selection +1]["func"], Menu.GUI[Menu.selection +1]["args"])
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	end
	local iterator = 0
	for id, settings in ipairs(Menu.GUI) do
		Menu.GUI[id]["active"] = false
		if(iterator == Menu.selection ) then
			Menu.GUI[iterator +1]["active"] = true
		end
		iterator = iterator +1
	end
end

function Menu.renderGUI()
	if not Menu.hidden then
		Menu.renderButtons()
		Menu.updateSelection()
	end
end

function Menu.renderBox(xMin,xMax,yMin,yMax,color1,color2,color3,color4)
	DrawRect(0.7, yMin,0.15, yMax-0.002, color1, color2, color3, color4);
end

function Menu.renderButtons()

	for id, settings in pairs(Menu.GUI) do

		boxColor = {38,38,38,199}
		local movetext = 0.0
		if(settings["extra"] == "Garage") then
			boxColor = {44,100,44,200}
		elseif (settings["extra"] == "Impounded") then
			boxColor = {77, 8, 8,155}
		end

		if(settings["active"]) then
			boxColor = {31, 116, 207,155}
		end


		if settings["extra"] ~= nil then

			SetTextFont(4)

			SetTextScale(0.34, 0.34)
			SetTextColour(255, 255, 255, 255)
			SetTextEntry("STRING")
			AddTextComponentString(settings["name"])
			DrawText(0.63, (settings["ymin"] - 0.012 ))

			SetTextFont(4)
			SetTextScale(0.26, 0.26)
			SetTextColour(255, 255, 255, 255)
			SetTextEntry("STRING")
			AddTextComponentString(settings["extra"])
			DrawText(0.730 + movetext, (settings["ymin"] - 0.011 ))

			SetTextFont(4)
			SetTextScale(0.28, 0.28)
			SetTextColour(11, 11, 11, 255)
			SetTextEntry("STRING")
			AddTextComponentString(settings["damages"])
			DrawText(0.778, (settings["ymin"] - 0.012 ))

			SetTextFont(4)
			SetTextScale(0.28, 0.28)
			SetTextColour(11, 11, 11, 255)
			SetTextEntry("STRING")
			AddTextComponentString(settings["bodydamages"])
			DrawText(0.815, (settings["ymin"] - 0.012 ))

			SetTextFont(4)
			SetTextScale(0.28, 0.28)
			SetTextColour(11, 11, 11, 255)
			SetTextEntry("STRING")
			AddTextComponentString(settings["fuel"])
			DrawText(0.854, (settings["ymin"] - 0.012 ))

			DrawRect(0.832, settings["ymin"], 0.11, settings["ymax"]-0.002, 255,255,255,199)
		else
			SetTextFont(4)
			SetTextScale(0.31, 0.31)
			SetTextColour(255, 255, 255, 255)
			SetTextCentre(true)
			SetTextEntry("STRING")
			AddTextComponentString(settings["name"])
			DrawText(0.7, (settings["ymin"] - 0.012 ))

		end

		Menu.renderBox(settings["xmin"] ,settings["xmax"], settings["ymin"], settings["ymax"],boxColor[1],boxColor[2],boxColor[3],boxColor[4])

	 end
end

--------------------------------------------------------------------------------------------------------------------

function ClearMenu()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

function MenuCallFunction(fnc, arg)
	_G[fnc](arg)
end