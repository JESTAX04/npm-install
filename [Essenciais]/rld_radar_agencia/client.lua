local screen = {guiGetScreenSize()}
local posw, posh = 654, 552
local posx, posy = screen[1]/2-posw/2, screen[2]/2-posh/2

_dxDrawImage = dxDrawImage
function dxDrawImage2 (x, y, w, h, ...)
    return _dxDrawImage (posx+x, posy+y, w, h, ...)
end

Map = {}
Map.__index = Map
Map.instances = {}

function Map.new(X, Y, W, H)
	local self = setmetatable({}, Map)
	self.x = X
	self.y = Y
	self.w = W
	self.h = H
	local pos = {getElementPosition(localPlayer)}
	self.posX = pos[1]
	self.posY = pos[2]
	self.posZ = pos[3]
	self.size = 90
	self.drawRange = 110 -- Distancia
	self.map = dxCreateTexture("images/map.jpg","dxt5")
	self.renderTarget = dxCreateRenderTarget(W, H, true)
	table.insert(Map.instances, self)
	return self	
end

function renderingMap (x, y, z, a)
	for k, v in pairs(Map.instances) do
		v.posX, v.posY, v.posZ = x, y, z
		v.alpha = a
		v:draw2()
	end
end

function math.map(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

function Map:draw2()
	dxSetRenderTarget(self.renderTarget, true)
		local centerX = (self.x) + (self.w/2)
		local centerY = (self.y) + (self.h/2)
		local mapSize = 3000 / (self.drawRange/60)
		local _, _, camRotZ = getElementRotation(getCamera())
		local mapPosX, mapPosY = -(math.map(self.posX+3000,0,6000,0,mapSize)-self.w/2), -(math.map(-self.posY + 3000, 0, 6000, 0, mapSize)-self.h/2)
		dxDrawImage(mapPosX, mapPosY, mapSize, mapSize, self.map, 0, -mapSize/2 - mapPosX +  self.w/2, -mapSize/2 - mapPosY + self.h/2, tocolor(255, 255, 255, 255))
	dxSetRenderTarget()	
	dxDrawImage2(self.x, self.y, self.w, self.h, self.renderTarget,0,0,0,tocolor(255, 255, 255, self.alpha))
	local width, height = 100, 100
	dxDrawImage2(self.x+self.w/2-width/2, self.y+self.h/2-height/2, width, height, "images/arrow.png", 0, 0, 0, tocolor(0, 122, 252, self.alpha))
end