Map = Class{}

local mapImage = love.graphics.newImage('images/background 3240x2160.png')

function Map:init()
	self.x = 0
	self.y = 0
	self.wrapX = 1080
	self.wrapY = 720
end

function Map:update(dt)

end

function Map:render()
	self.x = saveState.mapX % self.wrapX - self.wrapX
	self.y = saveState.mapY % self.wrapY - self.wrapY
	love.graphics.draw(mapImage, self.x, self.y, 0)
end