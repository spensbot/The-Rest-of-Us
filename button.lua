Button = Class{}

BUTTON_COLOR = {.5,.5,.5, 1}
BUTTON_HOVER_COLOR = {.5, .5, .5, .5}
BUTTON_TEXT_COLOR = {1,1,1,1}
BUTTON_CORNER_RADIUS = 5

local hoverColor = {.5, .5, .5, .5}
local baseColor = {.5,.5,.5, 1}
local cornerRadius = 5
local defaultHeight = 30
local defaultWidth = 150
local textColor = {1,1,1,1}

function Button:init(x, y, width, height, label)
	self.x = x 
	self.y = y
	self.width = width
	self.height = height
	self.label = label or ""
	self.pressed = false
	self.hover = false
	self.toggled = false
end

function Button:update(dt,x,y)
	self.x = x or self.x 
	self.y = y or self.y

	--Determine if the mouse is over the button
	if mouseX > self.x 
	and mouseX < self.x + self.width 
	and mouseY > self.y 
	and mouseY < self.y + self.height then 
		self.hover = true
		lMouseDown = false
		if buttonsPressed[1] then 
			self.pressed = true
			buttonsPressed[1] = false
		else
			self.pressed = false 
		end
	else 
		self.hover = false
	end
end

function Button:render()
	--Draw button body
	if self.hover or self.toggled then
		love.graphics.setColor(hoverColor)
	else
		love.graphics.setColor(baseColor)
	end
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, cornerRadius)

	--Draw button text
	love.graphics.setColor(textColor)
	love.graphics.setFont(BUTTON_FONT)
	local fontHeight = BUTTON_FONT:getHeight()
	love.graphics.printf(self.label, self.x, self.y + (self.height - fontHeight)/2, self.width, 'center')

	--Draw button outline
	if self.toggled then 
		love.graphics.setLineWidth(2)
		love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
	end
end

function Button:setXY(x,y)
	self.x = x 
	self.y = y 
end

function Button:setLabel(label)
	self.label = label 
end

function Button:isPressed()
	return self.pressed
end

function Button:toggle()
	self.toggled = not self.toggled
end