--[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedrooooo#1554
--]]

local blip = createBlip(unpack(config.jobBlip))

local entrance = createMarker(config.entrance[1], config.entrance[2], config.entrance[3], 'cylinder', 1.5, config.markerColor[1], config.markerColor[2], config.markerColor[3], config.markerColor[4])
addEventHandler('onMarkerHit', entrance, 
    function(player)    
        local emprego = getElementData(player, "Emprego") or "Desempregado"
        if emprego == "BurguerShot" then
        if (isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player)) then 
            
            if (getElementDimension(player) ~= getElementDimension(source)) then 
                return 
            end

            if (getElementInterior(player) ~= getElementInterior(source)) then 
                return 
            end
            
            fadeCamera(player, false, 1)
            setTimer(function(player)
                if (isElement(player)) then 
                    setElementPosition(player, 363.8621, -73.8537, 1001.5078)
                    setElementInterior(player, 10)
                    fadeCamera(player, true, 1)
                end
            end, 1500, 1, player)
            
        end
    end
end
)

local exit = createMarker(363.2251, -74.9801, 1001.5078 - 1, 'cylinder', 1.5, config.markerColor[1], config.markerColor[2], config.markerColor[3], config.markerColor[4])
setElementInterior(exit, 10)
addEventHandler('onMarkerHit', exit, 
    function(player)    
        if (isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player)) then 
            
            if (getElementDimension(player) ~= getElementDimension(source)) then 
                return 
            end

            if (getElementInterior(player) ~= getElementInterior(source)) then 
                return 
            end
            
            fadeCamera(player, false, 1)
            setTimer(function(player)
                if (isElement(player)) then 
                    setElementPosition(player, config.entrance[1], config.entrance[2], config.entrance[3] + 1)
                    setElementInterior(player, 0)
                    fadeCamera(player, true, 1)
                end
            end, 1500, 1, player)
            
        end
    end
)

local enterService = createMarker(config.enterService[1], config.enterService[2], config.enterService[3], 'cylinder', 1.5, config.markerColor[1], config.markerColor[2], config.markerColor[3], config.markerColor[4])
setElementInterior(enterService, config.enterService[4])
setElementDimension(enterService, config.enterService[5])

addEventHandler('onMarkerHit', enterService, 
    function(player)
        if (isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player)) then 
            
            if (getElementDimension(player) ~= getElementDimension(source)) then 
                return 
            end

            if (getElementInterior(player) ~= getElementInterior(source)) then 
                return 
            end

                triggerClientEvent(player, 'onClientDrawBurguerShotService', player)
        end 
    end
)

local working, skinCache, foodsCache, foodObject, foodName, trayObject = {}, {}, {}, {}, {}, {}
addEvent('onPlayerInteractBurguerShotService', true)
addEventHandler('onPlayerInteractBurguerShotService', root, 
    function(player, action)
        if (action == true) then 
            if not (working[player]) then
                working[player] = true
                foodsCache[player] = {}
                triggerClientEvent(player, 'onClientDrawBurguerShotMarkers', player)
                
                if (config.serviceSkin) then 
                    skinCache[player] = getElementModel(player)
                    setElementModel(player, config.serviceSkin) 
                end

                message(player, 'success', 'Success', 'Você iniciou o serviço no burguer shot.') 
            else
                message(player, 'error', 'Error', 'Você já está trabalhando.')
            end 
        else 
            if (working[player]) then 
                working[player] = nil
                triggerClientEvent(player, 'onClientRemoveBurguerShotMarkers', player) 

                if (config.serviceSkin) then 
                    if (skinCache[player]) then 
                        setElementModel(player, skinCache[player]) 
                    end
                end

                if (isElement(foodObject[player])) then 
                    destroyElement(foodObject[player])
                end
                
                if (isElement(trayObject[player])) then 
                    destroyElement(trayObject[player])
                end

                message(player, 'success', 'Success', 'Você finalizou seu serviço com sucesso.')
            else
                message(player, 'error', 'Error', 'Você não está trabalhando.')
            end 
        end
    end 
)

local foodMarker = {}
for food, v in pairs(config.foodsMarkers) do 
    foodMarker[food] = createMarker(Vector3(v), 'cylinder', 1.0, 0, 0, 0, 0)
    setElementInterior(foodMarker[food], 10)

    addEventHandler('onMarkerHit', foodMarker[food], 
        function(player)
            if (isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player)) then 

                if (getElementDimension(player) ~= getElementDimension(source)) then 
                    return 
                end

                if (getElementInterior(player) ~= getElementInterior(source)) then 
                    return 
                end


                    if (working[player]) then 
                        if (food ~= 'Bandeja' and food ~= 'Entrega') then 
                            if (isElement(foodObject[player])) then 
                                return message(player, 'error', 'Error', 'Vocé já esta com um alimento na mão.')
                            end

                            if (isElement(trayObject[player])) then 
                                return message(player, 'error', 'Error', 'Vocé já esta com um bandeja na mão.')
                            end

                            if (foodsCache[player][food]) then 
                                return message(player, 'error', 'Error', 'Você já coletou esse componente para fazer o pedido.')
                            end     

                            toggleAllControls(player, false)
                            setElementFrozen(player, true)
                            setPedAnimation(player, "CASINO", "dealone", -1, true, false, false, false, _, true)
                            triggerClientEvent(player, 'onClientDrawBurgerShotLoad', player, food)
                            message(player, 'info', 'Info', 'Você está coletando o componente.')
                            
                            setTimer(function(player, food)
                                if (isElement(player)) then 
                                    local x, y, z = getElementPosition(player)
                                    foodObject[player] = createObject(config.foodsObjects[food], x, y, z)
                                    foodsCache[player][food] = true
                                    foodName[player] = food
                                    exports['pAttach']:attach(foodObject[player], player, 26, 0, 0, 0, 0, 0, 0)
                                    toggleAllControls(player, true)
                                    setElementFrozen(player, false)
                                    setPedAnimation(player, nil)
                                    message(player, 'success', 'Success', 'Componente coletado, leve para bandeja')
                                end
                            end, 10 * 1000, 1, player, food) 
                        elseif (food == 'Bandeja') then  
                            if (isElement(foodObject[player])) then 
                                destroyElement(foodObject[player]) 
                                triggerClientEvent(player, 'onClientDrawBurguerShotTray', player, foodsCache[player] or {}, foodName[player] or 'Refrigerante') 
                            else 
                                message(player, 'error', 'Error', 'Colete um componente para organizar a bandeja.')
                            end 
                        elseif (food == 'Entrega') then 
                            if (isElement(trayObject[player])) then 
                                local money = math.random(config.money[1], config.money[2])
                                foodsCache[player] = {}
                                destroyElement(trayObject[player])
                                givePlayerMoney(player, money)
                            end
                        end 
                    else
                        message(player, 'error', 'Error', 'Inicie o serviço para produzir pedidos.')
                    end 
                end
                
        end
    )
end

addEvent('onPlayerUpdateBurguerShotTray', true)
addEventHandler('onPlayerUpdateBurguerShotTray', root, 
    function(player)
        
        local countFoods = 0 
        for food, v in pairs(foodsCache[player]) do 
            countFoods = countFoods + 1
        end

        if (countFoods < 3) then 
            return 
        end 


        local x, y, z = getElementPosition(player)
        trayObject[player] = createObject(2663, x, y, z)
        exports['pAttach']:attach(trayObject[player], player, 26, 0, 0, 0, 0, 0, 0)
        message(player, 'info', 'Info', 'Leve o pedido até o balcão.')        
    end
)

addEventHandler('onPlayerQuit', root, 
    function()
        if (isElement(foodObject[source])) then 
            destroyElement(foodObject[source])
        end

        if (isElement(trayObject[source])) then 
            destroyElement(trayObject[source])
        end
    end
)

addEventHandler('onPlayerWasted', root, 
    function()
        if (isElement(foodObject[source])) then 
            destroyElement(foodObject[source])
        end

        if (isElement(trayObject[source])) then 
            destroyElement(trayObject[source])
        end
    end
)