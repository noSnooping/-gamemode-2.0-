--[[-----------------------------------------------
----script feito por Addlibs copom feito por Lucas Damaceno(anony)
----em 2020. você pode usá-lo e editá-lo apenas o créditos são meus!
----youtube:https://www.youtube.com/channel/UCf7N0XUAHmOLpRO4MfXTHaQ?view_as=subscriber
--]]-----------------------------------------------
local cpl = {}

cpl.weapons = {22,23,24,25,26,27,28,29,30,31,32,33,34,38}
cpl.skd = {"pro","std","poor"}

function cpl.no_recoil(bool)
	local nextElement = function(_index) local index=0 return function() index=index+1 if _index[index] then return index, _index[index] end end end
	for _,weapon in nextElement(cpl.weapons) do
		local nextElement = function(_index) local index=0 return function() index=index+1 if _index[index] then return index, _index[index] end end end
		for _,skill in nextElement(cpl.skd) do
			if bool then
				setWeaponProperty(weapon, skill, "accuracy", 10000)
				if weapon == 22 then
					setWeaponProperty(weapon, skill, "damage", 50) 
				elseif weapon == 24 then
					setWeaponProperty(weapon, skill, "damage", 50) 
				elseif weapon == 30 then
					setWeaponProperty(weapon, skill, "damage", 70) 
				elseif weapon == 31 then
					setWeaponProperty(weapon, skill, "damage", 70) 
				elseif weapon == 33 then
					setWeaponProperty(weapon, skill, "damage", 200) 
				elseif weapon == 34 then
					setWeaponProperty(weapon, skill, "damage", 200) 
				end
			elseif not bool then
				local original = getOriginalWeaponProperty(weapon, skill, "accuracy")
				setWeaponProperty(weapon, skill, "accuracy", original)
				local original = getOriginalWeaponProperty(weapon, skill, "damage")
				if weapon == 22 then
					setWeaponProperty(weapon, skill, "damage", original) 
				elseif weapon == 24 then
					setWeaponProperty(weapon, skill, "damage", original) 
				elseif weapon == 30 then
					setWeaponProperty(weapon, skill, "damage", original) 
				elseif weapon == 31 then
					setWeaponProperty(weapon, skill, "damage", original) 
				elseif weapon == 33 then
					setWeaponProperty(weapon, skill, "damage", original) 
				elseif weapon == 34 then
					setWeaponProperty(weapon, skill, "damage", original) 
				end
			end
		end
	end
end

addEventHandler("onResourceStart",resourceRoot,function()
	cpl.no_recoil(true)
end)

addEventHandler("onResourceStop",resourceRoot,function()
	cpl.no_recoil(false)
end)

