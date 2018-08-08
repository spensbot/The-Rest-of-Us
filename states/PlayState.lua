PlayState = Class{__includes = BaseState}

function PlayState:init()
	self.saveButton = Button(WINDOW_WIDTH - PADDING - BUTTON_WIDTH, WINDOW_HEIGHT - PADDING - BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, 'Save')
	self.menuButton = Button(WINDOW_WIDTH - PADDING - BUTTON_WIDTH, WINDOW_HEIGHT - PADDING*2 - BUTTON_HEIGHT*2, BUTTON_WIDTH, BUTTON_HEIGHT, 'Return to Menu')
	self.player = Player()
	self.map = Map()
end

function PlayState:enter()
    MUSIC.song1:play()
end

function PlayState:update(dt)

	self.saveButton:update(dt)
	self.menuButton:update(dt)
	if self.saveButton:isPressed() then 
		saveGame()
	end
	if self.menuButton:isPressed() then 
		stateMachine:change('start')
	end
	self.player:update(dt)
	self.map:update(dt)

	saveState.playTime = saveState.playTime + dt
end

function PlayState:render()
	self.map:render()
	self.saveButton:render()
	self.player:render()
	self.menuButton:render()

	love.graphics.setFont(BUTTON_FONT)
	love.graphics.setColor(BUTTON_TEXT_COLOR)
	love.graphics.printf('Player Name: '..saveState.name, PADDING, PADDING, WINDOW_WIDTH, 'left')
	love.graphics.printf('Play Time: '..string.format('%.0f',saveState.playTime), PADDING, PADDING*2, WINDOW_WIDTH, 'left')
end