TabelaVeiculo = {}
VeiculosTXD = {}

addEvent("MeloSCR:CriarCarroMontadora", true)
addEventHandler("MeloSCR:CriarCarroMontadora", root, 
function (restarttable)
    if restarttable then 
        VeiculosTXD = {}
    end 
    vehicle = createVehicle(getRandomVehicle(math.random(1, getAllVehicles())), 340.28949, 43.94639, 990.55627, 0, 0, 90)
    setElementFrozen(vehicle, true)
    setVehicleDamageProof(vehicle, true)
    if engineRestoreModel(getElementModel(vehicle)) then 
        table.insert(VeiculosTXD, getElementModel(vehicle))
    end
    TabelaVeiculo[vehicle] = {}
    setTimer(
        function ()
            MaxConteudosTabela = 0
            for k in pairs ( getVehicleComponents ( vehicle ) ) do
                if partTable[k] then 
                    MaxConteudosTabela = MaxConteudosTabela + 1
                    TabelaVeiculo[vehicle][k] = "invisivel"
                    setVehicleComponentVisible(vehicle, k, false)
                end 
            end 
            ProcessamentoPeca(vehicle)
        end, 200, 1
    )
end)

addEvent("MeloSCR:DestruirCarroMontadora", true)
addEventHandler("MeloSCR:DestruirCarroMontadora", root, 
function (restartvehicles)
    if vehicle then 
        TabelaVeiculo[vehicle] = nil
        if isElement(vehicle) then 
            destroyElement(vehicle)
        end 
    end 
    if MarkerPegarPeca and isElement(MarkerPegarPeca) then destroyElement(MarkerPegarPeca) end
    if MarkerColocarPeca and isElement(MarkerColocarPeca) then destroyElement(MarkerColocarPeca) end
    if vehicleinv and isElement(vehicleinv) then 
        destroyElement(vehicleinv)
    end 
    if restartvehicles then 
        removeEventHandler("onClientRender", root, EfeitoMover) 
    end 
end)

addCommandHandler("teste", 
function ()
    triggerEvent("MeloSCR:CriarCarroMontadora", localPlayer)
end)



function ProcessamentoPeca(vehicle)
    ContagemTabela = 0
    for i,v in pairs(TabelaVeiculo[vehicle]) do 
        ContagemTabela = ContagemTabela + 1
        if v == "invisivel" then 
            TabelaVeiculo[vehicle][i] = "visivel"
            tickDrive = getTickCount()
            pecaatual = i
            vehicleinv = createVehicle(getElementModel(vehicle), 353.75824, 43.64356, 991.42560, config.RandomCarros[getElementModel(vehicle)].PosicaoEsteira[pecaatual][7], config.RandomCarros[getElementModel(vehicle)].PosicaoEsteira[pecaatual][8], config.RandomCarros[getElementModel(vehicle)].PosicaoEsteira[pecaatual][9])
            setElementFrozen(vehicleinv, true)
            setElementCollisionsEnabled(vehicleinv, false)
            setTimer(
                function ()
                    for k in pairs ( getVehicleComponents ( vehicleinv ) ) do
                        if k ~= i then 
                            setVehicleComponentVisible(vehicleinv, k, false)
                        end 
                    end 
                end, 100, 1)
            addEventHandler("onClientRender", root, EfeitoMover)
            setTimer(
                function ()
                    removeEventHandler("onClientRender", root, EfeitoMover) 
                    --MarkerPegarPeca = exports["frp_marker"]:createMarker("padrao2", Vector3 {347.36505, 43.76044, 990.55627-0.9})
                    MarkerPegarPeca = createMarker(347.36505, 43.76044, 990.55627-0.9, "cylinder", 1.1, 0, 0, 0, 0)
                    setElementData(MarkerPegarPeca, "markerData", {
                        title = "Pegar",
                        desc = "Pegar peças",
                        icon = "padrao"
                    })
                    addEventHandler("onClientMarkerHit", MarkerPegarPeca, 
                    function ()
                        destroyElement(source)
                        setPedAnimation(localPlayer, "carry", "liftup", 1000, false, false, false, false)
                        setTimer(
                            function ()
                                setPedAnimation(localPlayer, "carry", "crry_prtial", 1, false, false, true)
                                exports['pAttach']:attach(vehicleinv, localPlayer, unpack(config.RandomCarros[getElementModel(vehicle)].PosicaoPegar[pecaatual]))
                                for i,v in pairs(partTable) do 
                                    if i == pecaatual then 
                                        TablePos = config.RandomCarros[getElementModel(vehicle)].PosicaoMarkers[pecaatual]
                                        local cx, cy, cz = getVehicleComponentPosition(vehicle, pecaatual, "world")
                                        local cx, cy, cz = cx+TablePos[1], cy+TablePos[2], cz+TablePos[3]
                                        local _, _, ground = getElementPosition(localPlayer)
                                        -- = exports["frp_marker"]:createMarker("padrao2", Vector3 {cx, cy, 990.55627-0.9})
                                        MarkerColocarPeca = createMarker(cx, cy, 990.55627-0.9, "cylinder", 1.1, 0, 0, 0, 0)
                                        setElementData(MarkerColocarPeca, "markerData", {
                                            title = "Colocar",
                                            desc = "Colocar peça",
                                            icon = "padrao"
                                        })
                                        addEventHandler("onClientMarkerHit", MarkerColocarPeca, 
                                        function ()
                                            setPedAnimation(localPlayer, "carry", "putdwn", 1000, false, false, false, false)   
                                            destroyElement(source)
                                            destroyElement(vehicleinv)
                                            setVehicleComponentVisible(vehicle, pecaatual, true)
                                            triggerServerEvent("MeloSCR:DarDinheiroPlayerMontadora", localPlayer, getElementModel(vehicle))
                                            ProcessamentoPeca(vehicle)
                                        end)
                                        break 
                                    end 
                                end 
                            end, 500, 1
                        )
                    end)
                end, config.TempoEsteira * 1000, 1
            )
            break 
        elseif ContagemTabela == MaxConteudosTabela then 
            if isElement(vehicleinv) and vehicleinv then
                destroyElement(vehicleinv)
            end
            if buildPed then destroyElement(buildPed) end
            buildPed = createPed(50, 1707.35657, 953.42554, 10.82031)
            setPedControlState(buildPed, "forwards", true)
            setPedControlState(buildPed, "walk", true)
            setTimer(
                function ()
                    warpPedIntoVehicle(buildPed, vehicle)
                    setElementFrozen(vehicle, false)
                    alpha = 250
                    speed = 0
                    TimerAnimacao = setTimer(function()
                        if vehicle then
                            alpha = alpha - 10
                            speed = speed + 1
                            setElementAlpha(vehicle, alpha)
                            setElementAlpha(buildPed, alpha)
                            setElementVelocity(vehicle, -speed / 100, 0, 0)
                            local _, repeticao = getTimerDetails(TimerAnimacao)
                            if repeticao == 1 then 
                                TabelaVeiculo[vehicle] = nil
                                destroyElement(vehicle)
                                triggerEvent("MeloSCR:CriarCarroMontadora", localPlayer)
                            end 
                        end
                    end, 50, 25)
                end, 1500, 1
            )
            
        end 
    end 
end 

function EfeitoMover()
    local posX, posY, posZ = interpolateBetween(config.RandomCarros[getElementModel(vehicle)].PosicaoEsteira[pecaatual][1], config.RandomCarros[getElementModel(vehicle)].PosicaoEsteira[pecaatual][2], config.RandomCarros[getElementModel(vehicle)].PosicaoEsteira[pecaatual][3], config.RandomCarros[getElementModel(vehicle)].PosicaoEsteira[pecaatual][4], config.RandomCarros[getElementModel(vehicle)].PosicaoEsteira[pecaatual][5], config.RandomCarros[getElementModel(vehicle)].PosicaoEsteira[pecaatual][6], ((getTickCount() - tickDrive) / (config.TempoEsteira * 1000)), 'Linear')
    setElementPosition(vehicleinv, posX, posY, posZ)
end 

function getRandomVehicle(contagemdesejada)
    Contagem = 0
    for i,v in pairs(config.RandomCarros) do 
        Contagem = Contagem + 1
        if contagemdesejada == Contagem then 
            return i
        end 
    end 
end 

function getAllVehicles()
    Contagem = 0
    for i,v in pairs(config.RandomCarros) do 
        Contagem = Contagem + 1
    end 
    return Contagem
end 