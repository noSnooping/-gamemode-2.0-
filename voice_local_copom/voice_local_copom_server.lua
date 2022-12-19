--[[-----------------------------------------------
----script feito por Addlibs copom feito por Lucas Damaceno(anony)
----em 2020. você pode usá-lo e editá-lo apenas o créditos são meus!
----youtube:https://www.youtube.com/channel/UCf7N0XUAHmOLpRO4MfXTHaQ?view_as=subscriber
--]]-----------------------------------------------

local cpl = {}
cpl.v = {}

addEvent("join:gamemode", true)
addEvent("quit:gamemode", true)
--addEvent("proximity-voice::broadcastUpdate", true)
 
cpl.init_Gamemode = function(client)
	--addEventHandler("proximity-voice::broadcastUpdate",client,cpl.broadcastUpdate)
	bindKey(client,"Q","down",cpl.activeVoice)
	setPlayerVoiceIgnoreFrom(client, nil)
	setPlayerVoiceBroadcastTo(client, root)	
	cpl.v[client] = {}
	cpl.v[client].mode = 1
	cpl.v[client].voiceDistance = 20
	bindKey(client,"O","down",cpl.alternar)
	setElementData(client,"cpl.voiceDistance",cpl.v[client].voiceDistance)
end


cpl.alternar = function(client,key,keyState)
	if keyState == "down" then
		if cpl.v[client].mode < 2 then 
			cpl.v[client].mode = cpl.v[client].mode + 1
		else
			cpl.v[client].mode = 0
		end	
		if cpl.v[client].mode == 0 then
			cpl.v[client].voiceDistance = 6
			--outputChatBox("voice mode: sussurrar",client)
			triggerClientEvent(client,"onPlayerNotify", client, true, "[VOICE] mode: sussurrar",{255, 255, 255,255},"not.png",{255,255,255,255})
		elseif cpl.v[client].mode == 1 then
			cpl.v[client].voiceDistance = 20
			--outputChatBox("voice mode: normal",client)
			triggerClientEvent(client,"onPlayerNotify", client, true, "[VOICE] mode: normal",{255, 255, 255,255},"not.png",{255,255,255,255})
		elseif cpl.v[client].mode == 2 then
			cpl.v[client].voiceDistance = 40
			--outputChatBox("voice mode: gritar",client)
			triggerClientEvent(client,"onPlayerNotify", client, true, "[VOICE] mode: gritar",{255, 255, 255,255},"not.png",{255,255,255,255})
		end		
		setElementData(client,"cpl.voiceDistance",cpl.v[client].voiceDistance)
	end
end


cpl.init_Gamemode_reset = function(client)
	removeElementData(client, "copom")
	unbindKey(client,"Q","down",cpl.activeVoice)
	setPlayerVoiceIgnoreFrom(client, nil)
	setPlayerVoiceBroadcastTo(client, root)	
	unbindKey(client,"O","down",cpl.alternar)
	cpl.v[client] = {}
	cpl.v[client].mode = 1
	cpl.v[client].voiceDistance = 20
	setElementData(client,"cpl.voiceDistance",cpl.v[client].voiceDistance)
	--removeElementData(client, "call:callwith")
	setElementData(client, "call:callwith", false)
	print("zero")
end

addEventHandler("join:gamemode", resourceRoot, function()
	cpl.init_Gamemode(client)
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

addEventHandler("onPlayerJoin", root,
    function()
        setPlayerVoiceIgnoreFrom(source, root)
        setPlayerVoiceBroadcastTo(source, nil)
    end
)


function cpl.activeVoice(thePlayer,key,state)
	if exports.utilidades:isPlayerTeamData(thePlayer) then
		if not getElementData(thePlayer, "copom") then 
			setElementData(thePlayer, "copom", true)
		else
			setElementData(thePlayer, "copom", false)
		end
	end
end
