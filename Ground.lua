Ground = Class{}

function Ground:init()
	self.groundImage = love.graphics.newImage('images/scrolling background.png')
	self.x = 0
	self.y = 0
	self.wrapX = 3840
	self.wrapY = 2160
end

function Ground:update(dt)

end

function Ground:render()
	love.graphics.setColor(WHITE)
	self.x = -saveState.mapX % self.wrapX - self.wrapX
	self.y = -saveState.mapY % self.wrapY - self.wrapY
	love.graphics.draw(self.groundImage, self.x, self.y, 0)
end