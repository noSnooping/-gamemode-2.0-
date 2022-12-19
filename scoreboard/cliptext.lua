--[[-----------------------------------------------
----script feito por Lucas Damaceno(anony)
----em 2020. você pode usá-lo e editá-lo apenas o créditos são meus!
----youtube:https://www.youtube.com/channel/UCf7N0XUAHmOLpRO4MfXTHaQ?view_as=subscriber
--]]-----------------------------------------------

--left texts right texts are not suported
-- by anony .0.1rt

local typeHex = "#%x%x%x%x%x%x"
local contColorsHex              = function(text) local _unt = 0 for _ in text:gmatch(typeHex) do _unt = _unt+1 end return _unt end

dxDrawClipColorText             = function(text,left,top,Width,height,color,fontsize,font,alignX,alignY,clip,wordBreak,postGUI,colorCoded,A)
    local criptSTR               = {}
    local text                   = text
    local contHex                = contColorsHex(text)
    local widthSTR               = 0
    local R, G, B, A                = 255,255,255,A or 255
    local _unt = 0
    repeat _unt = _unt+1	
        if _unt == 1 then	
        	if text:find(typeHex) then
                criptSTR[_unt]          = {
                textpart                = text:sub(1, text:find(typeHex)-1),
                color                   = text:sub(text:find(typeHex),text:find(typeHex)+6), 
                pos                     = text:find(typeHex)+7,
                wid                     = dxGetTextWidth(text:sub(1, text:find(typeHex)-1),1,font)
                }
            else
                criptSTR[contHex+1]     = {
                textpart                = text,
                color                   = "#FFFFFF",
                pos                     = 1,
                wid                     = dxGetTextWidth(text:sub(1, text:len()),1,font)
                }
            end
        else
            if _unt == contHex+1 then
                text                   = text:sub(criptSTR[contHex+1-1].pos, text:len())
                criptSTR[contHex+1]    = {
                textpart               = text,
                color                  = "#FFFFFF", 
                pos                    = 1,
                wid                    = dxGetTextWidth(text:sub(1, text:len()),1,font)+criptSTR[_unt-1].wid
                }
            else
                text                   = text:sub(criptSTR[_unt-1].pos, text:len())
                criptSTR[_unt]            = {
                textpart               = text:sub(1, text:find(typeHex)-1),
                color                  = text:sub(text:find(typeHex),text:find(typeHex)+6),
                pos                    = text:find(typeHex)+7,
                wid                    = dxGetTextWidth(text:sub(1, text:find(typeHex)-1),1,font)+criptSTR[_unt-1].wid
                }
            end
        end

        if criptSTR[_unt].wid then
            widthSTR                   = criptSTR[_unt].wid-dxGetTextWidth(criptSTR[_unt].textpart:gsub(typeHex, ""),1,font)
            if _unt > 1 then
                R, G, B                = getColorFromString(criptSTR[_unt-1].color)
            end 
        end
        --if alignX == "left" then
            dxDrawText(criptSTR[_unt].textpart,left+widthSTR,top,Width,height,tocolor( R, G, B, A ),fontsize,font,alignX,alignY,clip,wordBreak,postGUI,colorCoded)  
        --elseif alignX == "right" then
        --    dxDrawText(criptSTR[_unt].textpart,left-widthSTR,top,Width,height,tocolor( R, G, B, 255 ),fontsize,font,alignX,alignY,clip,wordBreak,postGUI,colorCoded)  
        --end
    until(_unt == contHex+1)
end