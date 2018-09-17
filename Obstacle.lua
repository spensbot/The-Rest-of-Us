Obstacle = Class{}

local images = {
	['barrier'] = {love.graphics.newImage('images/barrier.png')},
	['chest'] = {love.graphics.newImage('images/chest_yellow.png'), love.graphics.newImage('images/chest_pink.png')},
	['terrain'] = {}
}
for i=1,8 do images['terrain'][i] = love.graphics.newImage('images/terrain'..tostring(i)..'.png') end

function Obstacle:init(mapX, mapY, width, type)
	self.type = type
	self.imageId = math.random(#images[type])
	self.mapX = mapX
	self.mapY = mapY
	self.width = width
	self.imageWidth = images[type][self.imageId]:getWidth()
	self.scale = self.width/self.imageWidth
	self.screenX = 0
	self.screenY = 0
	self.inventory = inventory or nil
	if inventory ~= nil then
		self.searchInterface = SearchInterface(self.inventory)
	end
end

function Obstacle:update(dt)
	self.screenX, self.screenY = transformMapToScreen(self.mapX,self.mapY)
	if self.inventory ~= nil then 
		self.searchInterface:update(dt, self.screenX, self.screenY)
		addDebug('updating search interface', true)
	end
	addDebug('updating obstacle', true)
end

function Obstacle:render()
	love.graphics.draw(images[self.type][self.imageId], self.screenX, self.screenY, 0, self.scale)
	if self.inventory ~= nil then 
		self.searchInterface:render()
	end
end