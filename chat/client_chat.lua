--[[-----------------------------------------------
----script feito por Lucas Damaceno(anony)
----em 2020. você pode usá-lo e editá-lo apenas o créditos são meus!
----youtube:https://www.youtube.com/channel/UCf7N0XUAHmOLpRO4MfXTHaQ?view_as=subscriber
--]]-----------------------------------------------
local cpl = {}

addEvent("join:gamemode", true)
addEvent("quit:gamemode", true)

cpl.init_Gamemode = function()
	triggerServerEvent("join:gamemode",resourceRoot)
end

cpl.init_Gamemode_reset = function(bool)
	if not bool then triggerServerEvent("quit:gamemode",resourceRoot) end
end

addEventHandler("join:gamemode", localPlayer, function()
	cpl.init_Gamemode()
end)

addEventHandler("quit:gamemode", localPlayer, function()
	cpl.init_Gamemode_reset()
end)

addEventHandler("onResourceStop",resourceRoot,function() 
	cpl.init_Gamemode_reset(true)
end)