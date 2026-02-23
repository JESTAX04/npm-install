MarkerEnter = {}
MarkerExit = {}

for i,v in ipairs(config.PosEntrar) do 
    MarkerEnter[i] = createMarker(v[1], v[2], v[3]-0.9, "cylinder", 1.1, 0, 0, 0, 0)
    setElementData(MarkerEnter[i], "markerData", {
        title = "Porta",
        desc = "Entrada",
        icon = "entrada"
    })
    --MarkerEnter[i] = exports["frp_marker"]:createMarker("door", Vector3 {v[1], v[2], v[3]-0.9})
    addEventHandler("onMarkerHit", MarkerEnter[i], 
    function (thePlayer)
        if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" and not isPedInVehicle(thePlayer) then 
            if getElementData(thePlayer, 'Emprego') == config["ElementData"] then
                setElementVisibleTo(root, thePlayer, false)
                setElementPosition(thePlayer, 325.36801, 37.71110, 990.55627)
                setTimer(function (thePlayer)
                    triggerClientEvent(thePlayer, "MeloSCR:CriarCarroMontadora", thePlayer, true)
                end, 200, 1, thePlayer)
            end
        end
    end)
end 

for i,v in ipairs(config.PosSair) do 
 --   MarkerExit[i] = exports["frp_marker"]:createMarker("door", Vector3 {v[1], v[2], v[3]-0.9})
    MarkerExit[i] = createMarker(v[1], v[2], v[3]-0.9, "cylinder", 1.1, 0, 0, 0, 0)
    setElementData(MarkerExit[i], "markerData", {
        title = "Porta",
        desc = "saída",
        icon = "saida"
    })
    addEventHandler("onMarkerHit", MarkerExit[i], 
    function (thePlayer)
        if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" and not isPedInVehicle(thePlayer) then 
            setElementPosition(thePlayer, v[4], v[5], v[6])
            setElementVisibleTo(thePlayer, root, true)
            triggerClientEvent(thePlayer, 'Dev > destroyMarcador', thePlayer)
            triggerClientEvent(thePlayer, "MeloSCR:DestruirCarroMontadora", thePlayer, true)
        end
    end)
end 

addEvent("MeloSCR:DarDinheiroPlayerMontadora", true)
addEventHandler("MeloSCR:DarDinheiroPlayerMontadora", root, 
function (Modelo)
    if config.RandomCarros[Modelo] then 
        local money = math.random(1000, 1010)
        givePlayerMoney(source, money)
    --    local xp = math.random(70, 140)
      --  triggerEvent("GiveExp", source, source, xp)
       -- notifyS(player, "Você Ganhou: Reais.", "info")
        exports.FR_DxMessages:addBox(source, "Você recebeu "..money.." reais", "info")
    end 
end)

addCommandHandler("trabalho",
function(player)
    if getElementData(player, 'Emprego') == config["ElementData"] then
        local blipinfo = createBlip(1702.247, 950.228, 10.82, 42)
        local pos = {1702.247, 950.228, 10.82}
        triggerClientEvent(player, 'Dev > createMarcador', player, "Emprego Montadora", pos)
	--	triggerClientEvent(player, "togglePoint", player, 1702.247, 950.228, 10.82)
        setTimer(function(player)
            if isElement(blipinfo) then
                destroyElement(blipinfo)
            end
        end, 1*60000, 1, player)
        exports.FR_DxMessages:addBox(player, "Siga a marcação em sua tela para chegar no seu local de trabalho.", "info")
    end
end)