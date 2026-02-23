local marker = {}
for i, v in ipairs(config.markers) do
    marker[i] = createMarker(v[1], v[2], v[3] - 1, 'cylinder', 1.5, 106, 58, 58, 0)
    if v[4] then
        setElementInterior(marker[i], v[4])
        if v[5] then
            setElementDimension(marker[i], v[5])
        end
    end
    addEventHandler('onMarkerHit', marker[i], function (player)
        if verifyElement(player, source) then
            triggerClientEvent(player, 'openAgencia', player, 'open')
        end
    end)
    addEventHandler('onMarkerLeave', marker[i], function (player)
        if verifyElement(player, source) then
            triggerClientEvent(player, 'openAgencia', player, 'close')
        end
    end)
end

blip = {}

addEvent('acceptJob', true)
addEventHandler('acceptJob', root, function (info)
    if info then
        if getElementData(source, config.keyJob) ~= info.nome then
            if (getElementData(source, config.keyLevel) or 0) >= tonumber(info.level) then
                setElementData(source, config.keyJob, info.data)
                iprint(info.data)
                config.notify('server', source, 'You started the service as '..info.nome..'.', 'success')
                if isElement(blip[source]) then
                    destroyElement(blip[source])
                end
                blip[source] = createBlip(info.position[1], info.position[2], info.position[3], 41, _, _, _, _, _, _, 100, source)
            else
                config.notify('server', source, 'You do not have the level required to get this job.', 'error')
            end
        else
            config.notify('server', source, 'You already have this job.', 'error')
        end
    end
end)

addEvent('demitirJob', true)
addEventHandler('demitirJob', root, function (info)
    if info then
        if getElementData(source, config.keyJob) == info.data then
            setElementData(source, config.keyJob, 'Desempregado')
            config.notify('server', source, 'You abandoned your job '..info.nome..'.', 'success')
            if isElement(blip[source]) then
                destroyElement(blip[source])
            end
        else
            config.notify('server', source, 'You do not work with this job.', 'error')
        end
    end
end)

function verifyElement (player, marker)
    if player and getElementType(player) == 'player' then
        if not isPedInVehicle(player) then
            if getElementInterior(player) == getElementInterior(marker) then
                if getElementDimension(player) == getElementDimension(marker) then
                    return true
                end
            end
        end
    end
    return false
end