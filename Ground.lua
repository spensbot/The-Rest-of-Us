Ground = Class{}

function Ground:init()
	self.groundImage = love.graphics.newImage('images/background 3240x2160.png')
	self.x = 0
	self.y = 0
	self.wrapX = 1080
	self.wrapY = 720
end

function Ground:update(dt)

end

function Ground:render()
	self.x = -saveState.mapX % self.wrapX - self.wrapX
	self.y = -saveState.mapY % self.wrapY - self.wrapY
	love.graphics.draw(self.groundImage, self.x, self.y, 0)
end