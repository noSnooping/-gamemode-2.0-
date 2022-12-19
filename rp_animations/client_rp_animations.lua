--[[-----------------------------------------------
----script feito por Addlibs copom feito por Lucas Damaceno(anony)
----em 2020. você pode usá-lo e editá-lo apenas o créditos são meus!
----youtube:https://www.youtube.com/channel/UCf7N0XUAHmOLpRO4MfXTHaQ?view_as=subscriber
--]]-----------------------------------------------


local cpl = {}

function cpl.moveHead()
	local sX, sY, sZ = getElementPosition(localPlayer)
	local elements = getElementsByType("player",root,true)
	local nextElement = function(_index) local index=0 return function() index=index+1 if _index[index] then return index, _index[index] end end end
	for _,client in nextElement(elements) do
		local rX, rY, rZ = getElementPosition(client)
		local distance = getDistanceBetweenPoints3D(sX, sY, sZ, rX, rY, rZ)
		if distance <= 20 then
			if getElementHealth(client) >= 1 then
			local block, animation = getPedAnimation(client)
			if not block then
				local width, height = guiGetScreenSize()
				local lx, ly, lz = getWorldFromScreenPosition(width/2, height/2, 10)
				setPedLookAt(client, lx, ly, lz)
				end
			end	
		end 
	end
end

function cpl.cancelDano()
	if (getPedWeapon(localPlayer) == 28 or getPedWeapon(getLocalPlayer()) == 0) then 
		cancelEvent() -- Cancela o dano da arma pra caso de alguma forma o jogador consiga bugar a arma ele não matar ninguém.
    end
end

function cpl.autoLevante(key,keyState)
	if keyState == "down" then
		setPedControlState(localPlayer, "crouch", true)
		setTimer(function()
		setPedControlState(localPlayer, "crouch", false)
		end,100,1)
	end
end

function cpl.disableMinigunOnSwitch()
	if getPedWeapon(getLocalPlayer()) == 28 or getPedWeapon(getLocalPlayer()) == 0 then 
		--toggleControl("fire", false) 
		--setPlayerHudComponentVisible("crosshair", false) 
	else
		--toggleControl("fire", true) 
		--setPlayerHudComponentVisible("crosshair", true) 
	end
end

function cpl.walk()
    setPedControlState(localPlayer, "walk", true)
    setPedControlState(localPlayer, "sprint", false)
end

function cpl.splint()
    setPedControlState(localPlayer, "walk", false)
    setPedControlState(localPlayer, "sprint", true)
end

function cpl.loadUziInvisible()
	local txd = engineLoadTXD("files/invisible.txd", 352)
	engineImportTXD(txd, 352 )
	local dff = engineLoadDFF("files/invisible.dff", 352)
	engineReplaceModel(dff, 352 )
end

function cpl.unloadUziInvisible()
	engineRestoreModel(352)
end

local blockedTasks =
{
	"TASK_SIMPLE_IN_AIR", -- We're falling or in a jump.
	"TASK_SIMPLE_JUMP", -- We're beginning a jump
	"TASK_SIMPLE_LAND", -- We're landing from a jump
	"TASK_SIMPLE_GO_TO_POINT", -- In MTA, this is the player probably walking to a car to enter it
	"TASK_SIMPLE_NAMED_ANIM", -- We're performing a setPedAnimation
	"TASK_SIMPLE_CAR_OPEN_DOOR_FROM_OUTSIDE", -- Opening a car door
	"TASK_SIMPLE_CAR_GET_IN", -- Entering a car
	"TASK_SIMPLE_CLIMB", -- We're climbing or holding on to something
	"TASK_SIMPLE_SWIM",
	"TASK_SIMPLE_HIT_HEAD", -- When we try to jump but something hits us on the head
	"TASK_SIMPLE_FALL", -- We fell
	"TASK_SIMPLE_GET_UP" -- We're getting up from a fall
}

local function reloadWeapon()
	local task = getPedSimplestTask(localPlayer)
	local elements = blockedTasks
	local nextElement = function(_index) local index=0 return function() index=index+1 if _index[index] then return index, _index[index] end end end
	for _,client in nextElement(elements) do
		if (task == badTask) then
			return
		end
	end
	triggerServerEvent("relWep", localPlayer)
end

function comm()
	setTimer(reloadWeapon, 50, 1)
end

cpl.init_Gamemode = function()
	triggerServerEvent("join:gamemode",resourceRoot)
	
	cpl.disableMinigunOnSwitch()
	addEventHandler("onClientPreRender", root, cpl.moveHead)
	addEventHandler("onClientPlayerWeaponFire",localPlayer,cpl.cancelDano)
	addEventHandler("onClientPlayerWeaponSwitch",localPlayer, cpl.disableMinigunOnSwitch)
	bindKey("w","down", cpl.walk)
	bindKey("space","up", cpl.walk)
	bindKey("space","down", cpl.splint)
	addCommandHandler("Reload weapon", comm) 
	bindKey("r", "down", "Reload weapon")
	bindKey("c", "both", cpl.autoLevante)
	cpl.loadUziInvisible()
end

cpl.init_Gamemode_reset = function(bool)
	if not bool then triggerServerEvent("quit:gamemode",resourceRoot) end
	
	removeEventHandler("onClientPreRender", root, cpl.moveHead)
	removeEventHandler("onClientPlayerWeaponFire",localPlayer,cpl.cancelDano)
	removeEventHandler("onClientPlayerWeaponSwitch",localPlayer, cpl.disableMinigunOnSwitch)
	--toggleControl("fire", true) 
	--setPlayerHudComponentVisible("crosshair", true) 
	unbindKey("w","down", cpl.walk)
	unbindKey("space","up", cpl.walk)
	unbindKey("space","down", cpl.splint)
	removeCommandHandler("Reload weapon", comm) 
	unbindKey("r", "down", "Reload weapon")
	unbindKey("c", "both", cpl.autoLevante)
	cpl.unloadUziInvisible()
end

addEvent("join:gamemode", true)
addEvent("quit:gamemode", true)

addEventHandler("join:gamemode", localPlayer, function()
	cpl.init_Gamemode()
end)

addEventHandler("quit:gamemode", localPlayer, function()
	cpl.init_Gamemode_reset()
end)

addEventHandler("onClientResourceStop",resourceRoot,function()
	cpl.init_Gamemode_reset(true)
end)
