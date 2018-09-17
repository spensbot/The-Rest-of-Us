StartState = Class{__includes = BaseState}

local buttonWidth = 150
local buttonHeight = 30

function StartState:init()
	self.buttonX = WINDOW_WIDTH/2 - buttonWidth/2
	self.firstButtonY = WINDOW_HEIGHT/2 - buttonHeight
	self.secondButtonY = self.firstButtonY + buttonHeight + PADDING
	self.loadButton = Button(self.buttonX, self.firstButtonY, buttonWidth, buttonHeight, 'load game')
	self.newButton = Button(self.buttonX, self.secondButtonY, buttonWidth, buttonHeight, 'new game')
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