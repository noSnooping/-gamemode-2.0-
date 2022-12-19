--[[-----------------------------------------------
----script feito por Lucas Damaceno(anony)
----em 2020. você pode usá-lo e editá-lo apenas o créditos são meus!
----youtube:https://www.youtube.com/channel/UCf7N0XUAHmOLpRO4MfXTHaQ?view_as=subscriber
--]]-----------------------------------------------
local cpl = {}

addEvent("join:gamemode", true)
addEvent("quit:gamemode", true)

local deCrypted = {}
local modelsDownloaded = {}
local models = {
	"logo.png"
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

local renderTarget 
local redcircle3 

function cpl.handleRestore()
    if renderTarget and isElement(renderTarget) then destroyElement(renderTarget) end
	--if redcircle3 and isElement(redcircle3) then destroyElement(redcircle3) end
	renderTarget = dxCreateRenderTarget(398, 398, true)
	redcircle3 = deCrypted["logo.png"]
	dxSetRenderTarget(renderTarget, true)
	dxDrawImage(0, 0, 398, 398, redcircle3, 0, 0, 0, tocolor(0,255,0,255))
	dxSetRenderTarget()
end

function cpl.handleMinimize()
    if renderTarget and isElement(renderTarget) then destroyElement(renderTarget) end
	--if redcircle3 and isElement(redcircle3) then destroyElement(redcircle3) end
end

cpl.showIDs = false
cpl.setT = false

function cpl.showIDS(key,keyState)
	if keyState == "down" then
		cpl.showIDs = true
		if not setT then
			if not isTimer(setT) then
				setT = setTimer(function() setT = false end,7000,1)
				triggerServerEvent("showMIds",localPlayer)
			end	
		end
	else
		cpl.showIDs = false
	end
end

cpl.init_Gamemode = function()
	triggerServerEvent("join:gamemode",resourceRoot)
	cpl.handleRestore()
	addEventHandler("onClientRestore",root,cpl.handleRestore, false)
	addEventHandler("onClientMinimize", root, cpl.handleMinimize, false)
	addEventHandler("onClientRender", root, cpl.cicle, true,"high+10")
	bindKey("F12","both",cpl.showIDS)
end

cpl.init_Gamemode_reset = function(bool)
	unloadDSG_Download() 
	if not bool then triggerServerEvent("quit:gamemode",resourceRoot) end
	removeEventHandler("onClientRestore",root,cpl.handleRestore, false)
	removeEventHandler("onClientMinimize", root, cpl.handleMinimize, false)
	removeEventHandler("onClientRender", root, cpl.cicle, true,"high+10")
    if renderTarget and isElement(renderTarget) then destroyElement(renderTarget) end
	--if redcircle3 and isElement(redcircle3) then destroyElement(redcircle3) end
	unbindKey("F12","both",cpl.showIDS)
end

addEventHandler("join:gamemode", localPlayer, function()
	loadDSG_Download()
end)

addEventHandler("quit:gamemode", localPlayer, function()
	cpl.init_Gamemode_reset()
end)

addEventHandler("onClientResourceStop",getResourceRootElement(),function()
	cpl.init_Gamemode_reset(true)
    if renderTarget and isElement(renderTarget) then destroyElement(renderTarget) end
	if redcircle3 and isElement(redcircle3) then destroyElement(redcircle3) end
end)

local Inventory = {--[[Função feita por anony]]}
Inventory.drawShadowText = function(text,x,y,w,h,color,scale,font,...)
	local bit = function(bit32) 
		return bitExtract(bit32, 16, 8 ), bitExtract(bit32, 8, 8 ), bitExtract(bit32, 0, 8 ),bitExtract(bit32, 24, 8 )
	end 
	local _,_,_,alpha = bit(color)
	--dxDrawText(text:gsub ("#%x%x%x%x%x%x", ""),x-1,y,w,h,tocolor(0,0,0,alpha),scale,font,...)
	--dxDrawText(text:gsub ("#%x%x%x%x%x%x", ""),x,y-1,w,h,tocolor(0,0,0,alpha),scale,font,...)
	--dxDrawText(text:gsub ("#%x%x%x%x%x%x", ""),x+1,y,w,h,tocolor(0,0,0,alpha),scale,font,...)
	--dxDrawText(text:gsub ("#%x%x%x%x%x%x", ""),x,y+1,w,h,tocolor(0,0,0,alpha),scale,font,...)
	dxDrawText(text,x,y,w,h,color,scale,font,...)
end

cpl.cicle = function()
	local distance = distance or 20
	local height = height or 1
	local elements = getElementsByType("player",root,true)
	local nextElement = function(_index) local index=0 return function() index=index+1 if _index[index] then return index, _index[index] end end end
	for _,v in nextElement(elements) do
		local distance = getElementData(v,"cpl.voiceDistance") or distance
		if v and isElement(v) then
			local x, y, z = getElementPosition(v)
			local x2, y2, z2 = getCameraMatrix()
			if (isLineOfSightClear(x, y, z+2, x2, y2, z2)) then
				local sx, sy = getScreenFromWorldPosition(x, y, z+height)
				if(sx) and (sy) then
					local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
					if(distanceBetweenPoints < distance) then
						local ID = getElementData(v, "char:id") or "N/A"
			  			if not ID then return end ID = ID.." #ffff00" if getElementData(v,"invincible") then if getElementData(localPlayer,"invincible") then ID = "#7CFC00STAFF-"..ID else ID = "#7CFC00STAFF" end end
			  			local CorTag = tocolor(255, 255, 255, 255)
						if (not getElementData(v, "invisible")) or getElementData(localPlayer,"invincible") then
						if getElementData(v, "active_voice") then
							CorTag = tocolor(0, 255, 0, 255)
							local x, y, z = getElementPosition(v)																	
							if renderTarget and isElement(renderTarget) then
								if not getElementData(v, 'deadped') then 
									dxDrawMaterialLine3D(x+1, y+1, z-0.95, x-1, y-1, z-0.95, renderTarget, 1*2.7,tocolor(255, 255, 255, 255),x, y, z)
								end
							end
						end
						if cpl.showIDs or getElementData(localPlayer,"invincible") or getElementData(v,"invincible") then
							Inventory.drawShadowText(ID, sx+2, sy+2, sx, sy, CorTag, 2, "default-bold", "center", "center",false,false,false,true)
						end
						end
					end
				end
			end
		end
   	end
end 


