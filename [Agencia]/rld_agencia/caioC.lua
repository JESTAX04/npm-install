local screen = {guiGetScreenSize()}
local posw, posh = 654, 552
local posx, posy = screen[1]/2-posw/2, screen[2]/2-posh/2

_dxDrawRectangle = dxDrawRectangle
function dxDrawRectangle (x, y, w, h, ...)
    return _dxDrawRectangle (posx+x, posy+y, w, h, ...)
end

_dxDrawImage = dxDrawImage
function dxDrawImage (x, y, w, h, ...)
    return _dxDrawImage (posx+x, posy+y, w, h, ...)
end

_dxDrawText = dxDrawText
function dxDrawText (text, x, y, w, h, ...)
    return _dxDrawText (text, posx+x, posy+y, ((posx+x) + w), ((posy+y) + h), ...)
end

_svgCreate = svgCreate
function svgCreate (w, h, ...)
    return _svgCreate(w * 2, h * 2, ...)
end

local font = {}
function getFont (name, size)
    if not font[name] then
        font[name] = {}
    end
    if not font[name][size] then
        font[name][size] = dxCreateFont('assets/fonts/'..name..'.ttf', size)
    end
    return font[name][size]
end

function isMouseInPosition (x, y, w, h)
    if isCursorShowing() and (x and y and w and h) then
        local x, y = (posx + x), (posy + y)
        local sx, sy = guiGetScreenSize()
        local cx, cy = getCursorPosition()
        local cx, cy = (cx * sx), (cy * sy)
        return ((cx >= x and cx <= x + w) and (cy >= y and cy <= y + h))
    end
end

local svg = {
    ['background'] = svgCreate(654, 552,
        [[
            <svg width="654" height="552" viewBox="0 0 654 552" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect x="1" y="3" width="652" height="548" rx="14" fill="#181A1C" stroke="url(#paint0_linear_5571_53)" stroke-width="2"/>
                <path d="M0 15C0 6.71573 6.71573 0 15 0H639C647.284 0 654 6.71573 654 15V204H0V15Z" fill="#111111" fill-opacity="0.5"/>
                <path d="M15 0.5H639C647.008 0.5 653.5 6.99187 653.5 15V203.5H0.5V15C0.5 6.99187 6.99187 0.5 15 0.5Z" stroke="white" stroke-opacity="0.08"/>
                <rect y="202" width="654" height="2" fill="url(#paint1_linear_5571_53)"/>
                <defs>
                    <linearGradient id="paint0_linear_5571_53" x1="327" y1="552" x2="327" y2="2" gradientUnits="userSpaceOnUse">
                    <stop stop-color="#007afc"/>
                    <stop offset="1" stop-opacity="0"/>
                    </linearGradient>
                    <linearGradient id="paint1_linear_5571_53" x1="-9.75162e-06" y1="203.989" x2="654.001" y2="203.483" gradientUnits="userSpaceOnUse">
                    <stop stop-color="#464646"/>
                    <stop offset="1" stop-color="#444444"/>
                    </linearGradient>
                </defs>
            </svg>            
        ]]
    ),

    ['bar-1'] = svgCreate(240, 50,
        [[
            <svg width="240" height="50" viewBox="0 0 240 50" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect width="240" height="50" rx="5" fill="#222426"/>
            </svg>
        ]]
    ),

    ['bar-2'] = svgCreate(240, 50,
        [[
            <svg width="240" height="50" viewBox="0 0 240 50" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M235 0.5H5C2.51472 0.5 0.5 2.51472 0.5 5V45C0.5 47.4853 2.51472 49.5 5 49.5H235C237.485 49.5 239.5 47.4853 239.5 45V5C239.5 2.51472 237.485 0.5 235 0.5Z" fill="url(#paint0_linear_44_9)" stroke="url(#paint1_linear_44_9)"/>
                <defs>
                <linearGradient id="paint0_linear_44_9" x1="120" y1="50" x2="120" y2="4.56158e-07" gradientUnits="userSpaceOnUse">
                <stop stop-color="#3D8FDB"/>
                <stop offset="1" stop-color="#363738" stop-opacity="0"/>
                </linearGradient>
                <linearGradient id="paint1_linear_44_9" x1="120" y1="2.09072e-08" x2="120" y2="50" gradientUnits="userSpaceOnUse">
                <stop stop-color="#606060"/>
                <stop offset="1" stop-opacity="0"/>
                </linearGradient>
                </defs>
            </svg>             
        ]]
    ),

    ['button'] = svgCreate(148, 50,
        [[
            <svg width="148" height="50" viewBox="0 0 148 50" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect width="148" height="50" rx="5" fill="white"/>
            </svg>
        ]]
    ),

}

local animation = { initial = 0, finish = 0, time = 250, tick = 0, current = 0, easing = 'Linear' }
proxPag = 0
select = 1
selectPassado = 1
tickMap = getTickCount()

function render ()
    animation.current = interpolateBetween (animation.initial, 0, 0, animation.finish, 0, 0, (getTickCount ( ) - animation.tick) / animation.time, animation.easing)     
    local alpha = animation.current
    dxDrawImage(0, 0, 654, 552, svg['background'], 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawText('Emprego', 43, 218, 60, 15, tocolor(255, 255, 255, alpha), 1, getFont('semibold', 12), 'left', 'center')
    dxDrawText('Level', 227, 218, 34, 15, tocolor(255, 255, 255, alpha), 1, getFont('semibold', 12), 'right', 'center')
    linha = 0
    for i, v in ipairs(config.empregos) do
        if (i > proxPag and linha < 5) then
            linha = linha + 1
            local py = 245 + (56 * (linha - 1))
            dxDrawImage(32, py, 240, 50, svg['bar-1'], 0, 0, 0, isMouseInPosition(32, py, 240, 50) and tocolor(255, 255, 255, alpha * 0.5) or tocolor(255, 255, 255, alpha))
            if select == i then
                dxDrawImage(32, py, 240, 50, svg['bar-2'], 0, 0, 0, tocolor(255, 255, 255, alpha * 0.8))
            end
            dxDrawText(v.nome, 43, py, 60, 50, tocolor(255, 255, 255, alpha), 1, getFont('regular', 12), 'left', 'center')
            dxDrawText(v.level, 227, py, 34, 50, tocolor(255, 255, 255, alpha), 1, getFont('regular', 12), 'right', 'center')
        end
    end
    dxDrawRectangle(376, 405, 177, 2, tocolor(68, 68, 68, alpha))
    dxDrawText('Description:', 435, 387, 68, 15, tocolor(255, 255, 255, alpha), 1, getFont('semibold', 12), 'center', 'center')
    if select then
        dxDrawText(config.empregos[select].descricao, 321, 414, 301, 45, tocolor(96, 96, 96, alpha), 1, getFont('regular', 12), 'center', 'center', false, true)
        dxDrawImage(0, 2, 654, 200, 'assets/gfx/empregos/'..select..'.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
        local x, y, z = interpolateBetween(config.empregos[selectPassado].position[1], config.empregos[selectPassado].position[2], config.empregos[selectPassado].position[3], config.empregos[select].position[1], config.empregos[select].position[2], config.empregos[select].position[3], ((getTickCount()-tickMap)/500), 'Linear')
        exports['rld_radar_agencia']:renderingMap(x, y, z, alpha)
    end
    if #config.empregos > 5 then
        dxDrawRectangle(284, 245, 5, 274, tocolor(34, 36, 38, alpha))
        dxDrawRectangle(284, cursorY, 5, 50, tocolor(0, 122, 252, 255))
    end
    dxDrawImage(321, 469, 148, 50, svg['button'], 0, 0, 0, isMouseInPosition(321, 469, 148, 50) and tocolor(0, 122, 252, alpha) or tocolor(36, 36, 36, alpha))
    dxDrawText('start job', 321, 469, 148, 50, isMouseInPosition(321, 469, 148, 50) and tocolor(23, 23, 23, alpha) or tocolor(96, 96, 96, alpha), 1, getFont('regular', 12), 'center', 'center')
    dxDrawImage(474, 469, 148, 50, svg['button'], 0, 0, 0, isMouseInPosition(474, 469, 148, 50) and tocolor(0, 122, 252, alpha) or tocolor(36, 36, 36, alpha))
    dxDrawText('Resign', 474, 469, 148, 50, isMouseInPosition(474, 469, 148, 50) and tocolor(23, 23, 23, alpha) or tocolor(96, 96, 96, alpha), 1, getFont('regular', 12), 'center', 'center')
end

function click (button, state)
    if visible and not closing then
        if button == 'left' and state == 'down' then
            linha = 0
            for i, v in ipairs(config.empregos) do
                if (i > proxPag and linha < 5) then
                    linha = linha + 1
                    local py = 245 + (56 * (linha - 1))
                    if isMouseInPosition(32, py, 240, 50) then
                        selectPassado = select
                        select = i
                        tickMap = getTickCount()
                    end
                end
            end
            if isMouseInPosition(321, 469, 148, 50) then
                triggerServerEvent('acceptJob', localPlayer, config.empregos[select])
            elseif isMouseInPosition(474, 469, 148, 50) then
                triggerServerEvent('demitirJob', localPlayer, config.empregos[select])
            end
        end
    end
end

function key (button, press)  
    if (button == 'mouse_wheel_down' and press) then
        proxPag = proxPag + 1
        if (proxPag > (#config.empregos - 5)) then
            proxPag = (#config.empregos - 5)
        end
        if #config.empregos > 5 then
            cursorY = moveScrollBar(#config.empregos, 5, 245, 245+274-50, proxPag)
        end
    elseif (button == 'mouse_wheel_up' and press) then
        if (proxPag > 0) then
            proxPag = proxPag - 1
        end
        if #config.empregos > 5 then
            cursorY = moveScrollBar(#config.empregos, 5, 245, 245+274-50, proxPag)
        end
    elseif (button == 'backspace' and press) then
        panel('close')
    end
end

function moveScrollBar (tab, maxlinha, posinicio, posfim, pag)
    posinicio = posinicio/1080
    cy = ((((posfim/1080)-posinicio)/(tab-maxlinha))*pag)+posinicio    
    return (1080 * cy)
end

function panel (state)
    if not state then
        if visible then
            state = 'close'
        else
            state = 'open'
        end
    end
    if state == 'open' and not visible then
        cursorY = 245
        proxPag = 0
        select = 1
        visible = true
        animation.initial, animation.finish, animation.tick = animation.current, 255, getTickCount()
        showCursor(true)
        addEventHandler('onClientRender', root, render)
        addEventHandler('onClientClick', root, click)
        addEventHandler('onClientKey', root, key)
    elseif state == 'close' and visible then
        if not closing then
            closing = true
            animation.initial, animation.finish, animation.tick = animation.current, 0, getTickCount()
            showCursor(false)
            setTimer (function ()
                visible = false
                closing = false
                removeEventHandler('onClientRender', root, render)
                removeEventHandler('onClientClick', root, click)
                removeEventHandler('onClientKey', root, key)
            end, animation.time + 50, 1)
        end
    end
end

------------------------

function render_open ()
    local text = 'Pressione #007afc[E] #ffffffpara abrir a agência.'
    _dxDrawText(string.gsub(text, '#%x%x%x%x%x%x', ''), 1+screen[1]/2-dxGetTextWidth(text, 1, getFont('semibold', 14), true)/2, 1+screen[2]-200, 0, 0, tocolor(0, 0, 0, 255), 1, getFont('semibold', 14), 'left', 'top', false, false, false, true)
    _dxDrawText(text, screen[1]/2-dxGetTextWidth(text, 1, getFont('semibold', 14), true)/2, screen[2]-200, 0, 0, tocolor(255, 255, 255, 255), 1, getFont('semibold', 14), 'left', 'top', false, false, false, true)
end

function key_open (button, press)
    if button == 'e' and press then
        panel('open')
        openAgencia('close')
    end
end

function openAgencia (state)
    if state == 'open' then
        addEventHandler('onClientRender', root, render_open)
        addEventHandler('onClientKey', root, key_open)
    else
        removeEventHandler('onClientRender', root, render_open)
        removeEventHandler('onClientKey', root, key_open)
    end
end
addEvent('openAgencia', true)
addEventHandler('openAgencia', root, openAgencia)