local pagina = 'inicio'
local isTabletVisible = false
local groups = {}
vpn = false

local scroll = {
    ['jobs'] = 0,
    ['groups'] = 0,
}

local jobsPosition = {
    {567, 406},
    {971, 406},
    {567, 602},
    {971, 602},
}

local groupsPosition = {
    {553, 446},
    {968, 446},
    {553, 560},
    {968, 560},
    {553, 674},
    {968, 674},
}

function render (  )
    if pagina == 'inicio' then
        local time = getRealTime()
        local Hora = time.hour
        local Minuto = time.minute
        local Dia = time.monthday
        local Mes = time.month + 1
        local Ano = time.year+1900
        local MesWeek = {['1'] = 'JAN', ['2'] = 'FEB', ['3'] = 'MAR', ['4'] = 'APR', ['5'] = 'MAY', ['6'] = 'JUN', ['7'] = 'JUL', ['8'] = 'AUG', ['9'] = 'SEP', ['10'] = 'OCT', ['11'] = 'NOV', ['12'] = 'DEC'}    
        
        dxDrawImage(318, 112, 1283, 856.73, 'src/assets/bg.png', 0, 0, 0, tocolor('FFFFFF', 100))
        dxDrawImage(1318, 251, 66, 14, 'src/assets/general.png', 0, 0, 0, tocolor('FFFFFF', 100))
        dxDrawText('Welcome, '..string.gsub(getPlayerName(localPlayer), '_', ' '), 536, 252, 392, 12, white, 1, font['poppins']['regular'][12])

        dxDrawText(string.format('%02d:%02d', time.hour, time.minute), 318, 334, 1283, 52, white, 1, font['poppins']['bold'][50], 'center', 'top')
        dxDrawText(''..Dia..' '..MesWeek[''..Mes..'']..' '..Ano..'', 318, 390, 1283, 52, white, 1, font['poppins']['medium'][12], 'center', 'top')
        
        dxDrawRoundedRectangle(865, 707, 57, 52, 8, isCursorOnElement(865, 707, 57, 52) and tocolor('0B0B0B', 100) or tocolor('0B0B0B', 60))
        dxDrawImage(871, 712, 45, 41, 'src/assets/jobs.png', 0, 0, 0, tocolor('FFFFFF', 100))
        dxDrawText('Jobs', 860, 764, 75, 18, tocolor('FFFFFF', 100), 1, font['poppins']['medium'][12])

        dxDrawRoundedRectangle(982, 707, 57, 52, 8, isCursorOnElement(982, 707, 57, 52) and tocolor('0B0B0B', 100) or tocolor('0B0B0B', 60))
        dxDrawImage(992, 714, 38, 38, 'src/assets/groups.png', 0, 0, 0, tocolor('FFFFFF', 100))
        dxDrawText('Groups', 987, 764, 75, 18, tocolor('FFFFFF', 100), 1, font['poppins']['medium'][12])

    elseif pagina == 'Empregos' then 

        dxDrawImage(318, 112, 1283, 856.73, 'src/assets/bg2.png', 0, 0, 0, tocolor('FFFFFF', 100))
        dxDrawImage(1318, 251, 66, 14, 'src/assets/general.png', 0, 0, 0, tocolor('FFFFFF', 100))
        dxDrawText('Welcome, '..string.gsub(getPlayerName(localPlayer), '_', ' '), 536, 252, 392, 12, white, 1, font['poppins']['regular'][12])

        dxDrawImage(553, 317, 69, 69, 'src/assets/jobs.png')
        dxDrawText('Jobs', 622, 336, 247, 79, white, 1, font['poppins']['bold'][16])

        local index = 0 
        for i,v in ipairs(cfg.jobs) do 
            if i >= scroll['jobs'] and index <= #jobsPosition then
                if not v.vpn then 
                    index = index + 1   
                    local x, y = unpack(jobsPosition[index])

                    dxDrawRectangle(x, (y+495-406+1), 378, 3, tocolor('D9D9D9', 100))
                    dxDrawRoundedRectangle(x, y, 378, 92, 5, tocolor('25262B', 100))
                    dxDrawImage(x, y, 89, 89, v.img)
                    dxDrawText(v.emprego, (x+676-567), (y+13), 247, 79, white, 1, font['poppins']['regular'][12])

                    dxDrawImage((x+670-567), (y+40), 31, 31, 'src/assets/member.png')
                    dxDrawText(v.maxMembers, (x+701-567), (y+452-406), 247, 79, white, 1, font['poppins']['regular'][12])
                elseif v.vpn and vpn then 
                    index = index + 1   
                    local x, y = unpack(jobsPosition[index])
    
                    dxDrawRectangle(x, (y+495-406+1), 378, 3, tocolor('D9D9D9', 100))
                    dxDrawRoundedRectangle(x, y, 378, 92, 5, tocolor('25262B', 100))
                    dxDrawImage(x, y, 89, 89, v.img)
                    dxDrawText(v.emprego, (x+676-567), (y+13), 247, 79, white, 1, font['poppins']['regular'][12])
    
                    dxDrawImage((x+670-567), (y+40), 31, 31, 'src/assets/member.png')
                    dxDrawText(v.maxMembers, (x+701-567), (y+452-406), 247, 79, white, 1, font['poppins']['regular'][12])
                end
            end
        end
    elseif pagina == 'Grupos' then 
        dxDrawImage(318, 112, 1283, 856.73, 'src/assets/bg2.png', 0, 0, 0, tocolor('FFFFFF', 100))
        dxDrawImage(1318, 251, 66, 14, 'src/assets/general.png', 0, 0, 0, tocolor('FFFFFF', 100))
        dxDrawText('Welcome, '..string.gsub(getPlayerName(localPlayer), '_', ' '), 536, 252, 392, 12, white, 1, font['poppins']['regular'][12])
    
        if not getElementData(localPlayer, 'JobGroup') then
            dxDrawImage(553, 317, 69, 69, 'src/assets/jobs.png')
            dxDrawText('Groups', 622, 336, 247, 79, white, 1, font['poppins']['bold'][16])

            dxDrawRoundedRectangle(1077, 331, 145, 43, 5, isCursorOnElement(1077, 331, 145, 43) and tocolor('59884A', 100) or tocolor('59884A', 80))
            dxDrawText('CREATE GROUP', 1077, 331, 145, 43, white, 1, font['poppins']['regular'][12], 'center', 'center')
            dxDrawRoundedRectangle(1234, 331, 115, 43, 5, isCursorOnElement(1234, 331, 115, 43) and tocolor('A3693A', 100) or tocolor('A3693A', 80))
            dxDrawText('RESIGN', 1234, 331, 115, 43, white, 1, font['poppins']['regular'][12], 'center', 'center')

            dxDrawImage(553, 398, 31, 31, 'src/assets/groups.png')
            dxDrawText('List of available groups', 587, 403, 207, 24, white, 1, font['poppins']['regular'][12])

            local i = 0
            for k,v in ipairs(groups) do 
                if k >= scroll['groups'] and i < #groupsPosition then
                    i = i +1
                    local x, y = unpack(groupsPosition[i])
                    dxDrawRectangle(x, (y+88), 392, 6, tocolor('D9D9D9'))
                    dxDrawRoundedRectangle(x, y, 392, 92, 5, tocolor('25262B'))
                    dxDrawImage(x, (y+13), 59, 59, 'src/assets/jobs.png')
                    dxDrawText(v.name, (x+61), (y+27), 158, 27, white, 1, font['poppins']['bold'][12])
                    dxDrawText(v.job, (x+61), (y+45), 158, 27, tocolor('BEBEBE'), 1, font['poppins']['regular'][12])

                    dxDrawText('QTD', (x+201), (y+28), 24, 14, tocolor('BEBEBE'), 1, font['poppins']['regular'][12])
                    dxDrawImage((x+187), (y+39), 31, 31, 'src/assets/member.png')
                    dxDrawText(v.members, (x+218), (y+45), 21, 21, tocolor('FFFFFF'), 1, font['poppins']['regular'][12])

                    dxDrawText('MAX', (x+253), (y+28), 24, 14, tocolor('BEBEBE'), 1, font['poppins']['regular'][12])
                    dxDrawImage((x+250), (y+39), 31, 31, 'src/assets/groups.png')
                    dxDrawText(v.maxMembers, (x+281), (y+45), 21, 21, tocolor('FFFFFF'), 1, font['poppins']['regular'][12])

                    dxDrawImage((x+310), (y+36), 69, 22, svg.button)
                end
            end
        else

            local list, members = getMembersInGroup(getElementData(localPlayer, 'JobGroup'))
            dxDrawImage(553, 317, 69, 69, 'src/assets/jobs.png')
            dxDrawText('Your group', 622, 336, 247, 79, white, 1, font['poppins']['bold'][16])

            if getElementData(localPlayer, 'JobGroup') == getElementData(localPlayer, 'ID') then
                if not getElementData(localPlayer, 'InService') then
                    dxDrawRoundedRectangle(1077, 331, 145, 43, 5, isCursorOnElement(1077, 331, 145, 43) and tocolor('59884A', 100) or tocolor('59884A', 80))
                    dxDrawText('START SERVICE', 1077, 331, 145, 43, white, 1, font['poppins']['regular'][12], 'center', 'center')
                else 
                    if getElementData(localPlayer, 'InService') then
                        dxDrawRoundedRectangle(1077, 331, 145, 43, 5, isCursorOnElement(1077, 331, 145, 43) and tocolor('A3693A', 100) or tocolor('A3693A', 80))
                        dxDrawText('CANCEL SERVICE', 1077, 331, 145, 43, white, 1, font['poppins']['regular'][12], 'center', 'center')
                    end
                end
                dxDrawRoundedRectangle(1234, 331, 115, 43, 5, isCursorOnElement(1234, 331, 115, 43) and tocolor('942222', 100) or tocolor('942222', 80))
                dxDrawText('UNDO', 1234, 331, 115, 43, white, 1, font['poppins']['regular'][12], 'center', 'center')
            else
                dxDrawRoundedRectangle(1234, 331, 115, 43, 5, isCursorOnElement(1234, 331, 115, 43) and tocolor('942222', 100) or tocolor('942222', 80))
                dxDrawText('LEAVE', 1234, 331, 115, 43, white, 1, font['poppins']['regular'][12], 'center', 'center')
            end

            dxDrawImage(553, 398, 31, 31, 'src/assets/groups.png')
            dxDrawText('List of members ('..members..'/'..getJobAssets(getElementData(localPlayer, 'Job')).maxMembers..')', 587, 403, 207, 24, white, 1, font['poppins']['regular'][12])
        
            local i =0
            for k,v in ipairs(list) do 
                if i < 4 then
                    i = i +1
                    local x, y = unpack(groupsPosition[i])
                    dxDrawRectangle(x, (y+88), 392, 6, tocolor('D9D9D9'))
                    dxDrawRoundedRectangle(x, y, 392, 92, 5, tocolor('25262B'))
                    dxDrawText(string.gsub(getPlayerName(v), '_', ' '), (x+66), (y+27), 158, 27, white, 1, font['poppins']['bold'][12])
                    if getElementData(v, 'ID') == getElementData(localPlayer, 'JobGroup') then
                        dxDrawImage(x, (y+13), 59, 59, 'src/assets/leader.png')
                        dxDrawText('Leader', (x+66), (y+45), 158, 27, tocolor('BEBEBE'), 1, font['poppins']['regular'][12])
                    else
                        dxDrawImage(x, (y+13), 59, 59, 'src/assets/member.png')
                        dxDrawText('Member', (x+66), (y+45), 158, 27, tocolor('BEBEBE'), 1, font['poppins']['regular'][12])
                    end

                    if getElementData(localPlayer, 'JobGroup') == getElementData(localPlayer, 'ID') then
                        if v ~= localPlayer then 
                            dxDrawImage((x+310), (y+36), 69, 22, svg.button2)
                        end
                    end
                end
            end
        end
    end

    if pagina ~= 'inicio' then 
        dxDrawRoundedRectangle(904, 808, 116, 4, 2, isCursorOnElement(904, 808, 116, 4) and tocolor('818184', 100) or tocolor('818184', 60))
    end
end


function open ( )
    if not isTabletVisible then 
        addEventHandler('onClientRender', root, render)
        addEventHandler('onClientClick', root, clickManager)
        addEventHandler('onClientKey', root, keyManager)
        vpn = false
        pagina = 'inicio'
        isTabletVisible = true
        showCursor(true)
        triggerServerEvent('getVPN', localPlayer, localPlayer)
        scroll = {
            ['jobs'] = 0,
            ['groups'] = 0,
        }
    else
        removeEventHandler('onClientRender', root, render)
        removeEventHandler('onClientClick', root, clickManager)
        removeEventHandler('onClientKey', root, keyManager)
        isTabletVisible = false
        showCursor(false)
    end
end
addEvent('openTablet', true)
addEventHandler('openTablet', root, open)

function clickManager (b, s)
    if isTabletVisible then 
        if b == 'left' and s == 'down' then 
            if pagina == 'inicio' then 
                if isCursorOnElement(865, 707, 57, 52) then 
                    pagina = 'Empregos'
                    scroll['jobs'] = 0
                elseif isCursorOnElement(982, 707, 57, 52) then
                    if getElementData(localPlayer, 'Job') then 
                        groups = {}
                        triggerServerEvent('jobmanager >> getgroups', localPlayer, localPlayer)
                        pagina = 'Grupos' 
                        scroll['groups'] = 0
                    else
                        triggerEvent('addBox', localPlayer, 'VocC* nC#o estC! empregado. VC! atC) um emprego e solicite um serviC'o.', 'error')
                    end
                end
            elseif pagina == 'Empregos' then 
                local index2 = 0 
                for k,v in ipairs(cfg.jobs) do 
                    if k >= scroll['jobs'] and index2 < #jobsPosition then
                        if not v.vpn then 
                            index2 = index2 + 1   
                            local x2, y2 = unpack(jobsPosition[index2])
                            if isCursorOnElement(x2, y2, 378, 92) then 
                                triggerServerEvent('jobmanager >> marcarjob', localPlayer, localPlayer, v.element)
                            end
                        else
                            if vpn then 
                                index2 = index2 + 1   
                                local x2, y2 = unpack(jobsPosition[index2])
                                if isCursorOnElement(x2, y2, 378, 92) then 
                                    triggerServerEvent('jobmanager >> marcarjob', localPlayer, localPlayer, v.element)
                                end
                            end
                        end
                    end
                end
            elseif pagina == 'Grupos' then 
                if not getElementData(localPlayer, 'JobGroup') then
                    local index = 0
                    for k,v in ipairs(groups) do 
                        if k >= scroll['groups'] and index < #groupsPosition then
                            index = index +1
                            local x, y = unpack(groupsPosition[index])
                            if isCursorOnElement((x+310), (y+36), 69, 22) then 
                                triggerServerEvent('jobmanager >> requestjoin', localPlayer, localPlayer, groups[k])
                            end
                        end
                    end
                    if isCursorOnElement(1077, 331, 145, 43) then 
                        triggerServerEvent('jobmanager >> creategroup', localPlayer, localPlayer)
                        pagina = 'inicio'
                    elseif isCursorOnElement(1234, 331, 115, 43) then 
                        triggerServerEvent('jobmaanger >> takejob', localPlayer, localPlayer, false, getElementData(localPlayer, 'Job'))
                        pagina = 'inicio'
                    end
                else 
                    local list, members = getMembersInGroup(getElementData(localPlayer, 'JobGroup'))
                    local index =0
                    for k,v in ipairs(list) do 
                        if index < 4 then
                            index = index +1
                            local x, y = unpack(groupsPosition[index])
                            if isCursorOnElement((x+310), (y+36), 69, 22) then 
                                triggerServerEvent('jobmanager >> kick', localPlayer, localPlayer, v)
                            end
                        end
                    end
                    if isCursorOnElement(1234, 331, 115, 43) then 
                        if getElementData(localPlayer, 'JobGroup') == getElementData(localPlayer, 'ID') then 
                            triggerServerEvent('jobmanager >> destroygroup', localPlayer, localPlayer)
                            pagina = 'inicio'
                        else
                            triggerServerEvent('jobmanager >> quitgroup', localPlayer, localPlayer)
                            pagina = 'inicio'
                        end
                    elseif isCursorOnElement(1077, 331, 145, 43) then 
                        if getElementData(localPlayer, 'JobGroup') == getElementData(localPlayer, 'ID') and not getElementData(localPlayer, 'InService') then 
                            triggerServerEvent('jobmanager >> startservice', localPlayer, localPlayer, getElementData(localPlayer, 'Job'))
                        elseif getElementData(localPlayer, 'JobGroup') == getElementData(localPlayer, 'ID') and getElementData(localPlayer, 'InService') then 
                            if isCursorOnElement(1077, 331, 145, 43) then 
                                triggerServerEvent('jobmanager >> cancelservice', localPlayer, localPlayer, getElementData(localPlayer, 'Job'))
                            end
                        end
                    end
                end
            end
            if pagina ~= 'inicio' then 
                if isCursorOnElement(904, 808, 116, 4) then 
                    pagina = 'inicio'
                end
            end
        end
    end
end

function keyManager (b, s)
    if isTabletVisible then 
        if s then 
            if b == 'mouse_wheel_down' then 
                if pagina == 'Empregos' then 
                    if isCursorOnElement(318, 112, 1283, 856.73) then 
                        if #cfg.jobs <= 4 then return end
                        if scroll['jobs'] +2 < #cfg.jobs then 
                            scroll['jobs'] = scroll['jobs'] +2
                        end
                    end
                elseif pagina == 'Grupos' then 
                    if isCursorOnElement(318, 112, 1283, 856.73) then 
                        if #groups <= 4 then return end
                        if scroll['groups'] +2 < #groups then 
                            scroll['groups'] = scroll['groups'] +2
                        end
                    end
                end
            elseif b == 'mouse_wheel_up' then 
                if pagina == 'Empregos' then 
                    if isCursorOnElement(318, 112, 1283, 856.73) then 
                        if scroll['jobs'] - 2 > 0 then 
                            scroll['jobs'] = scroll['jobs'] - 2
                        end
                    end
                elseif pagina == 'Grupos' then 
                    if isCursorOnElement(318, 112, 1283, 856.73) then 
                        if scroll['groups'] - 2 > 0 then 
                            scroll['groups'] = scroll['groups'] - 2
                        else
                            scroll['groups'] = 0
                        end
                    end
                end
            elseif b == 'escape' then 
                removeEventHandler('onClientRender', root, render)
                removeEventHandler('onClientClick', root, clickManager)
                removeEventHandler('onClientKey', root, keyManager)
                isTabletVisible = false
                showCursor(false)
                cancelEvent()
            end
        end
    end
end

addEvent('updateGroups', true)
addEventHandler('updateGroups', root, function(list)
    groups = list
end)

addEvent('updateVPN', true)
addEventHandler('updateVPN', root, function()
    vpn = true
end)


-- NOTIFY 

local notify = {}

addEventHandler('onClientRender', root, function ( )
    if #notify > 0 then 
        for i,v in ipairs(notify) do
            local alpha = interpolateBetween(v.alpha[1], 0, 0, v.alpha[2], 0, 0, (getTickCount()-v.alpha[3])/500, 'Linear') 
            local x = 744
            local y = 32 + (-90 + (90 * i))
            dxDrawRoundedRectangle(x, y, 432, 81, 5, tocolor('000000', alpha-35))
            if v.img then
                dxDrawImage((x+13), (y+8), 40, 40, v.img, 0, 0, 0, tocolor('FFFFFF', alpha))
            end
            dxDrawText(v.nome, (x+66), (y+17), 228, 21, tocolor(v.color, alpha), 1, font['poppins']['bold'][12], 'left', 'top')
            dxDrawText(v.msg, (x+19), (y+47), 416, 21, tocolor('FFFFFF', alpha), 1, font['poppins']['regular'][12], 'left', 'top', false, true)
            dxDrawText('Now', (x+371), (y+17), 56, 21, tocolor('FFFFFF', alpha), 1, font['poppins']['regular'][12])
        
            if v.type == 'escolha' then 
                dxDrawImage((x+362), (y+44), 21, 23, svg.yes, 0, 0, 0, tocolor('FFFFFF', alpha))
                dxDrawImage((x+394), (y+44), 21, 23, svg.no, 0, 0, 0, tocolor('FFFFFF', alpha))
            end

            if (getTickCount()-v.tick)/(v.time - 1000) >= 1 and v.alpha[1] ~= 100 then 
                notify[i].alpha = {100, 0, getTickCount()}
            end

            if (getTickCount()-v.tick)/v.time >= 1 then 
                table.remove(notify, i)
            end
        end
    end
end)

addEvent('jobmanager >> notify', true)
addEventHandler('jobmanager >> notify', root, function ( assets )
    local newIndex = {
        alpha = {0, 100, getTickCount()},
        tick = getTickCount(),
        img = assets.img,
        msg = assets.msg,
        time = 7000,
        execute = assets.execute or false,
        nome = assets.nome,
        type = assets.type or false,
        args = assets.args or false,
        color = assets.color or 'FFFFFF',
    }
    table.insert(notify, newIndex)
end)

addEventHandler('onClientClick', root, function(b, s )
    if #notify > 0 then 
        if b == 'left' and s == 'down' then 
            for i,v in ipairs(notify) do
                if v.type == 'escolha' then
                    local x = 744
                    local y = 32 + (-90 + (90 * i))
                    if isCursorOnElement((x+362), (y+44), 21, 23) then
                        if v.execute then
                            triggerServerEvent(v.execute, localPlayer, unpack(v.args)) 
                        end
                        table.remove(notify, i)
                    elseif isCursorOnElement((x+394), (y+44), 21, 23) then
                        table.remove(notify, i)
                    end
                end
            end
        end
    end
end)

svg = {
    button = svgCreate(69, 22, [[
        <svg width="69" height="22" viewBox="0 0 69 22" fill="none" xmlns="http://www.w3.org/2000/svg">
    <rect x="0.25" y="0.25" width="68.5" height="21.5" rx="4.75" fill="#25262B" stroke="#BEBEBE" stroke-width="0.5"/>
    <path d="M25.0078 14.0801V15H20.4902V14.0801H25.0078ZM20.7188 6.46875V15H19.5879V6.46875H20.7188ZM24.4102 10.1367V11.0566H20.4902V10.1367H24.4102ZM24.9492 6.46875V7.39453H20.4902V6.46875H24.9492ZM27.3281 10.0137V15H26.2441V8.66016H27.2695L27.3281 10.0137ZM27.0703 11.5898L26.6191 11.5723C26.623 11.1387 26.6875 10.7383 26.8125 10.3711C26.9375 10 27.1133 9.67773 27.3398 9.4043C27.5664 9.13086 27.8359 8.91992 28.1484 8.77148C28.4648 8.61914 28.8145 8.54297 29.1973 8.54297C29.5098 8.54297 29.791 8.58594 30.041 8.67188C30.291 8.75391 30.5039 8.88672 30.6797 9.07031C30.8594 9.25391 30.9961 9.49219 31.0898 9.78516C31.1836 10.0742 31.2305 10.4277 31.2305 10.8457V15H30.1406V10.834C30.1406 10.502 30.0918 10.2363 29.9941 10.0371C29.8965 9.83398 29.7539 9.6875 29.5664 9.59766C29.3789 9.50391 29.1484 9.45703 28.875 9.45703C28.6055 9.45703 28.3594 9.51367 28.1367 9.62695C27.918 9.74023 27.7285 9.89648 27.5684 10.0957C27.4121 10.2949 27.2891 10.5234 27.1992 10.7812C27.1133 11.0352 27.0703 11.3047 27.0703 11.5898ZM35.5312 8.66016V9.49219H32.1035V8.66016H35.5312ZM33.2637 7.11914H34.3477V13.4297C34.3477 13.6445 34.3809 13.8066 34.4473 13.916C34.5137 14.0254 34.5996 14.0977 34.7051 14.1328C34.8105 14.168 34.9238 14.1855 35.0449 14.1855C35.1348 14.1855 35.2285 14.1777 35.3262 14.1621C35.4277 14.1426 35.5039 14.127 35.5547 14.1152L35.5605 15C35.4746 15.0273 35.3613 15.0527 35.2207 15.0762C35.084 15.1035 34.918 15.1172 34.7227 15.1172C34.457 15.1172 34.2129 15.0645 33.9902 14.959C33.7676 14.8535 33.5898 14.6777 33.457 14.4316C33.3281 14.1816 33.2637 13.8457 33.2637 13.4238V7.11914ZM37.8867 9.65625V15H36.8027V8.66016H37.8574L37.8867 9.65625ZM39.8672 8.625L39.8613 9.63281C39.7715 9.61328 39.6855 9.60156 39.6035 9.59766C39.5254 9.58984 39.4355 9.58594 39.334 9.58594C39.084 9.58594 38.8633 9.625 38.6719 9.70312C38.4805 9.78125 38.3184 9.89062 38.1855 10.0312C38.0527 10.1719 37.9473 10.3398 37.8691 10.5352C37.7949 10.7266 37.7461 10.9375 37.7227 11.168L37.418 11.3438C37.418 10.9609 37.4551 10.6016 37.5293 10.2656C37.6074 9.92969 37.7266 9.63281 37.8867 9.375C38.0469 9.11328 38.25 8.91016 38.4961 8.76562C38.7461 8.61719 39.043 8.54297 39.3867 8.54297C39.4648 8.54297 39.5547 8.55273 39.6562 8.57227C39.7578 8.58789 39.8281 8.60547 39.8672 8.625ZM44.373 13.916V10.6523C44.373 10.4023 44.3223 10.1855 44.2207 10.002C44.123 9.81445 43.9746 9.66992 43.7754 9.56836C43.5762 9.4668 43.3301 9.41602 43.0371 9.41602C42.7637 9.41602 42.5234 9.46289 42.3164 9.55664C42.1133 9.65039 41.9531 9.77344 41.8359 9.92578C41.7227 10.0781 41.666 10.2422 41.666 10.418H40.582C40.582 10.1914 40.6406 9.9668 40.7578 9.74414C40.875 9.52148 41.043 9.32031 41.2617 9.14062C41.4844 8.95703 41.75 8.8125 42.0586 8.70703C42.3711 8.59766 42.7188 8.54297 43.1016 8.54297C43.5625 8.54297 43.9688 8.62109 44.3203 8.77734C44.6758 8.93359 44.9531 9.16992 45.1523 9.48633C45.3555 9.79883 45.457 10.1914 45.457 10.6641V13.6172C45.457 13.8281 45.4746 14.0527 45.5098 14.291C45.5488 14.5293 45.6055 14.7344 45.6797 14.9062V15H44.5488C44.4941 14.875 44.4512 14.709 44.4199 14.502C44.3887 14.291 44.373 14.0957 44.373 13.916ZM44.5605 11.1562L44.5723 11.918H43.4766C43.168 11.918 42.8926 11.9434 42.6504 11.9941C42.4082 12.041 42.2051 12.1133 42.041 12.2109C41.877 12.3086 41.752 12.4316 41.666 12.5801C41.5801 12.7246 41.5371 12.8945 41.5371 13.0898C41.5371 13.2891 41.582 13.4707 41.6719 13.6348C41.7617 13.7988 41.8965 13.9297 42.0762 14.0273C42.2598 14.1211 42.4844 14.168 42.75 14.168C43.082 14.168 43.375 14.0977 43.6289 13.957C43.8828 13.8164 44.084 13.6445 44.2324 13.4414C44.3848 13.2383 44.4668 13.041 44.4785 12.8496L44.9414 13.3711C44.9141 13.5352 44.8398 13.7168 44.7188 13.916C44.5977 14.1152 44.4355 14.3066 44.2324 14.4902C44.0332 14.6699 43.7949 14.8203 43.5176 14.9414C43.2441 15.0586 42.9355 15.1172 42.5918 15.1172C42.1621 15.1172 41.7852 15.0332 41.4609 14.8652C41.1406 14.6973 40.8906 14.4727 40.7109 14.1914C40.5352 13.9062 40.4473 13.5879 40.4473 13.2363C40.4473 12.8965 40.5137 12.5977 40.6465 12.3398C40.7793 12.0781 40.9707 11.8613 41.2207 11.6895C41.4707 11.5137 41.7715 11.3809 42.123 11.291C42.4746 11.2012 42.8672 11.1562 43.3008 11.1562H44.5605ZM48.2461 9.65625V15H47.1621V8.66016H48.2168L48.2461 9.65625ZM50.2266 8.625L50.2207 9.63281C50.1309 9.61328 50.0449 9.60156 49.9629 9.59766C49.8848 9.58984 49.7949 9.58594 49.6934 9.58594C49.4434 9.58594 49.2227 9.625 49.0312 9.70312C48.8398 9.78125 48.6777 9.89062 48.5449 10.0312C48.4121 10.1719 48.3066 10.3398 48.2285 10.5352C48.1543 10.7266 48.1055 10.9375 48.082 11.168L47.7773 11.3438C47.7773 10.9609 47.8145 10.6016 47.8887 10.2656C47.9668 9.92969 48.0859 9.63281 48.2461 9.375C48.4062 9.11328 48.6094 8.91016 48.8555 8.76562C49.1055 8.61719 49.4023 8.54297 49.7461 8.54297C49.8242 8.54297 49.9141 8.55273 50.0156 8.57227C50.1172 8.58789 50.1875 8.60547 50.2266 8.625Z" fill="white"/>
    </svg>

    ]]),
    button2 = svgCreate(69, 22, [[
        <svg width="69" height="22" viewBox="0 0 69 22" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect x="0.25" y="0.25" width="68.5" height="21.5" rx="4.75" fill="#25262B" stroke="#BEBEBE" stroke-width="0.5"/>
        <path d="M12.9902 5.46875H15.8145C16.4551 5.46875 16.9961 5.56641 17.4375 5.76172C17.8828 5.95703 18.2207 6.24609 18.4512 6.62891C18.6855 7.00781 18.8027 7.47461 18.8027 8.0293C18.8027 8.41992 18.7227 8.77734 18.5625 9.10156C18.4062 9.42188 18.1797 9.69531 17.8828 9.92188C17.5898 10.1445 17.2383 10.3105 16.8281 10.4199L16.5117 10.543H13.8574L13.8457 9.62305H15.8496C16.2559 9.62305 16.5938 9.55273 16.8633 9.41211C17.1328 9.26758 17.3359 9.07422 17.4727 8.83203C17.6094 8.58984 17.6777 8.32227 17.6777 8.0293C17.6777 7.70117 17.6133 7.41406 17.4844 7.16797C17.3555 6.92188 17.1523 6.73242 16.875 6.59961C16.6016 6.46289 16.248 6.39453 15.8145 6.39453H14.1211V14H12.9902V5.46875ZM17.9766 14L15.9023 10.1328L17.0801 10.127L19.1836 13.9297V14H17.9766ZM22.8516 14.1172C22.4102 14.1172 22.0098 14.043 21.6504 13.8945C21.2949 13.7422 20.9883 13.5293 20.7305 13.2559C20.4766 12.9824 20.2812 12.6582 20.1445 12.2832C20.0078 11.9082 19.9395 11.498 19.9395 11.0527V10.8066C19.9395 10.291 20.0156 9.83203 20.168 9.42969C20.3203 9.02344 20.5273 8.67969 20.7891 8.39844C21.0508 8.11719 21.3477 7.9043 21.6797 7.75977C22.0117 7.61523 22.3555 7.54297 22.7109 7.54297C23.1641 7.54297 23.5547 7.62109 23.8828 7.77734C24.2148 7.93359 24.4863 8.15234 24.6973 8.43359C24.9082 8.71094 25.0645 9.03906 25.166 9.41797C25.2676 9.79297 25.3184 10.2031 25.3184 10.6484V11.1348H20.584V10.25H24.2344V10.168C24.2188 9.88672 24.1602 9.61328 24.0586 9.34766C23.9609 9.08203 23.8047 8.86328 23.5898 8.69141C23.375 8.51953 23.082 8.43359 22.7109 8.43359C22.4648 8.43359 22.2383 8.48633 22.0312 8.5918C21.8242 8.69336 21.6465 8.8457 21.498 9.04883C21.3496 9.25195 21.2344 9.5 21.1523 9.79297C21.0703 10.0859 21.0293 10.4238 21.0293 10.8066V11.0527C21.0293 11.3535 21.0703 11.6367 21.1523 11.9023C21.2383 12.1641 21.3613 12.3945 21.5215 12.5938C21.6855 12.793 21.8828 12.9492 22.1133 13.0625C22.3477 13.1758 22.6133 13.2324 22.9102 13.2324C23.293 13.2324 23.6172 13.1543 23.8828 12.998C24.1484 12.8418 24.3809 12.6328 24.5801 12.3711L25.2363 12.8926C25.0996 13.0996 24.9258 13.2969 24.7148 13.4844C24.5039 13.6719 24.2441 13.8242 23.9355 13.9414C23.6309 14.0586 23.2695 14.1172 22.8516 14.1172ZM27.6621 8.91992V14H26.5723V7.66016H27.6035L27.6621 8.91992ZM27.4395 10.5898L26.9355 10.5723C26.9395 10.1387 26.9961 9.73828 27.1055 9.37109C27.2148 9 27.377 8.67773 27.5918 8.4043C27.8066 8.13086 28.0742 7.91992 28.3945 7.77148C28.7148 7.61914 29.0859 7.54297 29.5078 7.54297C29.8047 7.54297 30.0781 7.58594 30.3281 7.67188C30.5781 7.75391 30.7949 7.88477 30.9785 8.06445C31.1621 8.24414 31.3047 8.47461 31.4062 8.75586C31.5078 9.03711 31.5586 9.37695 31.5586 9.77539V14H30.4746V9.82812C30.4746 9.49609 30.418 9.23047 30.3047 9.03125C30.1953 8.83203 30.0391 8.6875 29.8359 8.59766C29.6328 8.50391 29.3945 8.45703 29.1211 8.45703C28.8008 8.45703 28.5332 8.51367 28.3184 8.62695C28.1035 8.74023 27.9316 8.89648 27.8027 9.0957C27.6738 9.29492 27.5801 9.52344 27.5215 9.78125C27.4668 10.0352 27.4395 10.3047 27.4395 10.5898ZM31.5469 9.99219L30.8203 10.2148C30.8242 9.86719 30.8809 9.5332 30.9902 9.21289C31.1035 8.89258 31.2656 8.60742 31.4766 8.35742C31.6914 8.10742 31.9551 7.91016 32.2676 7.76562C32.5801 7.61719 32.9375 7.54297 33.3398 7.54297C33.6797 7.54297 33.9805 7.58789 34.2422 7.67773C34.5078 7.76758 34.7305 7.90625 34.9102 8.09375C35.0938 8.27734 35.2324 8.51367 35.3262 8.80273C35.4199 9.0918 35.4668 9.43555 35.4668 9.83398V14H34.377V9.82227C34.377 9.4668 34.3203 9.19141 34.207 8.99609C34.0977 8.79688 33.9414 8.6582 33.7383 8.58008C33.5391 8.49805 33.3008 8.45703 33.0234 8.45703C32.7852 8.45703 32.5742 8.49805 32.3906 8.58008C32.207 8.66211 32.0527 8.77539 31.9277 8.91992C31.8027 9.06055 31.707 9.22266 31.6406 9.40625C31.5781 9.58984 31.5469 9.78516 31.5469 9.99219ZM36.8203 10.9004V10.7656C36.8203 10.3086 36.8867 9.88477 37.0195 9.49414C37.1523 9.09961 37.3438 8.75781 37.5938 8.46875C37.8438 8.17578 38.1465 7.94922 38.502 7.78906C38.8574 7.625 39.2559 7.54297 39.6973 7.54297C40.1426 7.54297 40.543 7.625 40.8984 7.78906C41.2578 7.94922 41.5625 8.17578 41.8125 8.46875C42.0664 8.75781 42.2598 9.09961 42.3926 9.49414C42.5254 9.88477 42.5918 10.3086 42.5918 10.7656V10.9004C42.5918 11.3574 42.5254 11.7812 42.3926 12.1719C42.2598 12.5625 42.0664 12.9043 41.8125 13.1973C41.5625 13.4863 41.2598 13.7129 40.9043 13.877C40.5527 14.0371 40.1543 14.1172 39.709 14.1172C39.2637 14.1172 38.8633 14.0371 38.5078 13.877C38.1523 13.7129 37.8477 13.4863 37.5938 13.1973C37.3438 12.9043 37.1523 12.5625 37.0195 12.1719C36.8867 11.7812 36.8203 11.3574 36.8203 10.9004ZM37.9043 10.7656V10.9004C37.9043 11.2168 37.9414 11.5156 38.0156 11.7969C38.0898 12.0742 38.2012 12.3203 38.3496 12.5352C38.502 12.75 38.6914 12.9199 38.918 13.0449C39.1445 13.166 39.4082 13.2266 39.709 13.2266C40.0059 13.2266 40.2656 13.166 40.4883 13.0449C40.7148 12.9199 40.9023 12.75 41.0508 12.5352C41.1992 12.3203 41.3105 12.0742 41.3848 11.7969C41.4629 11.5156 41.502 11.2168 41.502 10.9004V10.7656C41.502 10.4531 41.4629 10.1582 41.3848 9.88086C41.3105 9.59961 41.1973 9.35156 41.0449 9.13672C40.8965 8.91797 40.709 8.74609 40.4824 8.62109C40.2598 8.49609 39.998 8.43359 39.6973 8.43359C39.4004 8.43359 39.1387 8.49609 38.9121 8.62109C38.6895 8.74609 38.502 8.91797 38.3496 9.13672C38.2012 9.35156 38.0898 9.59961 38.0156 9.88086C37.9414 10.1582 37.9043 10.4531 37.9043 10.7656ZM45.7852 13.0215L47.5195 7.66016H48.627L46.3477 14H45.6211L45.7852 13.0215ZM44.3379 7.66016L46.125 13.0508L46.248 14H45.5215L43.2246 7.66016H44.3379ZM52.2188 14.1172C51.7773 14.1172 51.377 14.043 51.0176 13.8945C50.6621 13.7422 50.3555 13.5293 50.0977 13.2559C49.8438 12.9824 49.6484 12.6582 49.5117 12.2832C49.375 11.9082 49.3066 11.498 49.3066 11.0527V10.8066C49.3066 10.291 49.3828 9.83203 49.5352 9.42969C49.6875 9.02344 49.8945 8.67969 50.1562 8.39844C50.418 8.11719 50.7148 7.9043 51.0469 7.75977C51.3789 7.61523 51.7227 7.54297 52.0781 7.54297C52.5312 7.54297 52.9219 7.62109 53.25 7.77734C53.582 7.93359 53.8535 8.15234 54.0645 8.43359C54.2754 8.71094 54.4316 9.03906 54.5332 9.41797C54.6348 9.79297 54.6855 10.2031 54.6855 10.6484V11.1348H49.9512V10.25H53.6016V10.168C53.5859 9.88672 53.5273 9.61328 53.4258 9.34766C53.3281 9.08203 53.1719 8.86328 52.957 8.69141C52.7422 8.51953 52.4492 8.43359 52.0781 8.43359C51.832 8.43359 51.6055 8.48633 51.3984 8.5918C51.1914 8.69336 51.0137 8.8457 50.8652 9.04883C50.7168 9.25195 50.6016 9.5 50.5195 9.79297C50.4375 10.0859 50.3965 10.4238 50.3965 10.8066V11.0527C50.3965 11.3535 50.4375 11.6367 50.5195 11.9023C50.6055 12.1641 50.7285 12.3945 50.8887 12.5938C51.0527 12.793 51.25 12.9492 51.4805 13.0625C51.7148 13.1758 51.9805 13.2324 52.2773 13.2324C52.6602 13.2324 52.9844 13.1543 53.25 12.998C53.5156 12.8418 53.748 12.6328 53.9473 12.3711L54.6035 12.8926C54.4668 13.0996 54.293 13.2969 54.082 13.4844C53.8711 13.6719 53.6113 13.8242 53.3027 13.9414C52.998 14.0586 52.6367 14.1172 52.2188 14.1172ZM57.0352 8.65625V14H55.9512V7.66016H57.0059L57.0352 8.65625ZM59.0156 7.625L59.0098 8.63281C58.9199 8.61328 58.834 8.60156 58.752 8.59766C58.6738 8.58984 58.584 8.58594 58.4824 8.58594C58.2324 8.58594 58.0117 8.625 57.8203 8.70312C57.6289 8.78125 57.4668 8.89062 57.334 9.03125C57.2012 9.17188 57.0957 9.33984 57.0176 9.53516C56.9434 9.72656 56.8945 9.9375 56.8711 10.168L56.5664 10.3438C56.5664 9.96094 56.6035 9.60156 56.6777 9.26562C56.7559 8.92969 56.875 8.63281 57.0352 8.375C57.1953 8.11328 57.3984 7.91016 57.6445 7.76562C57.8945 7.61719 58.1914 7.54297 58.5352 7.54297C58.6133 7.54297 58.7031 7.55273 58.8047 7.57227C58.9062 7.58789 58.9766 7.60547 59.0156 7.625Z" fill="white"/>
        </svg>
    ]]),


    no = 'src/assets/notify/no.png',
    yes = 'src/assets/notify/yes.png',

}

function getMembersInGroup(id) 
    local members = {}
    for i,v in ipairs(getElementsByType('player')) do 
        if getElementData(v, 'JobGroup') == id then 
            table.insert(members, v)
        end
    end
    return members, #members
end

function getJobAssets ( job )
    for i,v in ipairs(cfg.jobs) do 
        if v.element == job then 
            return cfg.jobs[i]
        end
    end
    return false
end
