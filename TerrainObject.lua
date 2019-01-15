TerrainObject = Class{}
--This base class will be used to create map objects that are purely asthetic, such as terrain.
--Child classes include Barrier, Chest, Searchable, and StoryPoint.

local types = {
	['terrain'] = {love.graphics.newImage('images/terrain1.png')}
}

for i=1,8 do 
	types['terrain'][i] = love.graphics.newImage('images/terrain'..tostring(i)..'.png')
end

function TerrainObject:init(mapX, mapY, type)
	self.mapX = mapX
	self.mapY = mapY
	self.type = type
	self.imageId = math.random(#types[self.type])
	self.width = types[self.type][self.imageId]:getWidth()
	self.screenX = 0
	self.screenY = 0
end

function TerrainObject:update(dt)
	self.screenX, self.screenY = transformMapToScreen(self.mapX,self.mapY)
end

function TerrainObject:render()
	love.graphics.draw(types[self.type][self.imageId], self.screenX, self.screenY)
end