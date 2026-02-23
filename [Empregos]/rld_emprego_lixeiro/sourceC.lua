local screenX, screenY = guiGetScreenSize()

local jobPed = nil
local jobActive = false

local dropPoint = false
local x, y = (screenX/1366), (screenY/768)

local font = dxCreateFont("files/fonts/MontSerrat-Bold.ttf", x*12)
local font2 = dxCreateFont("files/fonts/MontSerrat-Regular.ttf", x*13)

local trashes = {}

addEventHandler("onClientResourceStart", resourceRoot, function()
	jobPed = createPed(0, 2194.34765625,-1972.5357666016,13.559261322021, 180)
	setElementFrozen(jobPed, true)
	generateTrashes()
end)

function generateTrashes()
	for k, v in pairs(garbagePosition) do
		trashes[k] = {}
		trashes[k].object = createObject(trashModels[1], v[1], v[2], v[3] - 0.25, 0, 0, v[4] - 180)
		trashes[k].collected = 10
		trashes[k].rubbish = 4
	end
end

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if button == "right" and state == "down" then
		if clickedElement == jobPed then
			local pX, pY, pZ = getElementPosition(localPlayer)
			if getDistanceBetweenPoints3D(pX, pY, pZ, getElementPosition(jobPed)) < 5 and getElementData(localPlayer, "Emprego") == "Lixeiro" then
				startJob()
			end
		end
	end
end)

function dx()
    local alpha = interpolateBetween(0, 0, 0, 255, 100, 0, (getTickCount() - tick)/250, "Linear")
	dxDrawImage(x * 559, y * 241, x * 247, y * 285, "files/imgs/background.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
	if isMouseInPosition(x * 596, y * 429, x * 174, y * 38) then
		dxDrawImage(x * 596, y * 429, x * 174, y * 38, "files/imgs/button.png", 0, 0, 0, tocolor(150, 150, 150, alpha))
	else
		dxDrawImage(x * 596, y * 429, x * 174, y * 38, "files/imgs/button.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
	end
	if isMouseInPosition(x * 596, y * 473, x * 174, y * 38) then
		dxDrawImage(x * 596, y * 473, x * 174, y * 38, "files/imgs/button.png", 0, 0, 0, tocolor(150, 150, 150, alpha))
	else
		dxDrawImage(x * 596, y * 473, x * 174, y * 38, "files/imgs/button.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
	end
	if jobActive then
		dxDrawText("Go out of service", x * 748, y * 475, x * 630, y * 419, tocolor(255, 255, 255, alpha), 1.00, font, "center", "center", false, false, false, false, false)
	else
		dxDrawText("Service", x * 748, y * 475, x * 630, y * 419, tocolor(255, 255, 255, alpha), 1.00, font, "center", "center", false, false, false, false, false)
	end
	if vehicleOur then
		dxDrawText("Remove_vehicle", x * 460, y * 565, x * 905, y * 419, tocolor(255, 255, 255, alpha), 1.00, font, "center", "center", false, false, false, false, false)
	else
		dxDrawText("Take_a_vehicle", x * 460, y * 565, x * 905, y * 419, tocolor(255, 255, 255, alpha), 1.00, font, "center", "center", false, false, false, false, false)
	end
	--dxDrawText("Para você iniciar o serviço, clique no botão #8B00FF'Iniciar Serviço'#CFCFCF,\ne para você pegar o veículo clique no botão #8B00FF'Pegar\nveículo'#CFCFCF.", x * 481, y * 291, x * 895, y * 376, tocolor(207, 207, 207, alpha), 1.00, font2, "center", "center", false, false, false, true, false)
	--dxDrawText("Aperte #8B00FF'backspace'#FFFFFF para sair.", x * 563, y * 454, x * 800, y * 479, tocolor(255, 255, 255, alpha), 1.00, font2, "center", "center", false, false, false, true, false)
end

function startJob()
	if not isEventHandlerAdded("onClientRender", root, dx) then
		addEventHandler("onClientRender", root, dx)
		showCursor(true)
		tick = getTickCount()
	end
end

addEventHandler("onClientClick", root,
function(_, state)
    if state == "up" then
        if isEventHandlerAdded("onClientRender", root, dx) then
			if isMouseInPosition(x * 596, y * 429, x * 174, y * 38) and not jobActive then
				addEventHandler("onClientRender", root, renderInfo)
				addEventHandler("onClientClick", root, onClick)
				addEventHandler("onClientKey", root, onKey)
				addEventHandler("onClientMarkerHit", root, onMarkerHit)
				jobActive = true
				if isElement(dropPoint) then
					destroyElement(dropPoint)
				end
				dropPoint = createMarker(2180.8369140625,-1989.0089111328,13.54981803894 - 1, "cylinder", 4, 255, 255, 255, 155)
				exports.FR_DxMessages:addBox("Você entrou em serviço!", "info")
			elseif isMouseInPosition(x * 596, y * 429, x * 174, y * 38) and jobActive then
				removeEventHandler("onClientRender", root, renderInfo)
				removeEventHandler("onClientClick", root, onClick)
				removeEventHandler("onClientKey", root, onKey)
				removeEventHandler("onClientMarkerHit", root, onMarkerHit)
				
				jobActive = false
				
				triggerServerEvent('JOAO.spawnCar', localPlayer, 'destroy')
				if isElement(dropPoint) then
					destroyElement(dropPoint)
				end
				exports.FR_DxMessages:addBox("Você saiu de serviço!", "info")
			end
			if isMouseInPosition(x * 596, y * 473, x * 174, y * 38) and not vehicleOur and jobActive then
				vehicleOur = true
				triggerServerEvent('JOAO.spawnCar', localPlayer, 'create')
			elseif isMouseInPosition(x * 596, y * 473, x * 174, y * 38) and vehicleOur and jobActive then
				vehicleOur = false
				triggerServerEvent('JOAO.spawnCar', localPlayer, 'destroy')
			end
        end
    end
end)

bindKey("backspace", "down",
function()
	if isEventHandlerAdded("onClientRender", root, dx) then
		removeEventHandler("onClientRender", root, dx)
		showCursor(false)
	end
end)

local placeFound = false

function renderInfo()
	for k, v in pairs(trashes) do
		local oX, oY, oZ = getElementPosition(v.object)

		if getDistanceBetweenPoints3D(oX, oY, oZ, getElementPosition(localPlayer)) < 3 then
			local x, y = getScreenFromWorldPosition(oX, oY, oZ)
			
			if x and y then
				if v.collected > getTickCount() then
					dxDrawText(
						"Lixos " .. k .. "\n" .. 
						"Não possui lixo nessa lixeira."
					, x, y, x, y, tocolor(255, 255, 255, 255), 1, "default-bold", "center")
				else
					dxDrawText(
						"Lixos " .. k .. "\n" .. 
						"Possui: " .. v.rubbish .. "/4"
					, x, y, x, y, tocolor(255, 255, 255, 255), 1, "default-bold", "center")
				end
			end
		end
	end

	local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
	local playerInterior = getElementInterior(localPlayer)
	local playerDimension = getElementDimension(localPlayer)

	local lastMinDistance = math.huge

	if not isElement(vehicleFound) then
		local vehicles = getElementsByType("vehicle", getRootElement(), true)

		for i = 1, #vehicles do
			local vehicle = vehicles[i]
			if getElementModel(vehicle) == 408 then

			if isElement(vehicle) and getElementInterior(vehicle) == playerInterior and getElementDimension(vehicle) == playerDimension then
				for k, v in pairs(platPosition) do
					local climbDistance = getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, getElementOffset(vehicle, v[1], v[2], v[3]))

					if climbDistance <= 1.0 and climbDistance < lastMinDistance then
						lastMinDistance = distance
						placeFound = k
						break
					else
						placeFound = false
					end
				end
			end
		end
	end
	if placeFound then
		dxDrawText("Aperte [E] para subir no veículo!", 0, 0, screenX, screenY - 20, tocolor(255, 255, 255), 1.5, "default-bold", "center", "bottom")
	end
end
end

function onClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if button == "right" and state == "down" then
		local clickedTrash = nil

		for k, v in pairs(trashes) do
			if v.object == clickedElement then
				clickedTrash = k
				break
			end
		end

		if clickedTrash then
			local posp = { getElementPosition(localPlayer) }  ---  loc player
			local pos = { getElementPosition(clickedElement) } ---- loc elemento 
			if getDistanceBetweenPoints3D(posp[1], posp[2], posp[3], pos[1], pos[2], pos[3]) <= 3 then   --- o 3 e a distancia que o jogador clicar
			if trashes[clickedTrash].collected < getTickCount() then
				if not getElementData(localPlayer, "trashInHand") then
					if trashes[clickedTrash].rubbish > 0 then
						trashes[clickedTrash].rubbish = trashes[clickedTrash].rubbish - 1

						triggerServerEvent("attachBag", localPlayer)

						if trashes[clickedTrash].rubbish <= 0 then
							trashes[clickedTrash].rubbish = 4
							trashes[clickedTrash].collected = getTickCount() + 5 * 60 * 1000
						end
					end
				end
			end
		end
	end
end
end

function onMarkerHit(player, dimMatch)
	if player == localPlayer then
		if source == dropPoint then
			if dimMatch then
				if isPedInVehicle(player) then
					local veh = getPedOccupiedVehicle(player)

					if getElementModel(veh) == 408 then
						if getElementData(veh, "trash.capacity") > 0 then
							triggerServerEvent("giveTrashMoney", player, 80 * getElementData(veh, "trash.capacity"))
							setElementData(veh, "trash.capacity", 0)
						end
					end
				end
			end
		end
	end
end

local lastUseTick = 0

function onKey(button, press)
	if press then
		if button == "mouse1" then
			local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
			local playerInterior = getElementInterior(localPlayer)
			local playerDimension = getElementDimension(localPlayer)

			local vehicleFound = false
			local lastMinDistance = math.huge

			if not isElement(vehicleFound) then
				local vehicles = getElementsByType("vehicle", getRootElement(), true)

				for i = 1, #vehicles do
					local vehicle = vehicles[i]

					if isElement(vehicle) and getElementInterior(vehicle) == playerInterior and getElementDimension(vehicle) == playerDimension then
						local dropDistance = getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, getElementOffset(vehicle, 0, -4.3, -1))

						if dropDistance <= 2.0 and dropDistance < lastMinDistance then
							lastMinDistance = distance
							vehicleFound = vehicle
						end
					end
				end
			end

			--[[if isElement(vehicleFound) then
				if getElementData(localPlayer, "trashInHand") then
					local capacity = getElementData(vehicleFound, "trash.capacity") or 0

					if not capacity then
						setElementData(vehicleFound, "trash.capacity", 0)
					end

					if capacity < 100 then
						local x, y, z = getElementOffset(vehicleFound, 0, -4.3, -1)
						triggerServerEvent("detachBag", localPlayer)

						setElementData(vehicleFound, "trash.capacity", capacity + 1)
						outputChatBox("The truck now has: " .. getElementData(vehicleFound, "trash.capacity") .. "/100 de lixos.", 0, 255, 0)
						local exp = math.random(5, 10)
						if getElementData(localPlayer, "VIP") then
							local xp = (exp + (exp/4))
							triggerServerEvent("GiveExp", localPlayer, localPlayer, xp)
						else
							triggerServerEvent("GiveExp", localPlayer, localPlayer, exp)
						end
					else
						outputChatBox("The truck is full go to the location marked on your screen.", 255, 0, 0)
						triggerServerEvent("FimM", localPlayer)
						triggerServerEvent("detachBag", localPlayer)
					end
				else
					outputChatBox("You don't have trash in your hand!", 255, 0, 0)
				end
			end]]

			if isElement(vehicleFound) then
				if getElementData(localPlayer, "trashInHand") then
					local capacity = getElementData(vehicleFound, "trash.capacity") or 0
			
					if not capacity then
						setElementData(vehicleFound, "trash.capacity", 0)
					end
			
					if capacity < 100 then
						local x, y, z = getElementOffset(vehicleFound, 0, -4.3, -1)
						triggerServerEvent("detachBag", localPlayer)
			
						setElementData(vehicleFound, "trash.capacity", capacity + 1)
						outputChatBox("The truck now has: " .. getElementData(vehicleFound, "trash.capacity") .. "/100 de lixos.", 0, 255, 0)
					else
						outputChatBox("The truck is full go to the location marked on your screen.", 255, 0, 0)
						triggerServerEvent("FimM", localPlayer)
						triggerServerEvent("detachBag", localPlayer)
					end
				else
					outputChatBox("You don't have trash in your hand!", 255, 0, 0)
				end
			end			

		elseif button == "e" then
			local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
			local playerInterior = getElementInterior(localPlayer)
			local playerDimension = getElementDimension(localPlayer)

			local vehicleFound = false
			local lastMinDistance = math.huge

			if not isElement(vehicleFound) then
				local vehicles = getElementsByType("vehicle", getRootElement(), true)

				for i = 1, #vehicles do
					local vehicle = vehicles[i]

					if isElement(vehicle) and getElementInterior(vehicle) == playerInterior and getElementDimension(vehicle) == playerDimension then
						local dropDistance = getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, getElementPosition(vehicle))

						if dropDistance <= 6.5 and dropDistance < lastMinDistance then
							lastMinDistance = distance
							vehicleFound = vehicle
						end
					end
				end
			end

			if isElement(vehicleFound) then
				triggerServerEvent("attachToVehicle", localPlayer, vehicleFound, placePosition[placeFound])
			end
		end

		lastUseTick = getTickCount()
	end
end

function replaceModel(fileName, modelID, alphaTransparency)
	if fileExists(fileName .. ".txd") then
		local txd = engineLoadTXD(fileName .. ".txd")
		engineImportTXD(txd, modelID)
	end

	if fileExists(fileName .. ".col") then
		local col = engineLoadCOL(fileName .. ".col")
		engineReplaceCOL(col, modelID)
	end
	
	if fileExists(fileName .. ".dff") then
		local dff = engineLoadDFF(fileName .. ".dff")
		engineReplaceModel(dff, modelID, alphaTransparency or false)
	end
end

local x,y = guiGetScreenSize()
function cursorInBox(dX, dY, dSZ, dM)
	if isCursorShowing() then
		local cX ,cY = getCursorPosition()
		cX,cY = cX*x , cY*y 
		if(cX >= dX and cX <= dX+dSZ and cY >= dY and cY <= dY+dM) then 
			return true, cX, cY
		else
			return false
		end
	end
end

function getElementSpeed(theElement, unit)
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function getElementOffset(element, x, y, z)
	local m = getElementMatrix(element)
	return x * m[1][1] + y * m[2][1] + z * m[3][1] + m[4][1],
		    x * m[1][2] + y * m[2][2] + z * m[3][2] + m[4][2],
		    x * m[1][3] + y * m[2][3] + z * m[3][3] + m[4][3]
end
-- Funções Uteis -- 

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

function isMouseInPosition(x,y,w,h)
	if isCursorShowing() then
		local sx,sy = guiGetScreenSize()
		local cx,cy = getCursorPosition()
		local cx,cy = (cx*sx),(cy*sy)
		if (cx >= x and cx <= x+w) and (cy >= y and cy <= y+h) then
			return true
		end
	end
end

addEventHandler('onClientResourceStart',resourceRoot,function () 
	txd = engineLoadTXD( 'files/trash.txd' ) 
	engineImportTXD( txd, 408 ) 
	dff = engineLoadDFF('files/trash.dff', 408) 
	engineReplaceModel( dff, 408 )
end)