Obstacle = Class{}

function Obstacle:init(mapX, mapY, width)
	self.mapX = mapX
	self.mapY = mapY
	self.width = width
	self.imageWidth = IMAGES.barrier:getWidth()
	self.scale = self.width/self.imageWidth
	self.screenX = 0
	self.screenY = 0
end

function Obstacle:update(dt)
	self.screenX, self.screenY = transformMapToScreen(self.mapX,self.mapY)
end

function Obstacle:render()
	love.graphics.draw(IMAGES.barrier, self.screenX, self.screenY, 0, self.scale)
end