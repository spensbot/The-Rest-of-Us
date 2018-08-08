StartState = Class{__includes = BaseState}

function StartState:init()
	self.buttonX = WINDOW_WIDTH/2 - BUTTON_WIDTH/2
	self.firstButtonY = WINDOW_HEIGHT/2 - BUTTON_HEIGHT
	self.secondButtonY = self.firstButtonY + BUTTON_HEIGHT + PADDING
	self.loadButton = Button(self.buttonX, self.firstButtonY, BUTTON_WIDTH, BUTTON_HEIGHT, 'load game')
	self.newButton = Button(self.buttonX, self.secondButtonY, BUTTON_WIDTH, BUTTON_HEIGHT, 'new game')
end

function StartState:update(dt)
	self.loadButton:update(dt)
	self.newButton:update(dt)
	if self.loadButton:isPressed() then 
		newGame = false
		stateMachine:change('load')
	end
	if self.newButton:isPressed() then 
		newGame = true
		stateMachine:change('load')
	end
end

function StartState:render()
	self.loadButton:render()
	self.newButton:render()
	love.graphics.setFont(TITLE_FONT)
	love.graphics.printf(GAME_TITLE, 0, 200, WINDOW_WIDTH, 'center')
end