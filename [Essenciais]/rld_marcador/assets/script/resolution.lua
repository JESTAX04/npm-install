screen = {guiGetScreenSize ()}
local resolution = {1366, 768}
resW, resH = 1366, 768
local x, y = screen[1] / resolution[1], screen[2] / resolution[2]

function aToR (X, Y, sX, sY)
    local Px = (Global and (Global.PosX or resolution[1]) or resolution[1])
    local Falta = resolution[1] - X
    local X = Px - Falta
    local xd = X/resolution[1] or X
    local yd = Y/resolution[2] or Y
    local xsd = sX/resolution[1] or sX
    local ysd = sY/resolution[2] or sY
    return xd*screen[1], yd*screen[2], xsd*screen[1], ysd*screen[2]
end

local fontsDB = {}

_dxCreateFont = dxCreateFont
function dxCreateFont (path, size, ...)
    if not fontsDB[path] then
        fontsDB[path] = { }
    end
    if fontsDB[path][size] then
        return fontsDB[path][size]
    end
    local _, size, _, _ = aToR(0, size, 0, 0)
    fontsDB[path][size] = _dxCreateFont (path, size, ...)
    return fontsDB[path][size]
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

function createEventHandler (event, ...)
    addEvent (event, true)
    addEventHandler (event, ...)
end

function formatNumber (number)   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
end 