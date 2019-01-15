MapObject = Class{}
--This base class will be used to create map objects that are purely asthetic, such as terrain.
--Child classes include Barrier, Chest, Searchable, and StoryPoint.

local types = {
	['chest'] = {
		['emptyImages'] = {love.graphics.newImage('images/chest_empty.png')},
		['fullImage'] = love.graphics.newImage('images/chest_full.png')
	},
	['dropPackage'] = {
		['emptyImages'] = {love.graphics.newImage('images/dropPackage_empty.png')},
		['fullImage'] = love.graphics.newImage('images/dropPackage_full.png')
	},
	['barrier'] = {
		['emptyImages'] = {love.graphics.newImage('images/barrier.png')}
	}
}

function MapObject:init(mapX, mapY, type, width, collides, inventory)
	self.mapX = mapX
	self.mapY = mapY
	self.type = type
	self.collides = collides or false
	self.inventory = inventory or nil
	self.imageId = math.random(#types[self.type]['emptyImages'])
	self.imageWidth = types[self.type]['emptyImages'][self.imageId]:getWidth()
	self.width = width or self.imageWidth
	self.scale = self.width/self.imageWidth
	self.screenX = 0
	self.screenY = 0
	if self.inventory ~= nil then
		self.searchInterface = SearchInterface(self.inventory, self)
	end
end

function MapObject:update(dt)
	self.screenX, self.screenY = transformMapToScreen(self.mapX,self.mapY)
	if self.inventory ~= nil then 
		self.searchInterface:update(dt, self.screenX + self.width/2, self.screenY + self.width/3)
		if countElements(self.inventory) < 1 then 
			self.inventory = nil
			addDebug('inventory Elements', countElements(self.inventory))
		end
	end
end

function MapObject:render()
	if self.inventory == nil then 
		love.graphics.draw(types[self.type]['emptyImages'][self.imageId], self.screenX, self.screenY, 0, self.scale)
	else
		love.graphics.draw(types[self.type]['fullImage'], self.screenX, self.screenY, 0, self.scale)
		self.searchInterface:render()
	end
end