--[[-----------------------------------------------
----script feito por Addlibs copom feito por Lucas Damaceno(anony)
----em 2020. você pode usá-lo e editá-lo apenas o créditos são meus!
----youtube:https://www.youtube.com/channel/UCf7N0XUAHmOLpRO4MfXTHaQ?view_as=subscriber
--]]-----------------------------------------------
local scrx, scry = guiGetScreenSize() 
local CAUCULATE_x = function() if 640-scrx == 0 then return 1.02 else return scrx/640 end return 1.02 end
local CAUCULATE_y = function() if 480-scry == 0 then return 1.02 else return scry/480 end return 1.02 end
local x                     = CAUCULATE_x()
local y                     = CAUCULATE_y()
local key = "tab"

local cpl = {}
local animation = false
local interpolate = false
local progressAnimation = 0

local Inventory = {--[[Função feita por anony]]}
Inventory.drawShadowText = function(text,x,y,w,h,color,scale,font,...)
    local bit = function(bit32) 
        return bitExtract(bit32, 16, 8 ), bitExtract(bit32, 8, 8 ), bitExtract(bit32, 0, 8 ),bitExtract(bit32, 24, 8 )
    end 
    local _,_,_,alpha = bit(color)
    dxDrawText(text:gsub ("#%x%x%x%x%x%x", ""),x-1,y,w,h,tocolor(0,0,0,alpha),scale,font,...)
    dxDrawText(text:gsub ("#%x%x%x%x%x%x", ""),x,y-1,w,h,tocolor(0,0,0,alpha),scale,font,...)
    dxDrawText(text:gsub ("#%x%x%x%x%x%x", ""),x+1,y,w,h,tocolor(0,0,0,alpha),scale,font,...)
    dxDrawText(text:gsub ("#%x%x%x%x%x%x", ""),x,y+1,w,h,tocolor(0,0,0,alpha),scale,font,...)
    dxDrawText(text,x,y,w,h,color,scale,font,...)
end


cpl.alpha = 0.0
cpl.top = 0
cpl.tickCount = getTickCount()
cpl.top1 = 0
local i = 0

function convertNumber ( number )   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
end

local warning = 0
cpl.timerLife = function()
        local hunger = getElementData(localPlayer, "char:hunger")
        if getElementData(localPlayer, "adminjail") == 1 and getElementData(localPlayer, "char:adminduty") == 0 then
			return
		end
		
		if hunger and hunger > 7 then
            random = math.random(4, 7)
            setElementData(localPlayer, "char:hunger", hunger - random)
        elseif hunger and  hunger ~= 0 and hunger <= 7 then
            setElementData(localPlayer, "char:hunger", 0)
        else
            if warning ~= 3 then
                outputChatBox("[CPH MTA] Você está ficando com fome! Comer alguma coisa!",255, 255, 255, true)
                
                --exports.JoinQuitGtaV:createNotification("comida", "*Ei, Você está ficando com fome, Tente comer alguma coisa!", 5)

                warning = warning + 1
            else
                setElementHealth(localPlayer, getElementHealth(localPlayer) - 3)
            end
        end
        local hunger = getElementData(localPlayer, "char:thirst")
		
		if hunger and hunger > 7 then
            random = math.random(4, 7)
            setElementData(localPlayer, "char:thirst", hunger - random)
        elseif hunger and hunger ~= 0 and hunger <= 7 then
            setElementData(localPlayer, "char:thirst", 0)
        else
            if warning ~= 3 then
                outputChatBox("[CPH MTA] *Ei, Você está ficando com sede, Tente beber alguma coisa!",255, 255, 255, true)

               -- exports.JoinQuitGtaV:createNotification("comida", "*Ei, Você está ficando com sede, Tente beber alguma coisa!", 5)


                warning = warning + 1
            else
                setElementHealth(localPlayer, getElementHealth(localPlayer) - 3)
            end
        end
end
cpl.timer = setTimer(cpl.timerLife, 1000 * 60 * 6, 0)


local countPlayers = function(typ)
	local players = {}
	for k,v in ipairs(getElementsByType("player")) do
		if getElementData(v, "char:dutyfaction") == typ then
			table.insert(players, v)
		end
	end
	return #players
end

local countPlayersP = function(typ)
	local players = {}
	for k,v in ipairs(getElementsByType("player")) do
		if exports.btc_admin:isPlayerDuty(v) then
			table.insert(players, v)
		end
	end
	return #players
end


function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end



addEventHandler("onClientRender",root,function()
	--if getPlayerName(localPlayer) == "ncp" then
		
		if cpl.anim then
			local tickCount_ = getTickCount() - cpl.tickCount
			cpl.alpha = interpolateBetween(cpl.alpha,0,0,1.0,0,0,tickCount_/500,"OutInBounce")
			cpl.top,cpl.top1 = interpolateBetween(cpl.top,cpl.top1,0,300,140,0,tickCount_/500,"OutInBounce")
		else
			local tickCount_ = getTickCount() - cpl.tickCount
			cpl.alpha = interpolateBetween(cpl.alpha,0,0,0.0,0,0,tickCount_/500,"InOutBounce")
			cpl.top,cpl.top1 = interpolateBetween(cpl.top,cpl.top1,0,0,0,0,tickCount_/500,"InOutBounce")
		end
	
		--dxDrawRectangle(379*x,480*y-(cpl.top*y),1*x,200*y,tocolor(255,69,0,255*cpl.alpha))
		--dxDrawRectangle(380*x,480*y-(cpl.top*y),180*x,200*y,tocolor(0,0,0,255*cpl.alpha))
		
		--Inventory.drawShadowText("Dados gerais",420*x,480*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 1*y, "diploma", "left", "top", false, false, false, true, false)
		
		
		
		
		local colete = getPedArmor(localPlayer) or "0"
		local id = getElementData(localPlayer, "char:id") or "Sem RG"
		local level = getElementData(localPlayer, "Sys:Level") or "0"
		local exp = getElementData(localPlayer, "LSys:EXP") or "1000"
		local fome = getElementData(localPlayer, "char:hunger") or "20"
		local sede = getElementData(localPlayer, "char:thirst") or "100"
		local vida = getElementHealth(localPlayer) or "50"
		local vida = math.round(tonumber(vida), 1)
		
		local colete = getPedArmor(localPlayer) or "30"	
		local colete = math.round(tonumber(colete), 1)
		
        local money = convertNumber ( getElementData(localPlayer,"char:money") or "0")
        local bank = convertNumber ( getElementData(localPlayer,"char:bankmoney") or "0")   
		local pp = convertNumber ( getElementData(localPlayer,"char:pp") or "0")		
        local realName = getPlayerName(getLocalPlayer())
        local Encaminhado = getElementData ( localPlayer, "job") or getElementData ( localPlayer, "Emprego")  or "Desempregado"
        if Encaminhado == "SemEmprego" then
            Encaminhado = "Desempregado"
        end      		
		local total = getPedTotalAmmo( localPlayer )
		local clip = getPedAmmoInClip( localPlayer )		
		local centeryText4 = dxGetTextWidth(""..(clip),1.6,"clear") 
		local mod = "normal"
		local mode = getElementData(localPlayer,"cpl.voiceDistance")
		if mode then
			if mode == 6 then
				mod = "sussurrar"
			elseif mode == 20 then
				mod = "normal"
			elseif mode == 40 then
				mod = "gritar"
			end
		end 
		
		dxDrawRectangle(534*x,480*y-(cpl.top*y),118*x,290*y,tocolor(255,69,0,255))	
		--dxDrawRectangle(534*x,480*y-(cpl.top*y),118*x,24*y,tocolor(31,31,31,255))	
		--dxDrawImageSection(576*x,480*y-(cpl.top*y), 50*x,50*y, 0, 0, 100, 100, "1.png", 0, 0, 0, tocolor(255,255,255,120))
		
		dxDrawText("Dados gerais",554*x,480*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "diploma", "left", "top", false, false, false, true, false)
		
		dxDrawText("Nome: "..realName,536*x,510*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		dxDrawText("Profissao: "..Encaminhado,536*x,522*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		dxDrawText("RG: "..id,536*x,532*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		dxDrawText("R$: "..money,536*x,542*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		dxDrawText("Banco R$: "..bank,536*x,552*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		dxDrawText("PP R$: "..pp,536*x,562*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		dxDrawText("Voice: "..mod,536*x,572*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		dxDrawText("Fome: "..fome,536*x,582*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		dxDrawText("Sede: "..sede,536*x,592*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		dxDrawText("Vida: "..vida,536*x,602*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		dxDrawText("Colete: "..colete,536*x,612*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		dxDrawText("Level: "..level,536*x,622*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		dxDrawText("EXP: "..exp,536*x,632*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		if (clip) > 0 then
			if getPedWeapon(localPlayer) ~= 28 then
				dxDrawText("Balas: "..clip,536*x,642*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)		
			end
			else
			dxDrawText("-",536*x,642*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		end
		if exports.utilidades:isPlayerTeamData(getLocalPlayer()) then

		local radioText = "Copom: desligado"

		if getElementData( localPlayer, "copom" ) then
			radioText = "Copom: ligado"
		end
		dxDrawText(radioText,536*x,652*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		
		else
		dxDrawText("-",536*x,652*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		end
		if not getElementData(localPlayer,"loggedin") then
			dxDrawText("Aperte 'Enter' para começar",534*x,717*y-(cpl.top*y), 0, 0, tocolor(0,0,0,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		end
		
		dxDrawText("Cidadãos: "..#getElementsByType("player") or "0",536*x,662*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		dxDrawText("Políciais: "..countPlayersP() or "0",536*x,672*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		dxDrawText("Médicos: "..countPlayers(4) or "0",536*x,682*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		dxDrawText("Mecanicos: "..countPlayers(3) or "0",536*x,692*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		dxDrawText("Detran: "..countPlayers(1) or "0",536*x,702*y-(cpl.top*y), 0, 0, tocolor(255,255,255,120*cpl.alpha), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		
		if getKeyState(key) then
			dxDrawImageSection(556*x,440*y-(20*y), 60*x,60*y, 0, 0, 100, 100, "2.png", 0, 0, 0, tocolor(255,255,255,120))
			dxDrawImageSection(556*x,440*y-(20*y), 60*x,60*y, 0, 0, 100, 100, "3.png", 0, 0, 0, tocolor(255,255,255,120))
			
			if getPlayerName(localPlayer) == "CPH+Anony" then
				--dxDrawImageSection(572*x-30*x,0, 66*x,61*y, 0, 0, 1026, 1021, "1.png", 0, 0, 0, tocolor(255,255,255,255))
			end
			
			dxDrawText("www.FiveM.cphmta.com.br",536*x,458*y, 0, 0, tocolor(255,255,255,120), 0.6*x, "clear", "left", "top", false, false, false, true, false)
		else
			dxDrawImageSection(556*x,440*y-(20*y), 60*x,60*y, 0, 0, 100, 100, "2.png", 0, 0, 0, tocolor(255,255,255,120))
			dxDrawImageSection(556*x,440*y-(20*y), 60*x,60*y, 0, 0, 100, 100, "3.png", 0, 0, 0, tocolor(255,255,255,120))
			
			if getPlayerName(localPlayer) == "CPH+Anony" then
			--	dxDrawImageSection(572*x-30*x,0, 66*x,61*y, 0, 0, 1026, 1021, "1.png", 0, 0, 0, tocolor(255,255,255,255))
			end
			
			if not getElementData(localPlayer,"loggedin") then
				dxDrawText("www.FiveM.cphmta.com.br",536*x,458*y, 0, 0, tocolor(255,255,255,120), 0.6*x, "clear", "left", "top", false, false, false, true, false)
			else
				dxDrawText("www.Five#ff4500M#FFFFFF.cphmta.com.br",536*x,458*y, 0, 0, tocolor(255,255,255,120), 0.6*x, "clear", "left", "top", false, false, false, true, false)
			end
		end

	--end
end)

local drw = function(key,ste)
	if ste == "down" then
		cpl.anim = true
	elseif ste == "up" then
		cpl.anim = false 
	end
	cpl.tickCount = getTickCount()
end

function checkPlayer(type)
	if type == "charSpawn" then 
		cpl.anim = true
		cpl.tickCount = getTickCount()
	end
end
addEvent("checkPlayerCharacter", true)
addEventHandler("checkPlayerCharacter", root, checkPlayer)

if getElementData(localPlayer,"loggedin") then
	cpl.anim = true
	cpl.tickCount = getTickCount()
	bindKey(key,"both",drw)
end

function checkPlayerLogged()
	cpl.anim = false 
	cpl.tickCount = getTickCount()
	bindKey(key,"both",drw)
end
addEvent("checkPlayerCharacterLogged", true)
addEventHandler("checkPlayerCharacterLogged", root, checkPlayerLogged)