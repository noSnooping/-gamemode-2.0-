--[[-----------------------------------------------
----script feito por Addlibs copom feito por Lucas Damaceno(anony)
----em 2020. você pode usá-lo e editá-lo apenas o créditos são meus!
----youtube:https://www.youtube.com/channel/UCf7N0XUAHmOLpRO4MfXTHaQ?view_as=subscriber
--]]-----------------------------------------------

local cpl = {}

addEvent("join:gamemode", true)
addEvent("quit:gamemode", true)

cpl.init_Gamemode = function()
	triggerServerEvent("join:gamemode",resourceRoot)
	addEventHandler("onClientPreRender", root, cpl.voice)
end


--[[
cpl.mode = 1
cpl.voiceDistance = 20

setElementData(localPlayer,"cpl.voiceDistance",cpl.voiceDistance)

cpl.alternar = function(key,keyState)
	if keyState == "down" then
		if cpl.mode < 2 then 
			cpl.mode = cpl.mode + 1
		else
			cpl.mode = 0
		end	
		if cpl.mode == 0 then
			cpl.voiceDistance = 6
			outputChatBox("voice mode: sussurrar")
		elseif cpl.mode == 1 then 
			cpl.voiceDistance = 20
			outputChatBox("voice mode: normal")
		elseif cpl.mode == 2 then
			cpl.voiceDistance = 40
			outputChatBox("voice mode: gritar")
		end		
		setElementData(localPlayer,"cpl.voiceDistance",cpl.voiceDistance)
	end
end]]

cpl.init_Gamemode_reset = function(bool)
	if not bool then triggerServerEvent("quit:gamemode",resourceRoot) end
	removeEventHandler("onClientPreRender", root, cpl.voice)
	local elements = getElementsByType("player")
	local nextElement = function(_index) local index=0 return function() index=index+1 if _index[index] then return index, _index[index] end end end
	for _,client in nextElement(elements) do
	    setSoundVolume(client, 50)
        setSoundEffectEnabled(client, "compressor", false)			
	end
	--unbindKey("o", "both", cpl.alternar)
end

addEventHandler("join:gamemode", localPlayer, function()
	cpl.init_Gamemode()
	--bindKey("o", "both", cpl.alternar)
end)

addEventHandler("quit:gamemode", localPlayer, function()
	cpl.init_Gamemode_reset()
end)


addEventHandler("onClientResourceStop",getResourceRootElement(),function()
    cpl.init_Gamemode_reset(true)
end)

function cpl.voice()
		if not exports.utilidades:isPlayerTeamData(localPlayer) then
			if getElementData(localPlayer, "copom") then 
				setElementData(localPlayer, "copom", false)
			end
		end
		local elements = getElementsByType("player")
		local nextElement = function(_index) local index=0 return function() index=index+1 if _index[index] then return index, _index[index] end end end
		for _,v in nextElement(elements) do       
            local vecSoundPos = v.position
            local vecCamPos = Camera.position
            local fDistance = (vecSoundPos - vecCamPos).length
            local fMaxVol = 50--v:getData("maxVol") or 2
            local fMinDistance = v:getData("minDist") or 5
            local fMaxDistance = v:getData("maxDist") or getElementData(v,"cpl.voiceDistance") or 20 --cpl.voiceDistance--40
            local fPanSharpness = 1.0
            if (fMinDistance ~= fMinDistance * 2) then
                fPanSharpness = math.max(0, math.min(1, (fDistance - fMinDistance) / ((fMinDistance * 2) - fMinDistance)))
            end
            local fPanLimit = (0.65 * fPanSharpness + 0.35)
            local vecLook = Camera.matrix.forward.normalized
            local vecSound = (vecSoundPos - vecCamPos).normalized
            local cross = vecLook:cross(vecSound)
            local fPan = math.max(-fPanLimit, math.min(-cross.z, fPanLimit))
            local fDistDiff = fMaxDistance - fMinDistance;
            local fVolume
            if (fDistance <= fMinDistance) then
                fVolume = fMaxVol
            elseif (fDistance >= fMaxDistance) then
                fVolume = 0.0
            else
                fVolume = math.exp(-(fDistance - fMinDistance) * (5.0 / fDistDiff)) * fMaxVol
            end
				
			
				
				if getElementData(localPlayer, "copom") and getElementData(v, "copom") then 
	           		setSoundVolume(v, 50)
				else
				if getElementData( localPlayer, "call:callwith" ) and getElementData(v, "call:callwith") and getElementData(v, "call:callwith") == localPlayer then 
	           		setSoundVolume(v, 50)
				else
                	setSoundVolume(v, fVolume)
				end	
				end
			
			if getElementData(v, 'deadped') then
				setSoundVolume(v, 0)
			end	
	
			
		end
end

addEventHandler("onClientResourceStart", resourceRoot,function ()
    -- triggerServerEvent("proximity-voice::broadcastUpdate", localPlayer) -- request server to start broadcasting voice data once the resource is loaded (to prevent receiving voice data while this script is still downloading)
		local elements = getElementsByType("player")
		local nextElement = function(_index) local index=0 return function() index=index+1 if _index[index] then return index, _index[index] end end end
		for _,v in nextElement(elements) do   
			setSoundPan(v, 0)
			setSoundEffectEnabled(v, "compressor", false)
		end
end,false)
 