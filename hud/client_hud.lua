local cpl = {}
local screenW,screenH = guiGetScreenSize()

local deCrypted = {}
local modelsDownloaded = {}
local models = {
	"1.png",
	"2.png",
	"3.png",
	"card.png",
	"maleta.png",
	"microfone.png",
    "silenciado.png",
	"money.png",
	"radio.png",
	"crime.png" 
}

function loadDSG_Download()
	modelsDownloaded = {}
    for i,model in ipairs(models) do
        downloadFile(model)
    end
end

local crypt = "CPH"
--local crypt = passwordHash(crypt)

function crypt_protection(theFile)
	local file = fileOpen(theFile) 
	local data = fileRead(file, fileGetSize(file)) 
	local newFileName = theFile:gsub(".png", ".yuv")
	
	deCrypted[theFile] = dxCreateTexture(data, "dxt5", false, "wrap")
	
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
		local newFileName = model:gsub(".png", ".yuv")
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

local voiceImage = "silenciado.png"
local voiceText = "Microfone desligado"
local radioImage = "radio.png"
local radioText = "Copom desligado"

local FPSLimit, lastTick, framesRendered, FPS = 100, getTickCount(), 0, 0

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


local Inventory = {--[[Função feita por anony]]}
Inventory.drawShadowText = function(text,x,y,w,h,color,scale,font,...)
    local bit = function(bit32) 
        return bitExtract(bit32, 16, 8 ), bitExtract(bit32, 8, 8 ), bitExtract(bit32, 0, 8 ),bitExtract(bit32, 24, 8 )
    end 
    local _,_,_,alpha = bit(color)
   -- dxDrawText(text:gsub ("#%x%x%x%x%x%x", ""),x-1,y,w,h,tocolor(25,25,25,alpha),scale,font,...)
    --dxDrawText(text:gsub ("#%x%x%x%x%x%x", ""),x,y-1,w,h,tocolor(25,25,25,alpha),scale,font,...)
    --dxDrawText(text:gsub ("#%x%x%x%x%x%x", ""),x+1,y,w,h,tocolor(25,25,25,alpha),scale,font,...)
    --dxDrawText(text:gsub ("#%x%x%x%x%x%x", ""),x,y+1,w,h,tocolor(25,25,25,alpha),scale,font,...)
    dxDrawText(text,x,y,w,h,color,scale,font,...)
end

local shader
local renderTarget

function cpl.handleMinimize()
    if renderTarget and isElement(renderTarget) then destroyElement(renderTarget) end
end

function cpl.team_logo()
    if renderTarget and isElement(renderTarget) then destroyElement(renderTarget) end
	if shader and isElement(shader) then destroyElement(shader) end
    shader = dxCreateShader(
	[[
	texture Tex0; 
	technique TexReplace 
	{ 
    pass P0 
    { 
        Texture[0] = Tex0; 
    } 
	} 
	]]
	)
    renderTarget = dxCreateRenderTarget(100,100,true)
    dxSetShaderValue(shader,'Tex0',renderTarget)
    dxSetRenderTarget(renderTarget,true)
	--dxSetBlendMode("modulate_add")
    dxDrawImage(0,0,100,100,deCrypted["1.png"],0,0,0,tocolor(255, 255, 255,255))
    dxDrawImage(0,0,100,100,deCrypted["2.png"],0,0,0,tocolor(255, 255, 255,255))
    dxDrawImage(0,0,100,100,deCrypted["3.png"],0,0,0,tocolor(255, 255, 255,255))
	--dxSetBlendMode("blend")  
    dxSetRenderTarget()   
end

function cpl.handleRestore()
    --cpl.team_logo()
end

cpl.init_Gamemode = function()
	--triggerServerEvent("join:gamemode",resourceRoot)
	cpl.count = 0
	cpl.handleRestore()
	--addEventHandler("onClientRestore", root, cpl.handleRestore)
	--addEventHandler("onClientMinimize", root, cpl.handleMinimize)
	addEventHandler("onClientHUDRender", root ,cpl.f_hud, true,"high+10")
end

cpl.init_Gamemode_reset = function(bool)
	--if not bool then triggerServerEvent("quit:gamemode",resourceRoot) end
	unloadDSG_Download()
	cpl.count = nil
	if renderTarget and isElement(renderTarget) then destroyElement(renderTarget) end
	if shader and isElement(shader) then destroyElement(shader) end
	--removeEventHandler("onClientRestore", root, cpl.handleRestore)
	--removeEventHandler("onClientMinimize", root, cpl.handleMinimize)
	removeEventHandler("onClientHUDRender", root ,cpl.f_hud, true,"high+10")
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



function cpl.f_hud( ... )
    -- if not getElementData(localPlayer,"loggedin") then return end
	if (not isPlayerMapVisible()) then
    local currentTick = getTickCount()
    local elapsedTime = currentTick - lastTick
    if elapsedTime >= 1000 then
        FPS = framesRendered 
        lastTick = currentTick
        framesRendered = 2
    else
        framesRendered = framesRendered + 1
    end
    if FPS > FPSLimit then
        FPS = FPSLimit
    end

    local PING = getPlayerPing( getLocalPlayer( ) ) 

 	local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second
	-- Make sure to add a 0 to the front of single digits.
	if (hours < 10) then
		hours = "0"..hours
	end
	if (minutes < 10) then
		minutes = "0"..minutes
	end
	if (seconds < 10) then
		seconds = "0"..seconds
	end

    local leng = dxGetTextWidth( ""..getDate().." | Horário: "..hours..":"..minutes..":"..seconds.." | Fps: "..tostring(FPS).."  |  Ping: "..tostring(PING).." ms |" , 1, "clear" )
    local sX, sY = guiGetScreenSize()
    dxDrawText( "#ffffff"..getDate().." #ffffff|#ffffff Horário: "..hours..":"..minutes..":"..seconds.." #ffffff|#ffffff Fps: "..tostring(FPS).."  #ffffff|#ffffff  Ping: "..tostring(PING).." #ffffff|#ffffff", sX-67-leng, sY+2, 10, sY-16, tocolor(255,255,255,120), 1, "clear", "left", "center", false, false, false, true )
	end
end


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