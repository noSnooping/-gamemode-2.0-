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
	renderTarget = dxCreateRenderTarget(1024, 1024, true)
	redcircle3 = deCrypted["logo.png"]
	dxSetRenderTarget(renderTarget, true)
	dxDrawImage(0, 0, 1024, 1024, redcircle3, 0, 0, 0, tocolor(255,255,255,255))
	dxSetRenderTarget()
end

function cpl.handleMinimize()
    if renderTarget and isElement(renderTarget) then destroyElement(renderTarget) end
	--if redcircle3 and isElement(redcircle3) then destroyElement(redcircle3) end
end

cpl.init_Gamemode = function()
	--triggerServerEvent("join:gamemode",resourceRoot)
	cpl.handleRestore()
	addEventHandler("onClientRestore",root,cpl.handleRestore, false)
	addEventHandler("onClientMinimize", root, cpl.handleMinimize, false)
	addEventHandler("onClientRender", root, cpl.cicle, true,"high+10")
end

cpl.init_Gamemode_reset = function(bool)
	unloadDSG_Download() 
	--if not bool then triggerServerEvent("quit:gamemode",resourceRoot) end
	removeEventHandler("onClientRestore",root,cpl.handleRestore, false)
	removeEventHandler("onClientMinimize", root, cpl.handleMinimize, false)
	removeEventHandler("onClientRender", root, cpl.cicle, true,"high+10")
    if renderTarget and isElement(renderTarget) then destroyElement(renderTarget) end
	--if redcircle3 and isElement(redcircle3) then destroyElement(redcircle3) end
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

cpl.cicle = function()
	local markers = getElementsByType("marker", root, true)
	local nextElement = function(_index) local index=0 return function() index=index+1 if _index[index] then return index, _index[index] end end end
	for _,marker in nextElement(markers) do	
	if getMarkerType(marker) == "cylinder" then
		local x, y, z = getElementPosition(marker)	
		local x2, y2, z2 = getElementPosition(localPlayer)		
		local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
		local markerSize = getMarkerSize(marker)/2
		local R, G, B, A = getMarkerColor(marker)
		if A > 0 then
		setMarkerColor(marker, R, G, B, 1)  		
		if(distanceBetweenPoints < 50) then
			local ground = getGroundPosition(x, y, z)	
			if renderTarget and isElement(renderTarget) then
				dxDrawMaterialLine3D(x+markerSize, y+markerSize, ground+0.05, x-markerSize, y-markerSize, ground+0.05, renderTarget, markerSize*2.8,tocolor(R, G, B, 255),x, y, z )
			end
			end
			end
		end
   	end
end 


