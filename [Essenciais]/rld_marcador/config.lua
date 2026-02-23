--[[
    ___                           __         _____           _       __  _            
   /   |____  ___ _   _____  ____/ /___     / ___/__________(_)___  / /_(_)___  ____ _
  / /| /_  / / _ \ | / / _ \/ __  / __ \    \__ \/ ___/ ___/ / __ \/ __/ / __ \/ __ `/
 / ___ |/ /_/  __/ |/ /  __/ /_/ / /_/ /   ___/ / /__/ /  / / /_/ / /_/ / / / / /_/ / 
/_/  |_/___/\___/|___/\___/\__,_/\____/   /____/\___/_/  /_/ .___/\__/_/_/ /_/\__, /  
                                                          /_/                /____/   
]]--

-- Discord do desenvolvedor: +Azevedo#3005

cfg = {
    ['Settings'] = {
        ['MinDistance'] = 1,
    },
}

--[[ Modo de Uso.
    Criar = triggerClientEvent(player, 'Dev > createMarcador', player, type, pos);
    Deletar = triggerClientEvent(player, 'Dev > destroyMarcador', player);
]]--