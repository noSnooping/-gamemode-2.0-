--[[-----------------------------------------------
----script feito por Lucas Damaceno(anony)
----em 2020. você pode usá-lo e editá-lo apenas o créditos são meus!
----youtube:https://www.youtube.com/channel/UCf7N0XUAHmOLpRO4MfXTHaQ?view_as=subscriber
--]]-----------------------------------------------
local cpl = {}

addEvent("join:gamemode", true)
addEvent("quit:gamemode", true)
addEvent("showMIds", true)

function cpl.voice_start() 
	if (source and isElement(source) and getElementType(source) == "player") then 
   		setElementData(source, "active_voice", true)	
	end
end 
addEventHandler("onPlayerVoiceStart", root, cpl.voice_start)



function cpl.voice_stop() 
 	if (source and isElement(source) and getElementType(source) == "player") then 
		removeElementData(source, "active_voice")
	end
end
addEventHandler("onPlayerVoiceStop", root, cpl.voice_stop)


			
function cpl.men()
	local sX, sY, sZ = getElementPosition(client)
	for k,p in ipairs(getElementsByType("player",root,false)) do
		local rX, rY, rZ = getElementPosition(p)
		local distance = getDistanceBetweenPoints3D(sX, sY, sZ, rX, rY, rZ) 
		local id = getElementData(client, "char:id")
        if distance <= 10 then     
			outputChatBox(getPlayerName(client).." ["..id.."]: #ffffffestá vendo a identidade de todos com a tecla F12",p,255,255,255,true)
		end	
	end	
end

cpl.init_Gamemode = function(client)
	addEventHandler("showMIds", client, cpl.men)
end

cpl.init_Gamemode_reset = function(client)
	removeElementData(client, "active_voice")
	removeEventHandler("showMIds", client, cpl.men)
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