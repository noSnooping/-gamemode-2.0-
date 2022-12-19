--[[-----------------------------------------------
----script feito por Addlibs copom feito por Lucas Damaceno(anony)
----em 2020. você pode usá-lo e editá-lo apenas o créditos são meus!
----youtube:https://www.youtube.com/channel/UCf7N0XUAHmOLpRO4MfXTHaQ?view_as=subscriber
--]]-----------------------------------------------
local c_init_Gamemode = function()
	outputDebugString("Gamemode vision 0.1 © copyright anony 2021 client",0,200,200,200)
end
c_init_Gamemode()

local cpl = {}

cpl.init_Gamemode = function()
	triggerServerEvent("join:gamemode",resourceRoot)
	--setBlurLevel(0)
	--setFPSLimit(60)
	setWorldSpecialPropertyEnabled("extraairresistance", false)
	bindKey("m","down",cpl.showMouse)
	outputDebugString("Gamemode vision 0.1 © copyright anony 2021 client",0,200,200,200)
	addEventHandler('onClientPlayerRadioSwitch', localPlayer, function() cancelEvent() end) 
end

cpl.init_Gamemode_reset = function(bool)
	if not bool then triggerServerEvent("quit:gamemode",resourceRoot) end
	--setBlurLevel(36)
	--setFPSLimit(36)
	setWorldSpecialPropertyEnabled("extraairresistance", true)
	if isCursorShowing() then showCursor(false) end
	unbindKey("m","down",cpl.showMouse)
	removeEventHandler('onClientPlayerRadioSwitch', localPlayer, function() cancelEvent() end) 
end

function cpl.showMouse()
	showCursor(not isCursorShowing())
end

addEvent("join:gamemode", true)
addEvent("quit:gamemode", true)

addEventHandler("join:gamemode", localPlayer, function()
	cpl.init_Gamemode()
end)

addEventHandler("quit:gamemode", localPlayer, function()
	cpl.init_Gamemode_reset()
end)

addEventHandler("onClientResourceStop",getResourceRootElement(),function()
	cpl.init_Gamemode_reset(true)
end)
