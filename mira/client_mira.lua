local cpl = {}
cpl.shader = nil
cpl.siteM16 = nil

local deCrypted = {}
local modelsDownloaded = {}
local models = {
	"siteM16.png"
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

function cpl.handleMinimize()
	engineRemoveShaderFromWorldTexture(cpl.shader,"siteM16")
    --if cpl.siteM16 and isElement(cpl.siteM16) then destroyElement(cpl.siteM16) end
    if cpl.shader and isElement(cpl.shader) then destroyElement(cpl.shader) end
end

function cpl.handleRestore()
    --if cpl.siteM16 and isElement(cpl.siteM16) then destroyElement(cpl.siteM16) end
    if cpl.shader and isElement(cpl.shader) then destroyElement(cpl.shader) end
    cpl.shader = dxCreateShader(
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
	cpl.siteM16 = deCrypted["siteM16.png"]
	dxSetShaderValue(cpl.shader,"Tex0",cpl.siteM16)
	engineApplyShaderToWorldTexture(cpl.shader,"siteM16")
end

cpl.init_Gamemode = function()
	--triggerServerEvent("join:gamemode",resourceRoot) 
	cpl.handleRestore()
	addEventHandler("onClientRestore", root, cpl.handleRestore)
	addEventHandler("onClientMinimize", root, cpl.handleMinimize)
end

cpl.init_Gamemode_reset = function(bool)
	unloadDSG_Download() 
	--if not bool then triggerServerEvent("quit:gamemode",resourceRoot) end	
    if cpl.siteM16 and isElement(cpl.siteM16) then engineRemoveShaderFromWorldTexture(cpl.shader,"siteM16") end
    if cpl.shader and isElement(cpl.shader) then destroyElement(cpl.shader) end
	removeEventHandler("onClientRestore", root, cpl.handleRestore)
	removeEventHandler("onClientMinimize", root, cpl.handleMinimize)
end

addEvent("join:gamemode", true)
addEvent("quit:gamemode", true)

addEventHandler("join:gamemode", localPlayer, function()
	loadDSG_Download()
end)

addEventHandler("quit:gamemode", localPlayer, function()
	cpl.init_Gamemode_reset()
end)

addEventHandler("onClientResourceStop",resourceRoot,function()
	cpl.init_Gamemode_reset(true)
    if cpl.siteM16 and isElement(cpl.siteM16) then destroyElement(cpl.siteM16) end
	if cpl.shader and isElement(cpl.shader) then destroyElement(cpl.shader) end
end)
