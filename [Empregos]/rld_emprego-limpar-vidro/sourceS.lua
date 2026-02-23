local BlipEmprego = createBlip(-2035.967, 482.864, 38.553, 0)
setElementVisibleTo(BlipEmprego, root, false)
local BlipEmprego2 = createBlip(-2035.967, 482.864, 38.553, 42)
--setElementData(BlipEmprego2, "blipName", "Trabalho Limpador de Janelas")
setElementVisibleTo(BlipEmprego2, root, true)

function VerificarBlipEmprego(player)
	if player then
		acc = getPlayerAccount(player)
		if isGuestAccount(acc) then return end
		setElementVisibleTo(BlipEmprego, player, false )
	end
end

setTimer(
function()
	for i, pl in pairs(getElementsByType("player")) do
		if pl ~= (false or nil) then
		    if getElementData (pl, "Limpar Janelas" ) then return end
			   VerificarBlipEmprego(pl)
		end
	end
end,
60000,0)

function infos(source)
	local Encaminhado = getElementData(source, 'Emprego')
	if Encaminhado == "Limpar Janelas" then 
	if isElementVisibleTo (BlipEmprego, source) then
		triggerClientEvent(source, 'addBox', source, "Emprego desmarcado no mapa!", "info")
		setElementVisibleTo(BlipEmprego, source, false)
	else
		local pos = { -2044.798, 475.444, 35.172}
		triggerClientEvent(source, 'Dev > createMarcador', source, "Emprego Limpar Janelas", pos)
		triggerClientEvent(source, 'addBox', source, "Emprego marcado no mapa!", "info")
			setElementVisibleTo(BlipEmprego, source, true)
		end
	end
end
addCommandHandler("trabalho", infos)

addEvent("setDim", true)
addEventHandler("setDim", root, function(dim)
    setElementDimension(source, dim)
end)

addEvent("giveVidroMoney", true)
addEventHandler("giveVidroMoney", root, function()
	local money = math.random(1800, 2000)
	givePlayerMoney(source, money)
	local exp = math.random(40,80);
	if getElementData(source, "VIP") then
		local xp = (exp + (exp/4))
		triggerEvent("GiveExp", source, source, xp)
	else
		triggerEvent("GiveExp", source, source, exp)
	end
	triggerClientEvent(source, 'addBox', source, "Você limpou a janela com sucesso e ganhou R$ "..money..",00!", "success")
end)