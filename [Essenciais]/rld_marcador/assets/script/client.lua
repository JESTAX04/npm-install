--[[
    ___                           __         _____           _       __  _            
   /   |____  ___ _   _____  ____/ /___     / ___/__________(_)___  / /_(_)___  ____ _
  / /| /_  / / _ \ | / / _ \/ __  / __ \    \__ \/ ___/ ___/ / __ \/ __/ / __ \/ __ `/
 / ___ |/ /_/  __/ |/ /  __/ /_/ / /_/ /   ___/ / /__/ /  / / /_/ / /_/ / / / / /_/ / 
/_/  |_/___/\___/|___/\___/\__,_/\____/   /____/\___/_/  /_/ .___/\__/_/_/ /_/\__, /  
                                                          /_/                /____/   
]]--

-- Discord do desenvolvedor: +Azevedo#3005

global = {
    funcs = {};
    type = nil,
    mPos = {},
    fonts = {
        [1] = dxCreateFont("assets/font/Roboto-Regular.ttf", 8);
    }
}

global.funcs.render = function()
    local pX, pY, pZ = getElementPosition(localPlayer)
	local distance = (getDistanceBetweenPoints3D(pX, pY, pZ, global.mPos[1], global.mPos[2], global.mPos[3])/1.5)
	local x, y = getScreenFromWorldPosition(global.mPos[1], global.mPos[2], global.mPos[3], 1, true)
    if (distance <= tonumber(cfg['Settings']['MinDistance'])) then
        global.funcs.destroy();
    end
    if x and y and global.type then
        dxDrawImage(x, y, 35, 35, 'assets/gfx/target.png', 0, 0, 0, tocolor(255, 255, 255, 255), false);
        dxDrawText(global.type.."\n("..formatNumber((string.format("%d", (distance)))).."m)", x +19, y +50, _, _, tocolor(255, 255, 255, 255), 1, global.fonts[1], "center", "center", false, false, false);
    end
end

global.funcs.create = function(type, pos)
    if not (isEventHandlerAdded('onClientRender', getRootElement(), global.funcs.render)) then
        if pos and type then
            global.type = tostring(type);
            global.mPos[1] = pos[1];
            global.mPos[2] = pos[2];
            global.mPos[3] = pos[3] +0.3;
            addEventHandler('onClientRender', root, global.funcs.render);
        end
    end
end
createEventHandler('Dev > createMarcador', getRootElement(), global.funcs.create)

global.funcs.destroy = function()
    if (isEventHandlerAdded('onClientRender', getRootElement(), global.funcs.render)) then
        removeEventHandler('onClientRender', root, global.funcs.render);
        global.mPos = {};
        global.type = nil;
    end
end
createEventHandler('Dev > destroyMarcador', getRootElement(), global.funcs.destroy)