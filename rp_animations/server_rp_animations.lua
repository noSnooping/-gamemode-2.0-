--[[-----------------------------------------------
----script feito por Lucas Damaceno(anony)
----em 2020. você pode usá-lo e editá-lo apenas o créditos são meus!
----youtube:https://www.youtube.com/channel/UCf7N0XUAHmOLpRO4MfXTHaQ?view_as=subscriber
--]]-----------------------------------------------

local cpl = {}
cpl.v = {}

addEvent("join:gamemode", true)
addEvent("quit:gamemode", true)
addEvent("relWep", true)

function playerOnGround(player)
	local velX, velY, velZ = getElementVelocity (player)  
	if (not isPedOnGround(player) and velZ ~= 0) then
		return true
	end
	return false
end

function cpl.liftingHands(client,key,keyState)
	if getPedOccupiedVehicle(client) then return end
	if playerOnGround(client) then return end
    local player = client
	--if isTimer(cpl.v[client].no_lag1) and cpl.v[client].no_lag2 and isTimer(cpl.v[client].no_lag3) and cpl.v[client].no_lag4 then return end
	if keyState == "down" then
		setPedAnimation(player, "GHANDS", "gsign1", 0, true, false, false)
		cpl.v[client].no_lag1 = setTimer(function()
			setPedAnimationProgress(player, "gsign1", 1.16)
		end,100,1)
		cpl.v[client].no_lag2 = setTimer(function()
			setPedAnimationSpeed(player, "gsign1", 0)
		end,1500,1)		
		setElementData(player, "handsup", true)	
	else
		cpl.v[client].no_lag3 = setTimer(function()
			setPedAnimation(player, "GHANDS", "gsign1", 5000, false, false, false)
		end,100,1)
		cpl.v[client].no_lag4 = setTimer(function()
			setPedAnimation(player, nil)
		end,250,1)	
		setElementData(player, "handsup", false)
	end
end

function cpl.plsStop(client)
	if getPedOccupiedVehicle(client) then return end
	if playerOnGround(client) then return end	
	setPedAnimation(client, "POLICE", "CopTraf_Stop", -1, false, false, true, false)
end

function cpl.bind2(client,key,keyState) 
	if getPedOccupiedVehicle(client) then return end
	if playerOnGround(client) then return end
	
	
	if keyState == "down" then
		if getPedWeapon(client) == 0 then 
			setControlState(client, "fire",false)
			
			if isTimer(cpl.v[client].timerToAp) then killTimer(cpl.v[client].timerToAp) end 
			cpl.v[client].timerToAp = setTimer(function() 
				toggleControl(client,"action", false) 
				toggleControl(client,"fire", false) 
				setPlayerHudComponentVisible(client,"crosshair", false) 
				giveWeapon(client, 28, 1, true) 
			end,500,1)
		end	
	else
		if isTimer(cpl.v[client].timerToAp) then killTimer(cpl.v[client].timerToAp) end 
		if getPedWeapon(client) == 28 then 
			setControlState(client, "fire",false)
			toggleControl(client,"action", true) 
			toggleControl(client,"fire", true) 
			takeWeapon(client, 28)
			setPlayerHudComponentVisible(client,"crosshair", true) 
			print("taked weapon")
		end	
	end
end

function cpl.bind3(client,key,keyState) 
	setControlState(client, "fire",false)
	setControlState(client, "action",false)
	takeWeapon(client, 28)
end

function cpl.reloadWeapon()
	reloadPedWeapon(client)
end
 
cpl.init_Gamemode = function(client)
	bindKey(client, "x", "both", cpl.liftingHands)
	bindKey(client, "v", "both", cpl.plsStop)
	bindKey(client,"mouse2", "both", cpl.bind2)
	bindKey(client,"tab", "both", cpl.bind3)
	addEventHandler("relWep", client, cpl.reloadWeapon)
	cpl.v[client] = {}
	cpl.v[client].no_lag = false
	cpl.v[client].timerToAp = false
end

cpl.init_Gamemode_reset = function(client)
	toggleControl(client,"action", false) 
	toggleControl(client,"fire", true) 
	setPlayerHudComponentVisible(client,"crosshair", true) 
	unbindKey(client, "x", "both", cpl.liftingHands)
	unbindKey(client, "v", "both", cpl.plsStop)
	unbindKey(client,"mouse2", "both", cpl.bind2)
	unbindKey(client,"tab", "both", cpl.bind3)
	removeEventHandler("relWep", client, cpl.reloadWeapon)
end

addEventHandler("join:gamemode", resourceRoot, function()
	cpl.init_Gamemode(client)
	cpl.v[client].no_lag1 = nil
	cpl.v[client].no_lag2 = nil
	cpl.v[client].no_lag3 = nil
	cpl.v[client].no_lag4 = nil
end)

addEventHandler("quit:gamemode", resourceRoot, function()
	cpl.init_Gamemode_reset(client)
end)

addEventHandler("onResourceStop", resourceRoot, function()
	local elements = getElementsByType("player")
	local nextElement = function(_index) local index=0 return function() index=index+1 if _index[index] then return index, _index[index] end end end
	for _,client in nextElement(elements) do
		cpl.init_Gamemode_reset(client)
	end
end)