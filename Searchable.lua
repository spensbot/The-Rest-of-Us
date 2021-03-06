Searchable = Class{__includes = MapObject}

function Searchable:init(mapX, mapY, width, inventory, type)
	self.collides = true
	self.type = type
	self.imageId = 1
	self.mapX = mapX
	self.mapY = mapY
	self.width = width
	self.imageWidth = searchableTypes[type]['emptyImage']:getWidth()
	self.scale = self.width/self.imageWidth
	self.screenX = 0
	self.screenY = 0
	self.inventory = inventory
	self.searchInterface = SearchInterface(self.inventory)
end

function Searchable:update(dt)
	self.screenX, self.screenY = transformMapToScreen(self.mapX,self.mapY)
	self.searchInterface:update(dt, self.screenX, self.screenY)
end

function Searchable:render()
	love.graphics.draw(images[self.type][self.imageId], self.screenX, self.screenY, 0, self.scale)
	self.searchInterface:render()
end