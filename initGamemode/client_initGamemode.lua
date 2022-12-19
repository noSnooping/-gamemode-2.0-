addEvent("join:gamemode", true)
addEvent("quit:gamemode", true)

addEventHandler("onClientResourceStop",resourceRoot,function()
	triggerEvent("quit:gamemode",localPlayer)
end)

---addEvent("checkPlayerCharacterLogged", true)
addEventHandler("onClientResourceStart",resourceRoot,function()
	triggerEvent("join:gamemode",localPlayer)
end)

