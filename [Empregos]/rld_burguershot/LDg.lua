--[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedrooooo#1554
--]]

config = {
    jobBlip = {1199.42944, -919.23395, 43.11382, 42}; -- // x, y, z, icon 

    markerColor = {154, 196, 229, 90};

    entrance = {1199.42944, -919.23395, 43.11382 - 1}; -- // x, y, z da entrada

    enterService = {379.1635, -65.039, 1001.5078 - 1, 10, 0}; -- // x, y, z, interior, dimensao do lugar para iniciar serviço 

    foodsMarkers = {
        ['Batata Frita'] = {376.362, -61.4102, 1001.5078}; -- // x, y, z
        ['Hamburguer'] = {376.4701, -59.391, 1001.5078}; -- // x, y, z
        ['Refrigerante'] = {375.2834, -64.7498, 1001.5078}; -- // x, y, z
        ['Bandeja'] = {379.7322, -57.6343, 1001.5078}; -- // x, y, z
        ['Entrega'] = {376.7334, -65.849, 1001.5078}; -- // x, y, z
    };

    foodsObjects = {
        ['Batata Frita'] = 2768; 
        ['Hamburguer'] = 2703; 
        ['Refrigerante'] = 2601;      
    };

    foodsTexts = {
        ['Batata Frita'] = 'Fritando a batata'; 
        ['Hamburguer'] = 'Fritando o hamburguer'; 
        ['Refrigerante'] = 'Colocando refrigerante no copo';    
    };

    money = {487, 520}; -- // salario vai variar entre esses dois valores 
}   

r, g, b, a = 100, 100, 100, 90 -- coor do marker 

function message(player, type, text, text2) 
    exports['FR_DxMessages']:addBox(player, type, text, text2)
end