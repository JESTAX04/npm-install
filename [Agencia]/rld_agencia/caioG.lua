config = {
    
    keyJob = 'Emprego',
    keyLevel = 'Level',
    
    markers = {
        -- {x, y, z, int, dim}
        {1392.92944, -1692.10828, 13.65310},
    },

    empregos = {

        {
            nome = 'Garbage collector',
            data = 'Lixeiro',
            descricao = 'Retirar Os lixos da cidade para receber sua remoneração.',
            level = 0,
            position = {2195.72925, -1972.47449, 13.71875},
        },

        {
            nome = 'Pizza delivery',
            data = 'PizzaBoy',
            descricao = 'Entregar pizzas pela cidade.',
            level = 0,
            position = {2396.19580, -1912.96228, 13.54688},
        },
        
        {
            nome = 'BurguerShot',
            data = 'BurguerShot',
            descricao = 'Make hamburger for customers.',
            level = 0,
            position = {1199.42944, -919.23395, 43.11382},
        },

        {
            nome = 'Direct clenar',
            data = 'Limpar Janelas',
            descricao = 'Clean the windows of the San Fierro building.',
            level = 0,
            position = {-2035.967, 482.864, 38.553},
        },

        {
            nome = 'Vehicle automaker',
            data = 'Vehicle automaker',
            descricao = 'Monte veículos.',
            level = 0,
            position = {1707.29846, 950.15594, 10.82031},
        },
    },

    notify = function (src, element, message, type)
        if src == 'server' then
            exports['FR_DxMessages']:addBox(element, message, type)
        elseif src == 'client' then
            exports['FR_DxMessages']:addBox(message, type)
        end
    end
}