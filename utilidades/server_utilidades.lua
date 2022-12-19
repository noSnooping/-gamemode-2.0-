--[[-----------------------------------------------
----script feito por Lucas Damaceno(anony)
----em 2020. você pode usá-lo e editá-lo apenas o créditos são meus!
----youtube:https://www.youtube.com/channel/UCf7N0XUAHmOLpRO4MfXTHaQ?view_as=subscriber
--]]-----------------------------------------------

local init_Gamemode = function()
	setGameType("discord.com/rpconexaoph")
	setMapName("discord.com/rpconexaoph")
	setFPSLimit(75)
end
init_Gamemode()

local init_Gamemode_stop = function()
	setGameType("MTA:SA")
	setMapName("MTA:SA")
end

local cpl = {}

addEvent("join:gamemode", true)
addEvent("quit:gamemode", true)

cpl.init_Gamemode = function(client)
	setPlayerNametagShowing(client, false)
    setPlayerHudComponentVisible(client,"all", false)
	setPlayerHudComponentVisible(client,"crosshair",true)
	setPlayerHudComponentVisible(client,"radar",false)
end

cpl.init_Gamemode_reset = function(client)
	setPlayerNametagShowing(client, true)
    setPlayerHudComponentVisible(client,"all", true)
end

addEventHandler("join:gamemode", resourceRoot, function()
	cpl.init_Gamemode(client)
end)

addEventHandler("quit:gamemode", resourceRoot, function()
	cpl.init_Gamemode_reset(client)
end)

addEventHandler("onResourceStop",resourceRoot,function() 
	init_Gamemode_stop()
	local elements = getElementsByType("player")
	local nextElement = function(_index) local index=0 return function() index=index+1 if _index[index] then return index, _index[index] end end end
	for _,client in nextElement(elements) do
		cpl.init_Gamemode_reset(client)
	end
end)

