--[[-----------------------------------------------
----script feito por Addlibs copom feito por Lucas Damaceno(anony)
----em 2020. você pode usá-lo e editá-lo apenas o créditos são meus!
----youtube:https://www.youtube.com/channel/UCf7N0XUAHmOLpRO4MfXTHaQ?view_as=subscriber
--]]-----------------------------------------------

local cpl = {}
--[[
cpl.stats = {
	[72] = 999, 
	[74] = 999,  
	[76] = 999, 
	[77] = 999, 
	[78] = 999,  
	[79] = 999,  
	[230] = 0
}]]

addEvent("join:gamemode", true)
addEvent("quit:gamemode", true)

cpl.init_Gamemode = function(client)
	--for i, stat in pairs(cpl.stats) do
	for i=0, 230 do
		if i == 21 or i == 22 or i == 23 or i == 24 or i == 25 then 
		--sem  retorno
		else
			if i == 230 or i == 229 or i == 75 or i == 69 or i == 70 then
				client:setStat(i, 500) --cair mais facil da bike
			else
				client:setStat(i, 1000)
			end
		end
	end
end

cpl.init_Gamemode_reset = function(client)
	--for i, stat in pairs(cpl.stats) do 
		--if stat == 999 then
		--	client:setStat(i, 0) 
		--elseif stat == 0 then	
	for i=0, 230 do	
		if i == 21 or i == 22 or i == 23 or i == 24 or i == 25 then 
		else
			client:setStat(i, 500) 
		end
	end
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