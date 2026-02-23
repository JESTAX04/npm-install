-----------------------------------------------------------------------------------------------------------------------------------------
local Pickup_Emprego = createPickup(2397.86670, -1899.19250, 13.54688, 3, 1210, 1)
local Blip_Emprego = createBlipAttachedTo( Pickup_Emprego, 42 )
setElementData(Blip_Emprego, "blipName", "PizzaBoy")
setBlipVisibleDistance(Blip_Emprego, 150)
-----------------------------------------------------------------------------------------------------------------------------------------
Marker_Aleatorios =
 {   
	{2067.9582519531,-1656.4711914062,13.546875},
    {2015.3527832031,-1732.5573730469,14.234375},
    {898.52960205078,-1445.6381835938,14.364583969116},
    {822.48205566406,-1505.5222167969,14.397442817688},
    {738.99322509766,-1418.5144042969,13.5234375},
    {653.01837158203,-1619.9581298828,15},
    {653.59454345703,-1714.1379394531,14.764795303345},
    {315.7741394043,-1769.4300537109,4.6213355064392},
    {168.28167724609,-1768.4049072266,4.4869661331177},
    {228.06620788574,-1405.498046875,51.609375},
    {189.63720703125,-1308.1108398438,70.249420166016},
    {251.46000671387,-1220.1921386719,76.10237121582},
    {559.16564941406,-1076.3843994141,72.921989440918},
    {835.92614746094,-894.83740234375,68.768898010254},
    {1093.9449462891,-807.13293457031,107.41925048828},
    {1442.6164550781,-628.83465576172,95.718566894531},
    {2095.3608398438,-1145.0557861328,26.592920303345},
    {2148.9372558594,-1484.9167480469,26.624019622803},
 }
-----------------------------------------------------------------------------------------------------------------------------------------
veh = {}
Marker_Entregar = {}
Blip_Entregar = {}
gas = {}
colshape = {}
timerEntregar = {}
timerPegar = {}
-----------------------------------------------------------------------------------------------------------------------------------------
function InfoTrab(playerSource)
	local emprego = getElementData(playerSource, "Emprego") or "Desempregado"
	if emprego == "PizzaBoy" then
        exports.FR_DxMessages:addBox(playerSource, "Siga a marcação em sua tela para chegar no seu local de trabalho", "info")
		local pos = {2396.19580, -1912.96228, 13.54688}
		triggerClientEvent(playerSource, 'Dev > createMarcador', playerSource, "Emprego Pizzaboy", pos)
	end
end
addCommandHandler("trabalho", InfoTrab)
-----------------------------------------------------------------------------------------------------------------------------------------
function startJob(playerSource)
	if not isPedInVehicle(playerSource) then
		local Emprego = getElementData ( playerSource, "Emprego" )
		if Emprego == "PizzaBoy" then
			if not isElement(veh[playerSource]) then
				veh[playerSource] = createVehicle(448, 2383.46265, -1938.67944, 13.65437, -0, 0, 269.334)
				--triggerClientEvent(playerSource, "togglePoint", playerSource, 2383.46265, -1938.67944, 13.65437)
				setVehicleVariant(veh[playerSource], 0, 0)
		    	colshape[playerSource] = createColSphere (0, 0, 0, 0.75)
		    	attachElements(colshape[playerSource], veh[playerSource], 0, -1.5, 0)
		    	addEventHandler("onColShapeHit", colshape[playerSource], pickGas)
                exports.FR_DxMessages:addBox(playerSource, "Follow the markings on your screen to reach the customers. Pick up the Pizza from the Motorcycle when you go to deliver", "info")
				outputChatBox(" ", playerSource, 30, 144, 255, true)
				outputChatBox("#646464[EMPREGO]:#FFFFFF Type #646464/cancel #FFFFFF to cancel your job.", playerSource, 255, 255, 255, true)
				iniciarJob(playerSource)
				--setElementModel(playerSource, 7)
				addEventHandler("onPlayerQuit", playerSource, reset)
				addEventHandler("onPlayerWasted", playerSource, reset)
			else
                 exports.FR_DxMessages:addBox(playerSource, "You are already working. Type '/cancel' to end.", "info")
			end
		else
            exports.FR_DxMessages:addBox(playerSource, "Only Pizza delivery people can work here", "error")
		end
	end
end
addEventHandler("onPickupHit", Pickup_Emprego, startJob)
-----------------------------------------------------------------------------------------------------------------------------------------
function iniciarJob(playerSource)
	local Random_Pos = math.random ( #Marker_Aleatorios )
	setTimer(function()
		--Marker_Entregar[playerSource] = createMarker ( Marker_Aleatorios[Random_Pos][1], Marker_Aleatorios[Random_Pos][2], Marker_Aleatorios[Random_Pos][3] -1, "cylinder", 1.25, 30, 144, 255, 100)
		Marker_Entregar[playerSource] = createMarker(Marker_Aleatorios[Random_Pos][1], Marker_Aleatorios[Random_Pos][2], Marker_Aleatorios[Random_Pos][3]-0.9, "cylinder", 1.1, 0, 0, 0, 0)
		setElementData(Marker_Entregar[playerSource], "markerData", {
			title = "Entregar",
			desc = "Venha aqui para entregar a pizza!",
			icon = "padrao"
		})
		Blip_Entregar[playerSource] = createBlipAttachedTo( Marker_Entregar[playerSource], 0 )
		setElementVisibleTo ( Marker_Entregar[playerSource], root, false )
		setElementVisibleTo ( Marker_Entregar[playerSource], playerSource, true )
		setElementVisibleTo ( Blip_Entregar[playerSource], root, false )
		setElementVisibleTo ( Blip_Entregar[playerSource], playerSource, true )
		local pos = {Marker_Aleatorios[Random_Pos][1], Marker_Aleatorios[Random_Pos][2], Marker_Aleatorios[Random_Pos][3]}
		triggerClientEvent(playerSource, 'Dev > createMarcador', playerSource, "Entregar Pizza", pos)
		--triggerClientEvent(playerSource, "togglePoint", playerSource, Marker_Aleatorios[Random_Pos][1], Marker_Aleatorios[Random_Pos][2], Marker_Aleatorios[Random_Pos][3] -1)
		addEventHandler("onMarkerHit", Marker_Entregar[playerSource], entregar)
	end, 100, 1)
end
-----------------------------------------------------------------------------------------------------------------------------------------
function pickGas(playerSource)
	if not isPedInVehicle(playerSource) then
		if source == colshape[playerSource] then
			if not isElement(gas[playerSource]) then
				if not isTimer(timerEntregar[playerSource]) then
					setPedAnimation(playerSource, "GANGS", "prtial_hndshk_biz_01", 1.0, false)
					timerEntregar[playerSource] = setTimer(function(playerSource)
						setPedAnimation(playerSource, nil)
						toggleControl(playerSource, "action", false)
						toggleControl(playerSource, "fire", false)
						toggleControl(playerSource, "aim_weapon", false)
						toggleControl(playerSource, "sprint", false)
						toggleControl(playerSource, "enter_exit", false)
						setPedAnimation(playerSource, "CARRY", "crry_prtial", 2.1, true, true, true)
						gas[playerSource] = createObject(1582, 0, 0, 0)
						setObjectScale(gas[playerSource], 0.7)
						--exports.bone_attach:attachElementToBone(gas[playerSource], playerSource, 3, 0, 0.45, -0.01, 0, 0, 0)
						exports['pAttach']:attach(gas[playerSource], playerSource, 3, 0, 0.45, -0.01, 95, 0, 0)
                        exports.FR_DxMessages:addBox(playerSource, "Leve a Pizza até a residência do cliente", "info")
					end, 1000, 1, playerSource)
				end
			else
				if not isTimer(timerEntregar[playerSource]) then
					setPedAnimation(playerSource, "GANGS", "prtial_hndshk_biz_01", 1.0, false, false, false, true )
					timerEntregar[playerSource] = setTimer(function(playerSource)
						destroyElement(gas[playerSource])
						gas[playerSource] = nil
						toggleAllControls(playerSource, true)
						setPedAnimation(playerSource, "CARRY", "liftup", 0.0, false, false, false, false)
					end, 1000, 1, playerSource)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
function entregar(playerSource)
	if not isPedInVehicle(playerSource) then
		if source == Marker_Entregar[playerSource] then
			if isElement(gas[playerSource]) then
				if not isTimer(timerEntregar[playerSource]) then
					destroyElement(Marker_Entregar[playerSource])
					Marker_Entregar[playerSource] = nil
					destroyElement(Blip_Entregar[playerSource])
					Blip_Entregar[playerSource] = nil
					setPedAnimation( playerSource, "CARRY", "putdwn", 1.0, false, false, false, true )  
					timerEntregar[playerSource] = setTimer(function()
						local money = math.random(money1, money2)
						local exp = math.random(exp1, exp2)
						givePlayerMoney(playerSource, money)
                            exports.FR_DxMessages:addBox(playerSource, "Você recebeu "..money.." reais", "sucess")
						if getElementData(playerSource, "VIP") then
							local xp = (exp + (exp/4))
							triggerEvent("GiveExp", playerSource, playerSource, xp)
						else
							triggerEvent("GiveExp", playerSource, playerSource, exp)
						end
						destroyElement(gas[playerSource])
						gas[playerSource] = nil
						setPedAnimation( playerSource, "CARRY", "liftup", 0.0, false, false, false, false )
						toggleAllControls(playerSource, true)
                                                exports.FR_DxMessages:addBox(playerSource, "Seu próximo destino foi marcado no seu GPS", "info")
						iniciarJob(playerSource)
					end, 1000, 1)
				end
			else
                                exports.FR_DxMessages:addBox(playerSource, "Pegue Pizza da Moto", "error")
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
function cancel(source)
	local emprego = getElementData(source, "Emprego")
	if emprego == "PizzaBoy" then
		if isElement(veh[source]) then
			if isElement(gas[source]) then destroyElement(gas[source]) gas[source] = nil end
			if isElement(veh[source]) then destroyElement(veh[source]) veh[source] = nil end
			if isElement(Marker_Entregar[source]) then destroyElement(Marker_Entregar[source]) Marker_Entregar[source] = nil end
			if isElement(Blip_Entregar[source]) then destroyElement(Blip_Entregar[source]) Blip_Entregar[source] = nil end
			if isElement(colshape[source]) then destroyElement(colshape[source]) colshape[source] = nil end
			if isTimer(timerEntregar[source]) then killTimer(timerEntregar[source]) timerEntregar[source] = nil end
			if isTimer(timerPegar[source]) then killTimer(timerPegar[source]) timerPegar[source] = nil end
			setPedAnimation(source, "CARRY", "liftup", 0.0, false, false, false, false)
			toggleAllControls(source, true)
            exports.FR_DxMessages:addBox(source, "Você cancelou seu trabalho", "success")
			setElementModel(source, 0)
			removeEventHandler("onPlayerQuit", source, reset)
			removeEventHandler("onPlayerWasted", source, reset)
			triggerClientEvent(source, 'Dev > destroyMarcador', source)
		end
	end
end
addCommandHandler("cancelar", cancel)
-----------------------------------------------------------------------------------------------------------------------------------------
function reset()
	local emprego = getElementData(source, "Emprego")
	if emprego == "PizzaBoy" then
		if isElement(veh[source]) then
			if isElement(gas[source]) then destroyElement(gas[source]) gas[source] = nil end
			if isElement(veh[source]) then destroyElement(veh[source]) veh[source] = nil end
			if isElement(Marker_Entregar[source]) then destroyElement(Marker_Entregar[source]) Marker_Entregar[source] = nil end
			if isElement(Blip_Entregar[source]) then destroyElement(Blip_Entregar[source]) Blip_Entregar[source] = nil end
			if isElement(colshape[source]) then destroyElement(colshape[source]) colshape[source] = nil end
			if isTimer(timerEntregar[source]) then killTimer(timerEntregar[source]) timerEntregar[source] = nil end
			if isTimer(timerPegar[source]) then killTimer(timerPegar[source]) timerPegar[source] = nil end
			setPedAnimation(source, "CARRY", "liftup", 0.0, false, false, false, false)
			toggleAllControls(source, true)
			removeEventHandler("onPlayerQuit", source, reset)
			removeEventHandler("onPlayerWasted", source, reset)
			triggerClientEvent(source, "togglePoint", source)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------