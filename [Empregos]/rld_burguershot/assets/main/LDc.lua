---[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedrooooo#1554
---]]

local x, y = guiGetScreenSize()

local fonts = {
    dxCreateFont('assets/fonts/medium.ttf', 12); 
    dxCreateFont('assets/fonts/regular.ttf', 10); 
    dxCreateFont('assets/fonts/regular.ttf', 12); 
    dxCreateFont('assets/fonts/medium.ttf', 17); 
}

function drawEnterService()
    local startX, startY = x / 2 - 250, y / 2 - 112
    local alpha = interpolateBetween(interpolate[1], 0, 0, interpolate[2], 0, 0, ((getTickCount() - tick) / 500), 'Linear')
    
    drawBorder(10, startX, startY, 500, 225, tocolor(83, 87, 89, alpha))
    dxDrawText('Gerenciamento de turnos Burguer Shot', startX + 18, startY + 20, 0, 0, tocolor(255, 255, 255, alpha * 0.8), 1, fonts[1])
    dxDrawText('X', startX + 470, startY + 20, 12, 23, (isMouseInPosition(startX + 470, startY + 20, 12, 23) and tocolor(255, 255, 255, alpha * 0.8) or tocolor(255, 255, 255, alpha * 0.6)), 1, fonts[1])

    dxDrawText('Para iniciar ou finalizar seu turno é necessário passar por essa\netapa, escolha qual ação deseja realizar para prosseguir com seu\ndia normalmente.', startX + 18, startY + 59, 0, 0, tocolor(255, 255, 255, alpha * 0.6), 1, fonts[2])

    drawBorder(6, startX + 17, startY + 129, 465, 40, tocolor(68, 69, 70, alpha))
    dxDrawText('Iniciar serviço', (startX + 250) - (dxGetTextWidth('Iniciar serviço', 1, fonts[2]) / 2), startY + 140, 0, 0, tocolor(255, 255, 255, alpha * 0.6), 1, fonts[2])

    if (isMouseInPosition(startX + 17, startY + 129, 465, 40)) then 
        if not (startTick) then startTick = getTickCount() end 
        local animation = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - startTick) / 500), 'Linear')

        drawBorder(6, startX + 17, startY + 129, 465, 40, tocolor(154, 196, 229, animation))
        dxDrawText('Iniciar serviço', (startX + 250) - (dxGetTextWidth('Iniciar serviço', 1, fonts[2]) / 2), startY + 140, 0, 0, tocolor(31, 31, 31, animation), 1, fonts[2])
    else
        startTick = nil 
    end 

    drawBorder(6, startX + 17, startY + 174, 465, 40, tocolor(68, 69, 70, alpha))
    dxDrawText('Finalizar serviço', (startX + 250) - (dxGetTextWidth('Finalizar serviço', 1, fonts[2]) / 2), startY + 185, 0, 0, tocolor(255, 255, 255, alpha * 0.6), 1, fonts[2])

    if (isMouseInPosition(startX + 17, startY + 174, 465, 40)) then 
        if not (finishTick) then finishTick = getTickCount() end 
        local animation = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - finishTick) / 500), 'Linear')

        drawBorder(6, startX + 17, startY + 174, 465, 40, tocolor(154, 196, 229, animation))
        dxDrawText('Finalizar serviço', (startX + 250) - (dxGetTextWidth('Finalizar serviço', 1, fonts[2]) / 2), startY + 185, 0, 0, tocolor(31, 31, 31, animation), 1, fonts[2])
    else
        finishTick = nil 
    end 
end

addEventHandler('onClientClick', root, 
    function(b, s)
        if (b == 'left' and s == 'down') then 
            if (isEventHandlerAdded('onClientRender', root, drawEnterService)) then
                local startX, startY = x / 2 - 250, y / 2 - 112
                if (isMouseInPosition(startX + 470, startY + 20, 12, 23)) then 
                    removeEnterService()    
                elseif (isMouseInPosition(startX + 17, startY + 129, 465, 40)) then
                    triggerServerEvent('onPlayerInteractBurguerShotService', localPlayer, localPlayer, true)
                elseif (isMouseInPosition(startX + 17, startY + 174, 465, 40)) then
                    triggerServerEvent('onPlayerInteractBurguerShotService', localPlayer, localPlayer, false) 
                end 
            end
        end
    end
)

addEvent('onClientDrawBurguerShotService', true)
addEventHandler('onClientDrawBurguerShotService', root, 
    function()
        if not (isEventHandlerAdded('onClientRender', root, drawEnterService)) then 
            tick, interpolate = getTickCount(), {0, 255}
            addEventHandler('onClientRender', root, drawEnterService)
            showCursor(true)
        end
    end
)

function removeEnterService()
    if (isEventHandlerAdded('onClientRender', root, drawEnterService)) then 
        if (interpolate[1] == 0) then 
            tick, interpolate = getTickCount(), {255, 0}
            showCursor(false)
            setTimer(function()
                removeEventHandler('onClientRender', root, drawEnterService)
            end, 500, 1)
        end
    end
end

function drawFoodsMarkers()
    for food, v in pairs(config.foodsMarkers) do 
        local pos = {getElementPosition(localPlayer)}
        if (isLineOfSightClear(pos[1], pos[2], pos[3], v[1], v[2], v[3]) and getElementInterior(localPlayer) == 10) then 
            local sx, sy = getScreenFromWorldPosition(v[1], v[2], v[3])
            if (sx and sy) then 
                dxDrawImage(sx, sy, 166, 47, 'assets/images/foodBg.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
                dxDrawText(food, sx + 47, sy + 13, 0, 0, tocolor(255, 255, 255, 255 * 0.65), 1, fonts[3])
            end 
        end
    end
end 

addEvent('onClientDrawBurguerShotMarkers', true)
addEventHandler('onClientDrawBurguerShotMarkers', root, 
    function()
        addEventHandler('onClientRender', root, drawFoodsMarkers)
    end
)

addEvent('onClientRemoveBurguerShotMarkers', true)
addEventHandler('onClientRemoveBurguerShotMarkers', root, 
    function()
        removeEventHandler('onClientRender', root, drawFoodsMarkers)
    end
)


local progressBars = svgCreate(316, 15, 
    [[
        <svg width="316" height="15" viewBox="0 0 316 15" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="316" height="15" rx="5" fill="white"/>
        </svg>
    ]]
)

function drawProgressBar()
    local startX, startY = x / 2 - (346 / 2), y - 136 
    local alpha = 255
    local progress = interpolateBetween(0, 0, 0, 100, 0, 0, ((getTickCount() - loadTick) / 10000), 'Linear') 

    drawBorder(10, startX, startY, 346, 100, tocolor(42, 43, 48, alpha))
    dxDrawText(config.foodsTexts[loadFood], startX + 19, startY + 15, 0, 0, tocolor(255, 255, 255, alpha * 0.6), 1, fonts[2])
    dxDrawText(math.floor(progress)..'% Progresso', startX + 19, startY + 35, 0, 0, tocolor(255, 255, 255, alpha * 0.6), 1, fonts[4])

    dxDrawImage(startX + 19, startY + 72, 316, 15, progressBars, 0, 0, 0, tocolor(29, 30, 33, alpha))
    dxDrawImageSection(startX + 19, startY + 72, 316 * (progress / 100), 15, 0, 0, 316 * (progress / 100), 15, progressBars, 0, 0, 0, tocolor(154, 196, 229, alpha))

    if (progress == 100) then 
        removeEventHandler('onClientRender', root, drawProgressBar) 
    end
end

addEvent('onClientDrawBurgerShotLoad', true)
addEventHandler('onClientDrawBurgerShotLoad', root, 
    function(loadFood_)
        if not (isEventHandlerAdded('onClientRender', root, drawProgressBar)) then 
            loadTick, loadFood = getTickCount(), loadFood_
            addEventHandler('onClientRender', root, drawProgressBar) 
        end
    end
)

local sx, sy = (x / 1920), (y / 1080)
function burguerShotTray()
    local alpha = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - tick) / 500), 'Linear')

    dxDrawImage(sx * 302, sy * 380, sx * 436, sy * 320, 'assets/images/tray.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawImage(sx * 389, sy * 430, sx * 110, sy * 110, 'assets/images/burger.png', 0, 0, 0, ((foodsCache['Hamburguer'] and food ~= 'Hamburguer') and tocolor(255, 255, 255, alpha) or tocolor(255, 255, 255, alpha * 0.5)))
    dxDrawImage(sx * 509, sy * 487, sx * 110, sy * 110, 'assets/images/fries.png', 0, 0, 0, ((foodsCache['Batata Frita'] and food ~= 'Batata Frita') and tocolor(255, 255, 255, alpha) or tocolor(255, 255, 255, alpha * 0.5)))
    dxDrawImage(sx * 389, sy * 540, sx * 110, sy * 110, 'assets/images/sodaPop.png', 0, 0, 0, ((foodsCache['Refrigerante'] and food ~= 'Refrigerante') and tocolor(255, 255, 255, alpha) or tocolor(255, 255, 255, alpha * 0.5)))


    if not (movingFood) then 
        dxDrawImage(sx * 780, sy * 414, sx * 110, sy * 110, food == 'Batata Frita' and 'assets/images/fries.png' or food == 'Hamburguer' and 'assets/images/burger.png' or 'assets/images/sodaPop.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
    else
        local cx, cy = getCursorPosition()
        local mx, my = cx * x, cy * y 
        dxDrawImage(mx - (sx * 55), my - (sy * 55), sx * 110, sy * 110, food == 'Batata Frita' and 'assets/images/fries.png' or food == 'Hamburguer' and 'assets/images/burger.png' or 'assets/images/sodaPop.png', 0, 0, 0, tocolor(255, 255, 255, alpha))


        if not (getKeyState('mouse1')) then 

            if (isMouseInPosition(sx * 389, sy * 430, sx * 110, sy * 110) and food == 'Hamburguer') then 
                triggerServerEvent('onPlayerUpdateBurguerShotTray', localPlayer, localPlayer)
                removeEventHandler('onClientRender', root, burguerShotTray)
                showCursor(false)
            elseif (isMouseInPosition(sx * 509, sy * 487, sx * 110, sy * 110) and food == 'Batata Frita') then 
                triggerServerEvent('onPlayerUpdateBurguerShotTray', localPlayer, localPlayer)
                removeEventHandler('onClientRender', root, burguerShotTray)
                showCursor(false)
            elseif (isMouseInPosition(sx * 389, sy * 540, sx * 110, sy * 110) and food == 'Refrigerante') then 
                triggerServerEvent('onPlayerUpdateBurguerShotTray', localPlayer, localPlayer)
                removeEventHandler('onClientRender', root, burguerShotTray)
                showCursor(false)
            end

            movingFood = nil 
        end 
    end
end

addEventHandler('onClientClick', root, 
    function(b, s)
        if (b == 'left' and s == 'down') then 
            if (isEventHandlerAdded('onClientRender', root, burguerShotTray)) then 
                if (isMouseInPosition(sx * 780, sy * 414, sx * 110, sy * 110)) then 
                    movingFood = true    
                end
            end
        end
    end
)

addEvent('onClientDrawBurguerShotTray', true)
addEventHandler('onClientDrawBurguerShotTray', root, 
    function(foodsCache_, food_)
        if not (isEventHandlerAdded('onClientRender', root, burguerShotTray)) then 
            tick, foodsCache, food = getTickCount(), foodsCache_, food_ 
            addEventHandler('onClientRender', root, burguerShotTray)
            showCursor(true)
        end
    end
)

------------------------------------------------
function isMouseInPosition(x, y, w, h)
	if isCursorShowing() then
		local sx,sy = guiGetScreenSize()
		local cx,cy = getCursorPosition()
		local cx,cy = (cx*sx),(cy*sy)
		if (cx >= (x) and cx <= x+w) and (cy >= y and cy <= y+h) then
			return true
		end
	end
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

size = {}
function drawBorder ( radius, x, y, width, height, color, colorStroke, sizeStroke, postGUI )
    colorStroke = tostring(colorStroke)
    sizeStroke = tostring(sizeStroke)
    if (not size[height..':'..width]) then
        local raw = string.format([[
            <svg width='%s' height='%s' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <mask id='path_inside' fill='#FFFFFF' >
                    <rect width='%s' height='%s' rx='%s' />
                </mask>
                <rect opacity='1' width='%s' height='%s' rx='%s' fill='#FFFFFF' stroke='%s' stroke-width='%s' mask='url(#path_inside)'/>
            </svg>
        ]], width, height, width, height, radius, width, height, radius, colorStroke, sizeStroke)
        size[height..':'..width] = svgCreate(width, height, raw)
    end
    if (size[height..':'..width]) then
        dxDrawImage(x, y, width, height, size[height..':'..width], 0, 0, 0, color, postGUI)
    end
end

function formatNumber(number, sep)
	assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
	assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end
------------------------------------------------        