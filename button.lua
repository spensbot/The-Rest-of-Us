Button = Class{}

function Button:init(x, y, width, height, label, image)
	self.x = x 
	self.y = y
	self.width = width 
	self.height = height
	self.label = label 
	self.image = image or nil
	self.pressed = false
	self.hover = false
	self.toggle = false
end

function Button:update()
	
	if mouseX > self.x 
	and mouseX < self.x + self.width 
	and mouseY > self.y 
	and mouseY < self.y + self.height then 
		self.hover = true
		if buttonsPressed[1] then 
			self.pressed = true
		else
			self.pressed = false 
		end
	else 
		self.hover = false
	end
end

function Button:render()
	if self.hover  or self.toggle then 
		love.graphics.setColor(BUTTON_HOVER_COLOR)
	else
		love.graphics.setColor(BUTTON_COLOR)
	end
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, BUTTON_CORNER_RADIUS)
	love.graphics.setColor(BUTTON_TEXT_COLOR)
	love.graphics.setFont(BUTTON_FONT)
	love.graphics.printf(self.label, self.x, self.y, self.width, 'center')
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
	self.toggle = not self.toggle
end
