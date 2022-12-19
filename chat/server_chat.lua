--[[-----------------------------------------------
----script feito por Lucas Damaceno(anony)
----em 2020. você pode usá-lo e editá-lo apenas o créditos são meus!
----youtube:https://www.youtube.com/channel/UCf7N0XUAHmOLpRO4MfXTHaQ?view_as=subscriber
--]]-----------------------------------------------

local cpl = {}
cpl.v = {}

addEvent("join:gamemode", true)
addEvent("quit:gamemode", true)

cpl.mutePlayer = function(client)
	local thePlayer = client
	if cpl.v[thePlayer] then
		if (not cpl.v[thePlayer].t_noFLOOD) then
			cpl.v[thePlayer].t_noFLOOD = setTimer(function(player) cpl.v[player].t_noFLOOD = false cpl.v[player].t_noFLOOD_COUNT = 0 end,5000,1, thePlayer)	
		else
			if cpl.v[thePlayer].t_noFLOOD_COUNT >= 10 then
				outputChatBox("[ANTI-FLOOD] Você foi mutado por um minuto por mandar mensagens muito rápido no chat tenha um pouco de paciência!", thePlayer, 255, 0, 0,true)
				setPlayerMuted(thePlayer, true)
				cpl.v[thePlayer].t_noFLOOD_t2 = setTimer(function(player) setPlayerMuted(player, false) cpl.v[player].t_noFLOOD_t2 = false end,10000,1, thePlayer)	
				cpl.v[thePlayer].t_noFLOOD_COUNT = 0
			end
		end	
		cpl.v[thePlayer].t_noFLOOD_COUNT = cpl.v[thePlayer].t_noFLOOD_COUNT + 1
	end
end

local color = {}

function RGBToHex(red, green, blue, alpha)
	
	-- Make sure RGB values passed to this function are correct
	if( ( red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255 ) or ( alpha and ( alpha < 0 or alpha > 255 ) ) ) then
		return nil
	end

	-- Alpha check
	if alpha then
		return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return string.format("#%.2X%.2X%.2X", red, green, blue)
	end

end

addEventHandler("onPlayerJoin",getRootElement(), 
function () 
	local rgba = RGBToHex(math.random(0,255), math.random(0,255), math.random(0,255))
	color[source] = rgba
end) 
addEventHandler("onPlayerQuit",getRootElement(), 
function () 
	color[source] = nil
end) 

addEventHandler("onResourceStart",resourceRoot, 
function () 
	for i,v in ipairs(getElementsByType("player")) do
		local rgba = RGBToHex(math.random(0,255), math.random(0,255), math.random(0,255))
		color[v] = rgba
	end
end) 

local discordWebhookURL = "https://discordapp.com/api/webhooks/763878997511110666/l136SKtxp4uJRk8vNMvEU7qKzpCtul5z_klcGBOeDHroQcEl_W9DLKjxQBdc5Pf4GXen"

function sendDiscordMessage(message)
sendOptions = {
    queueName = "CHAT-DO-SERVIDOR",
    connectionAttempts = 3,
    connectTimeout = 5000,
    formFields = {
        content="```"..message.."```"
    },
}
	fetchRemote ( discordWebhookURL, sendOptions, callback )
end

function callback()
--outputDebugString("Message sent!")
end

--[[
-- Test the function
function test(player, command, ...)
local msg = table.concat({...}," ") -- for multiple words
sendDiscordMessage(msg)
end
addCommandHandler("dcmessage", test)]]

function cpl.blockChatMessage(message, messageType)
	if isPlayerMuted(source) then return outputChatBox("say: You are muted",source, 205, 155, 29, true) end
	if messageType == 0 then
		cancelEvent()
		if not message then return end
		local sX, sY, sZ = getElementPosition(source)
		local name = getPlayerName(source) 
		local playerid = getElementData(source, "char:id") or "N/A"
		local colorVIP = getElementData(source,"colorvip") or "#F0F0F0"
		local elements = getElementsByType("player",root,true)
		local nextElement = function(_index) local index=0 return function() index=index+1 if _index[index] then return index, _index[index] end end end
		for _,client in nextElement(elements) do
       		local rX, rY, rZ = getElementPosition(client)
			local distance = getDistanceBetweenPoints3D(sX, sY, sZ, rX, rY, rZ)
			if distance <= 20 then
				outputChatBox(colorVIP..color[source].."● [Chat Local] ● #ffffff"..name.." "..colorVIP..color[source].."["..playerid.."]: #ffffff"..message, client, 255, 255, 255,true)
			
				if source == client then
					cpl.mutePlayer(source)
				end
			end
		end 
		
	elseif messageType == 2 then	
		cancelEvent()
	end 
end
addEventHandler("onPlayerChat", root, cpl.blockChatMessage)
	
function cpl.teamsay(source, cmd, ...)	
	if isPlayerMuted(source) then return outputChatBox("say: You are muted",source, 205, 155, 29, true) end
	local message = #{...} > 0 and table.concat({...}," ") or nil
	if not message then return end
	local playerid = getElementData(source, "char:id") or "N/A"
	local name = getPlayerName(source) 
	local colorVIP = getElementData(source,"colorvip") or "#F0F0F0"
	local team = getElementData(source,"char:dutyfaction")
	local elements = getElementsByType("player")
	local nextElement = function(_index) local index=0 return function() index=index+1 if _index[index] then return index, _index[index] end end end
	for _,client in nextElement(elements) do
		if team then 
			if getElementData(client,"char:dutyfaction") then
				if team == getElementData(client,"char:dutyfaction") then
					outputChatBox(colorVIP..color[source].."● [Chat Equipe] ● #ffffff"..name.." "..colorVIP..color[source].."["..playerid.."]: #ffffff"..message, client, 255, 255, 255,true)
					if source == client then
						cpl.mutePlayer(source)
					end
				end
			end
		end
    end 
end
addCommandHandler("Chat-Equipe", cpl.teamsay, false, false)

function cpl.anonimo(source, cmd, ...)	
	if (getElementData(source,"char:money") and getElementData(source,"char:money")) >= 100 then
	if getElementData(source, "adminjail") == 1 then exports.Scripts_Dxmessages:outputDx ( source, "Você está preso não pode usar o chat", "warning" ) return end
	if isPlayerMuted(source) then return outputChatBox("say: You are muted",source, 205, 155, 29, true) end
	local message = #{...} > 0 and table.concat({...}," ") or nil
	if not message then return end
	local playerid = getElementData(source, "char:id") or "N/A"
	local elements = getElementsByType("player")
	local nextElement = function(_index) local index=0 return function() index=index+1 if _index[index] then return index, _index[index] end end end
	for _,client in nextElement(elements) do
		if getElementData(client, "acc:admin") and (tonumber(getElementData(client, "acc:admin")) >= 1) then
			outputChatBox("#A9A9A9● [Anonimo] ● ["..playerid.."]: "..message,client, 255, 255, 255, true) 
		else
			outputChatBox("#A9A9A9● [Anonimo]: "..message,client, 255, 255, 255, true) 
		end
		if source == client then
			cpl.mutePlayer(source)
		end
    end 
	local remov = "● [Anonimo]: ● ["..playerid.."]: "..message
	sendDiscordMessage(remov:gsub ("#%x%x%x%x%x%x", ""))
	setElementData(source, "char:money", (getElementData(source,"char:money") or 0) - 100)
	triggerClientEvent(source,"onPlayerNotify", source, true, "Gastou R$100 para mandar mensagem no Anonimo",{255, 255, 255,255},"not.png",{255,255,255,255})
	else
	triggerClientEvent(source,"onPlayerNotify", source, true, "você precisa de R$100 para mandar mensagem no Anonimo",{255, 255, 255,255},"not.png",{255,255,255,255})
	end
end
addCommandHandler("Anonimo", cpl.anonimo, false, false)




function cpl.facebook(source, cmd, ...)
	if (getElementData(source,"char:money") and getElementData(source,"char:money")) >= 100 then
	if getElementData(source, "adminjail") == 1 then exports.Scripts_Dxmessages:outputDx ( source, "Você está preso não pode usar o chat", "warning" ) return end
	if isPlayerMuted(source) then return outputChatBox("say: You are muted",source, 205, 155, 29, true) end
	local message = #{...} > 0 and table.concat({...}," ") or nil
	if not message then return end
	local playerid = getElementData(source, "char:id") or "N/A"
	local colorVIP = getElementData(source,"colorvip") or "#F0F0F0"
	local name = getPlayerName(source)
	local elements = getElementsByType("player")
	local nextElement = function(_index) local index=0 return function() index=index+1 if _index[index] then return index, _index[index] end end end
	for _,client in nextElement(elements) do
		outputChatBox(colorVIP..color[source].."● [Facebook] ● #ffffff"..name.." "..colorVIP..color[source].."["..playerid.."]: #ffffff"..message,client, 255, 255, 255, true) 
		if source == client then
			cpl.mutePlayer(source)
		end		
    end 
	local remov = "● [Facebook] ● "..name.." ["..playerid.."]: "..message
	sendDiscordMessage(remov:gsub ("#%x%x%x%x%x%x", ""))
	
	setElementData(source, "char:money", (getElementData(source,"char:money") or 0) - 100)
	triggerClientEvent(source,"onPlayerNotify", source, true, "Gastou R$100 para mandar mensagem no facebook",{255, 255, 255,255},"not.png",{255,255,255,255})
	else
	triggerClientEvent(source,"onPlayerNotify", source, true, "você precisa de R$100 para mandar mensagem no facebook",{255, 255, 255,255},"not.png",{255,255,255,255})
	end
end
addCommandHandler("Facebook", cpl.facebook, false, false)

cpl.init_Gamemode = function(client)
	bindKey(client, "i", "down", "chatbox", "Facebook")
	bindKey(client, "u", "down", "chatbox", "Anonimo")
	bindKey(client, "y", "down", "chatbox", "Chat-Equipe")
	--addEventHandler("onPlayerChat", client, cpl.blockChatMessage)
	cpl.v[client] = {}
	cpl.v[client].t_noFLOOD = false
	cpl.v[client].t_noFLOOD_COUNT = 0
	cpl.v[client].t_noFLOOD_t2 = false
	cpl.v[client].muted = false
end

cpl.init_Gamemode_reset = function(client)
	unbindKey(client, "i", "down", "chatbox", "Facebook")
	unbindKey(client, "u", "down", "chatbox", "Anonimo")
	unbindKey(client, "y", "down", "chatbox", "Chat-Equipe")
	--removeEventHandler("onPlayerChat", client, cpl.blockChatMessage)
	cpl.v[client] = nil
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