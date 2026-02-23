addCommandHandler("trabalho",
function(player)
    if getElementData(player, 'Emprego') == "Lixeiro" then
        local blipinfo = createBlip(2194.34765625,-1972.5357666016,13.559261322021, 42)
		local pos = {2194.34765625,-1972.5357666016,13.559261322021}
		triggerClientEvent(player, 'Dev > createMarcador', player, "Emprego Lixeiro", pos)
        setTimer(function(player)
            if isElement(blipinfo) then
                destroyElement(blipinfo)
            end
        end, 1*60000, 1, player)
        exports['FR_DxMessages']:addBox(player, "O local de seu emprego está marcado em seu GPS com o símbolo de um 'T'.", "info")
    end
end)

function Lixeiras(source)
	local Encaminhado = getElementData(source, 'Emprego')
	if Encaminhado == "Lixeiro" then 
        exports.FR_DxMessages:addBox(source, "Lixeiras marcada no mapa!", "info")
        for i, v in ipairs(garbagePosition) do
            blip = createBlip(v[1], v[2], v[3], 29)
            setElementVisibleTo(blip, root, false)
            setTimer(destroyElement, 60000, 1, blip)
            setElementVisibleTo(blip, source, true)
        end
	end
end
addCommandHandler("lixeiras", Lixeiras)

local bags = {}

addEvent("attachBag", true)
addEventHandler("attachBag", root, function()
	bags[source] = createObject(1264, 0, 0, 0)
	setObjectScale(bags[source], 0.65)
--	exports.bone_attach:attachElementToBone(bags[source], source, 12, 0.2, 0.05, 0.2, 0, -90, 0)
	exports['pAttach']:attach(bags[source], source, 25, 0.2, 0.01, 0.2, 0, 0, 0)
	toggleControl(source, "fire", false)
	setElementData(source, "trashInHand", true)
end)

addEvent("detachBag", true)
addEventHandler("detachBag", root, function()
	setPedAnimation(source, "grenade", "weapon_throwu", -1, false, false, false, false)

	setElementData(source, "trashInHand", false)

	setTimer(function(source)
		--exports.bone_attach:detachElementFromBone(bags[source])

		if isElement(bags[source]) then
			destroyElement(bags[source])
		end

		toggleControl(source, "fire", true)
	end, 600, 1, source)
end)

addEvent("attachToVehicle", true)
addEventHandler("attachToVehicle", root, function(vehicle, pos)
--	if isElement(vehicleJob[source]) then
	if isElementAttached(source) then
		detachElements(source)
	else
		if (type (pos) == 'table' and #pos >= 1) then
		attachElements(source, vehicle, unpack(pos))
	end
--	end
end
end)

addEvent("giveTrashMoney", true)
addEventHandler("giveTrashMoney", root, function(a)
	exports.FR_DxMessages:addBox(source, "You earned $ "..a..",00 for selling the trash from your truck!", "info")
	givePlayerMoney(source, a)
end)

vehicleJob = {}

addEvent('JOAO.spawnCar', true)
addEventHandler('JOAO.spawnCar', root,
	function (action)
		if (action == 'create') then
			if not isElement(vehicleJob[source]) then
				vehicleJob[source] = createVehicle(408, 2190.8513183594,-1991.8858642578,13.546875, 0, 0, 0.45792070031166)
				setElementData(vehicleJob[source], "Owner", source)
				exports.FR_DxMessages:addBox(source, "Você pegou o caminhão com sucesso!", "info")
			end
		else
			if isElement(vehicleJob[source]) then
				destroyElement(vehicleJob[source])
				exports.FR_DxMessages:addBox(source, "Você retirou o caminhão com sucesso!", "info")
			end
		end
	end
)

addEventHandler('onPlayerQuit', root,
	function ()
		if isElement(vehicleJob[source]) then
			destroyElement(vehicleJob[source])
		end
	end
)

addEvent("FimM", true)
addEventHandler("FimM", root, function()
	local pos = {-1876.19678, -1679.76721, 21.75000}
    triggerClientEvent(source, 'Dev > createMarcador', source, "Vender Lixos", pos)
end)
