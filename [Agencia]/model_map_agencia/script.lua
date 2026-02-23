txd = engineLoadTXD ( "Preff.txd" ) --Coloque o nome do TXD
engineImportTXD ( txd, 4005 ) --Coloque o ID do objeto que você quer modificar
col = engineLoadCOL ( "Preff.col" ) --Coloque o nome do arquivo COL
engineReplaceCOL ( col, 4005 ) --Coloque o ID do objeto que você quer modificar
dff = engineLoadDFF ( "Preff.dff", 0 ) --Coloque o nome do DFF e não mexa nesse 0
engineReplaceModel ( dff, 4005,true ) --Coloque o ID do objeto que você quer modificar
engineSetModelLODDistance(4005, 300) --ID do objeto e a distância que ele irá carregar - distancia está como 300
setOcclusionsEnabled( false )



-----------------------------------------------------

-- Sitemiz : https://sparrow-mta.blogspot.com/
-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://youtube.com/c/SparroWMTA/

-- Discord : https://discord.gg/DzgEcvy

-----------------------------------------------------
