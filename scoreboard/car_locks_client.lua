--[[-----------------------------------------------
----script feito por Lucas Damaceno(anony)
----em 2020. você pode usá-lo e editá-lo apenas o créditos são meus!
----youtube:https://www.youtube.com/channel/UCf7N0XUAHmOLpRO4MfXTHaQ?view_as=subscriber
--]]-----------------------------------------------

local sCam = {
tickCount = getTickCount(),
anim = false,
alpha = 0,
dash = false
}

local texts = {server_name = "Conexao PlayHard"}

local x, y = guiGetScreenSize() 
CAUCULATE_x = function() if 640-x == 0 then return 1 else return x/640 end return 1 end
CAUCULATE_y = function() if 480-y == 0 then return 1 else return y/480 end return 1 end

local xfix                     = CAUCULATE_x()
local yfix                     = CAUCULATE_y()


local font = exports.fonts:getFont(2)
local font2 = exports.fonts:getFont(1)
local h2 = dxGetFontHeight(1,"arial")
local font3 = exports.fonts:getFont(3)
local h3 = dxGetFontHeight(1,font2)
local h4 = dxGetFontHeight(1.5,"arial")

local font5 = exports.fonts:getFont(4)
local h5 = dxGetFontHeight(1,font5)
local font6 = exports.fonts:getFont(5)
local h6 = dxGetFontHeight(1,font6)

local myObject,myElement, guiWindow = nil, nil, nil
local myRotation = {0,0,160}
local peda = 80

local myElement = createPed(getElementModel(getLocalPlayer()), 0, 0, 0)
setElementFrozen(myElement, true)
setElementDimension(myElement,getElementDimension(localPlayer))
setElementInterior(myElement,getElementInterior(localPlayer))

local on
function createDrawDesign()
	myObject = 	exports.object_preview:createObjectPreview(myElement,0,0,0,1,1,1,1,true,true,true)
	exports.object_preview:setAlpha(myObject,peda)
	guiWindow = guiCreateWindow((x/2)-250-300,y/2-340+20,400,600,"Test area",false,false)
	guiMoveToBack(guiWindow,false) 
	guiSetAlpha(guiWindow, 0)
	local projPosX, projPosY = guiGetPosition(guiWindow,true)
	local projSizeX, projSizeY = guiGetSize(guiWindow, true)	
	on = true
end

function destroyDesign()
	if myElement and isElement(myElement) then
		exports.object_preview:destroyObjectPreview(myObject)
		on = false
	end
end

local cpl = {}

local deCrypted = {}
local modelsDownloaded = {}
local models = {
	"unknown.png",
	"vida.png",
	"colete.png",
	"agua.png",
	"han.png",
	"level.png",
    "cartao.png",
	"xp.png",
	"user.png",
	"discord.png",
	"facebook.png",
	"youtube.png",
	"logo.png",
	"5.png"
}

function loadDSG_Download()
	modelsDownloaded = {}
    for i,model in ipairs(models) do
        downloadFile(model)
    end
end

local crypt = "CPH"

function crypt_protection(theFile)
	local file = fileOpen(theFile) 
	local data = fileRead(file, fileGetSize(file)) 
	local newFileName = theFile:gsub(".png", ".yuv")
	
	deCrypted[theFile] = dxCreateTexture(data, "argb", false, "wrap")
	
	fileClose(file) 
	data = teaEncode(data, crypt) 

	if fileExists(theFile) then 
		fileDelete(theFile) 
	end

	local newFile = fileCreate(newFileName)
	fileWrite(newFile, data) 
	fileClose(newFile) 
	
	modelsDownloaded[#modelsDownloaded+1] = theFile
	if #modelsDownloaded == #models then
		cpl.init_Gamemode()
	end	
end

function unloadDSG_Download()
	modelsDownloaded = {}
    for i,model in ipairs(models) do
		local newFileName = model:gsub(".png", ".tiff")
        if fileExists(newFileName) then fileDelete(newFileName) end
    end
end

function onDownloadFinish(file,success)
    if not success then return end
	for i,model in ipairs(models) do
	    if ( file == model ) then
			crypt_protection(model)
		end
    end
end
addEventHandler("onClientFileDownloadComplete",resourceRoot,onDownloadFinish)

addEvent("join:gamemode", true)
addEvent("quit:gamemode", true)

cpl.timer = false
cpl.init_Gamemode = function()
	--triggerServerEvent("join:gamemode",resourceRoot) 
	if getKeyState("Tab") then createDrawDesign() end
	addEventHandler("onClientRender", root, cpl.draw, true, 'low-6')
	cpl.timer = setTimer(cpl.timerLife, 1000 * 60 * 6, 0)
	bindKey("Tab","both",cpl.tab)
end

cpl.init_Gamemode_reset = function(bool)
	--if not bool then triggerServerEvent("quit:gamemode",resourceRoot) end
	unloadDSG_Download() 
	destroyDesign()
	removeEventHandler("onClientRender", root, cpl.draw, true, 'low-6')
	setElementPosition(myElement,0, 0, 0)
	if isTimer(cpl.timer) then killTimer(cpl.timer) cpl.timer = nil end
	unbindKey("Tab","both",cpl.tab)
end

addEventHandler("join:gamemode", localPlayer, function()
	loadDSG_Download()
end)

addEventHandler("quit:gamemode", localPlayer, function()
	cpl.init_Gamemode_reset()
end)

addEventHandler("onClientResourceStop",resourceRoot,function()
	cpl.init_Gamemode_reset(true)
end)


local del1
local del2 
local del3 = true
local x, y = guiGetScreenSize()

function firt(n)
    if n == 1 or n == 21 or n == 31 then
        return "st"
	elseif n == 2 or n == 22 then
	    return "nd"
	elseif n == 3 or n == 23 then
	    return "rd"
	elseif n > 3 and n < 23 then
	    return "th"
	elseif n > 23 and n < 31 then
	    return "th"
    end
end 


function getDate()
    local months = { "Jan.", "Fev.", "Mar.", "Abril.", "Maio", "Jun.", "Jul.", "Agost.", "Setem.", "Out.", "Novem.", "Dezem."}
	local time = getRealTime()
	local day = time.monthday
	local month = time.month+1
	local year = time.year+1900
	if day < 10 then 
		day = day
	end
	if month < 10 then 
		month = months[month]--"0"..month
	end
	if year < 10 then 
		year = year
	end
	return day..". "..month.." "..year
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
                outputChatBox("[CPH MTA] #ffffffVocê está ficando com fome! Comer alguma coisa!",255, 255, 255, true)
                
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
                outputChatBox("[CPH MTA] #ffffff*Ei, Você está ficando com sede, Tente beber alguma coisa!",255, 255, 255, true)

               -- exports.JoinQuitGtaV:createNotification("comida", "*Ei, Você está ficando com sede, Tente beber alguma coisa!", 5)


                warning = warning + 1
            else
                setElementHealth(localPlayer, getElementHealth(localPlayer) - 3)
            end
        end
end

function cpl.draw()
	--if getElementData(localPlayer,"loggedin") then
	if sCam.dash then
	if sCam.anim then
	    local tickCount = getTickCount() - sCam.tickCount
		sCam.alpha,peda = interpolateBetween(sCam.alpha,peda,0,1.0,255,0,tickCount/14000,"Linear")
		peda = interpolateBetween(peda,0,0,255,0,0,tickCount/1000,"Linear")
	else
	    local tickCount = getTickCount() - sCam.tickCount
		sCam.alpha,peda = interpolateBetween(sCam.alpha,peda,0,0.0,0,0,tickCount/14000,"Linear")
		peda = interpolateBetween(peda,0,0,80,0,0,tickCount/1000,"Linear")
	end
	

	
	exports["blur"]:dxDrawBluredRectangle(0,0,x,y,tocolor(255,255,255,255*sCam.alpha))
	
	--local length = dxGetTextWidth(texts.server_name,1,font)
	--dxDrawText(texts.server_name,(x/2)-500-130,(y/2)-250-70,1000,500,tocolor(160,82,45,255*sCam.alpha),1,font,"left","top",false,false,false,true)
	
	dxDrawRectangle((x/2)-500,(y/2)-250,1000,500,tocolor(255, 69, 0,30*sCam.alpha))
	dxDrawRectangle((x/2)-500,(y/2)-250,20,500,tocolor(255, 69, 0,30*sCam.alpha))
	dxDrawRectangle((x/2)-500+300,(y/2)-250+20,5,500-40,tocolor(255, 69, 0,30*sCam.alpha))
	dxDrawRectangle((x/2)-500+570,(y/2)-250+20,5,500-40,tocolor(255, 69, 0,30*sCam.alpha))
	dxDrawRectangle((x/2)-500+305,(y/2)-250+160,265,5,tocolor(255, 69, 0,30*sCam.alpha))
	dxDrawRectangle((x/2)+500-20,(y/2)-250,20,500,tocolor(255, 69, 0,30*sCam.alpha))
	dxDrawRectangle((x/2)-500+20,(y/2)-250,1000-40,20,tocolor(255, 69, 0,30*sCam.alpha))	
	dxDrawRectangle((x/2)-500+20,(y/2)+250-20,1000-40,20,tocolor(255, 69, 0,30*sCam.alpha))	
	
	dxDrawRectangle((x/2)-140-10,(y/2)+100-175,200,24,tocolor(255,255,255,10*sCam.alpha))		
	dxDrawRectangle((x/2)-140-10,(y/2)+100-135,80,24,tocolor(255,255,255,10*sCam.alpha))	
	dxDrawRectangle((x/2)-140-10,(y/2)+100-55,80,24,tocolor(255,255,255,10*sCam.alpha))	
	dxDrawRectangle((x/2)-140-10,(y/2)+100-95,80,24,tocolor(255,255,255,10*sCam.alpha))
	
	local colete = getPedArmor(localPlayer) or "0"
	local id = getElementData(localPlayer, "char:id") or "Sem ID"
	local level = getElementData(localPlayer, "Sys:Level") or "0"
	local exp = getElementData(localPlayer, "LSys:EXP") or "1000"

	
	
	local name = getElementData(localPlayer, "char:name") or "Sem nome"--getPlayerName(localPlayer)
	local leng = dxGetTextWidth(name:gsub(("#%x%x%x%x%x%x"), ""),1,font2)
	local lengr
	if leng >= 200 then 
		leng = 200
	end
	local cx,cy = (x/2)-50,(y/2)-82
	dxDrawClipColorText(
	
	name, cx-leng/2, cy, cx-leng/2+leng, cy+h2,
	
	tocolor(255,255,225,255*sCam.alpha),1,font2,"left","top",true,false,false,true,255*sCam.alpha)

	dxDrawText("/discord",(x/2)-500+420-10-dxGetTextWidth("Discord",1,font2)/2,(y/2)-250+10+h2/2,(x/2)-500+420-10+dxGetTextWidth("Discord",1,font2),(y/2)-250+10+h2,tocolor(255,255,255,255*sCam.alpha),1,font2,"left","top",false,false,false,true)	
	dxDrawText("/facebook",(x/2)-500+420-10-dxGetTextWidth("Discord",1,font2)/2,(y/2)-250+55+h2/2,(x/2)-500+420-10+dxGetTextWidth("Discord",1,font2),(y/2)-250+55+h2,tocolor(255,255,255,255*sCam.alpha),1,font2,"left","top",false,false,false,true)		
	dxDrawText("/youtube",(x/2)-500+420-10-dxGetTextWidth("Discord",1,font2)/2,(y/2)-250+100+h2/2,(x/2)-500+420-10+dxGetTextWidth("Discord",1,font2),(y/2)-250+100+h2,tocolor(255,255,255,255*sCam.alpha),1,font2,"left","top",false,false,false,true)	
	
	dxDrawText(""..id,(x/2)-500+400-10-dxGetTextWidth(""..id,1.5,"arial")/2,(y/2)-250+205+h4/2,(x/2)-500+400-10+dxGetTextWidth(""..id,1.5,"arial"),(y/2)-250+205+h4,tocolor(255,255,225,255*sCam.alpha),1.5,"arial","left","top",false,false,false,true)	
	dxDrawText(""..level,(x/2)-500+399-10-dxGetTextWidth(""..level,1.5,"arial")/2,(y/2)-250+245+h4/2,(x/2)-500+399-10+dxGetTextWidth("XP: #ffffff"..level,1.5,"arial"),(y/2)-250+250+h4,tocolor(255,255,225,255*sCam.alpha),1.5,"arial","left","top",false,false,false,true)	
	dxDrawText(""..exp,(x/2)-500+399-10-dxGetTextWidth(""..exp,1.5,"arial")/2,(y/2)-250+285+h4/2,(x/2)-500+399-10+dxGetTextWidth("1000",1.5,"arial"),(y/2)-250+280+h4,tocolor(255,255,225,255*sCam.alpha),1.5,"arial","left","top",false,false,false,true)	

	local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second
	if (hours < 10) then
		hours = "0"..hours
	end
	if (minutes < 10) then
		minutes = "0"..minutes
	end
	if (seconds < 10) then
		seconds = "0"..seconds
	end
	dxDrawText(hours ..":"..minutes,(x/2)-500+750-15,(y/2)-250+380+h3/2,(x/2)-500+720-15+dxGetTextWidth(hours ..":"..minutes,2,"arial"),(y/2)-250+380+h6,tocolor(255,255,255,255*sCam.alpha),2,"arial","left","top",false,false,false,true)	
	
	local monthday = getDate()

	dxDrawText(monthday,(x/2)-500+690,(y/2)-250+420+h3/2,(x/2)-500+600+dxGetTextWidth(monthday,2,"arial"),(y/2)-250+420+h6,tocolor(255,255,255,255*sCam.alpha),2,"arial","left","top",false,false,false,true)	

	dxDrawText("Pessoas online: "..#getElementsByType("player").."",(x/2)-500+850-dxGetTextWidth("Numero de pessoas online: "..#getElementsByType("player").."",2,"arial")/2,(y/2)-240+h2/2,(x/2)-500+850+dxGetTextWidth("Numero de players online: "..#getElementsByType("player").."",2,"arial"),(y/2)-240+h2,tocolor(255,255,255,255*sCam.alpha),2,"arial","left","top",false,false,false,true)


	dxDrawRectangle((x/2)-140-10,(y/2)+100-2,200,5,tocolor(255,255,255,10*sCam.alpha))			
	dxDrawRectangle((x/2)-140-10,(y/2)+150-12,200,5,tocolor(255,255,255,10*sCam.alpha))
	dxDrawRectangle((x/2)-140-10,(y/2)+204-29,200,5,tocolor(255,255,255,10*sCam.alpha))
	dxDrawRectangle((x/2)-140-10,(y/2)+250-39,200,5,tocolor(255,255,255,10*sCam.alpha))
	
	local fome = getElementData(localPlayer, "char:hunger") or "20"
	local sede = getElementData(localPlayer, "char:thirst") or "100"
	local vida = getElementHealth(localPlayer) or "50"
	local colete = getPedArmor(localPlayer) or "30"	
	
	dxDrawRectangle((x/2)-140-10,(y/2)+100-2,(tonumber(fome)*200)/100,5,tocolor(255,255,0,255*sCam.alpha))			
	dxDrawRectangle((x/2)-140-10,(y/2)+150-12,(tonumber(sede)*200)/100,5,tocolor(99, 184, 255,255*sCam.alpha))
	dxDrawRectangle((x/2)-140-10,(y/2)+204-29,(tonumber(vida)*200)/100,5,tocolor(255, 0, 0,255*sCam.alpha))
	dxDrawRectangle((x/2)-140-10,(y/2)+250-39,(tonumber(colete)*200)/100,5,tocolor(0, 255, 0,255*sCam.alpha))
	
	dxDrawImage((x/2)-500+360-28-10,(y/2)-250+176,24,24,deCrypted["user.png"],0,0,0,tocolor(255,255,255,255*sCam.alpha))	
	dxDrawImage((x/2)-500+360-28-10,(y/2)-250+216,24,24,deCrypted["cartao.png"],0,0,0,tocolor(255,255,255,255*sCam.alpha))		
	dxDrawImage((x/2)-500+360-28-10,(y/2)-250+256,24,24,deCrypted["xp.png"],0,0,0,tocolor(255,255,255,255*sCam.alpha))		
	dxDrawImage((x/2)-500+360-28-10,(y/2)-250+296,24,24,deCrypted["level.png"],0,0,0,tocolor(255,255,255,255*sCam.alpha))		
	dxDrawImage((x/2)-500+360-28-10,(y/2)-250+340,24,24,deCrypted["han.png"],0,0,0,tocolor(255,255,255,255*sCam.alpha))	
	dxDrawImage((x/2)-500+360-28-10,(y/2)-250+378,24,24,deCrypted["agua.png"],0,0,0,tocolor(255,255,255,255*sCam.alpha))	
	dxDrawImage((x/2)-500+360-28-10,(y/2)-250+416,24,24,deCrypted["vida.png"],0,0,0,tocolor(255,255,255,255*sCam.alpha))
	dxDrawImage((x/2)-500+360-28-10,(y/2)-250+450,24,24,deCrypted["colete.png"],0,0,0,tocolor(255,255,255,255*sCam.alpha))

	dxDrawImage((x/2)-500+360-32-10,(y/2)-250+30,32,32,deCrypted["discord.png"],0,0,0,tocolor(255,255,255,255*sCam.alpha))	
	dxDrawImage((x/2)-500+360-32-10,(y/2)-250+75,32,32,deCrypted["facebook.png"],0,0,0,tocolor(255,255,255,255*sCam.alpha))
	dxDrawImage((x/2)-500+360-32-10,(y/2)-250+120,32,32,deCrypted["youtube.png"],0,0,0,tocolor(255,255,255,255*sCam.alpha))
		
	dxDrawImage((x/2)-500+650-52,(y/2)-250+50,350,350,deCrypted["logo.png"],0,0,0,tocolor(255, 69, 0,255*sCam.alpha))
	dxDrawImage((x/2)-500+650-52,(y/2)-250+50,350,350,deCrypted["5.png"],0,0,0,tocolor(255, 69, 0,255*sCam.alpha))
	
	if not myElement or not myObject then return end
	local projPosX, projPosY = guiGetPosition(guiWindow,true)
	local projSizeX, projSizeY = guiGetSize(guiWindow, true)
	
	exports.object_preview:setRotation(myObject,myRotation[1], myRotation[2], myRotation[3])
	exports.object_preview:setProjection(myObject,projPosX, projPosY, projSizeX, projSizeY, true, true)
	exports.object_preview:setAlpha(myObject,peda)
	
	 
	if peda == 255 and not del1 then
		del1 = true
	elseif peda == 80 and not del2 then
		del2 = true
	end
	
	if del2 and del3 then
		destroyDesign()
		setElementPosition(myElement,0, 0, 0)
		del3 = false
		sCam.dash = false
		showChat(true)
	end
	end
end


function cpl.tab(key,keystate)
	--if getElementData(localPlayer,"loggedin") then
	if keystate == "down" then
		sCam.dash = true
		sCam.x, sCam.y, sCam.z, sCam.lx, sCam.ly, sCam.lz = getCameraMatrix() 
		sCam.tickCount = getTickCount()
		sCam.anim = true
		setElementModel(myElement, getElementModel(getLocalPlayer()))
		setElementDimension(myElement,getElementDimension(localPlayer))
		setElementInterior(myElement,getElementInterior(localPlayer))
		del1 = false
		del2 = false
		del3 = true
		for theType=0, 17 do
			local texture, model = getPedClothes( localPlayer, theType )
			if texture then
				addPedClothes(myElement, texture, model, theType)
			end
		end
		showChat(false)
		if not on then
			createDrawDesign()
		end
		elseif keystate == "up" then	 
		sCam.tickCount = getTickCount()
		sCam.anim = false
	end

end


