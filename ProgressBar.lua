ProgressBar = Class{}

local backgroundColor = {0,0,0,.8}
local boxColor = {.75,.75,.75,1}
local lineWidth = 2

--referenceFunction must return min, max, and value
function ProgressBar:init(x, y, width, height, fillColor) 
	self.x = x
	self.y = y
	self.width = width or 100
	self.height = height or 10
	self.max = 1
	self.value = 1
	self.fillWidth = 1
	self.fillColor = fillColor or {.8,0,0,1}
end

function ProgressBar:update(dt,x,y,value,max)
	self.x = x
	self.y = y
	self.value = value
	self.max = max or self.max
	self.fillWidth = self.width * self.value/self.max
end

function ProgressBar:render()
	love.graphics.setColor(backgroundColor)
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
	love.graphics.setColor(self.fillColor)
	love.graphics.rectangle('fill', self.x, self.y, self.fillWidth, self.height)
	love.graphics.setLineWidth(lineWidth)
	love.graphics.setColor(boxColor)
	love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end