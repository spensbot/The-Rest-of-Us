LoadGameState = Class{__includes = BaseState}

function LoadGameState:init()
	self.buttonX = WINDOW_WIDTH/2 - BUTTON_WIDTH/2
	self.firstButtonY = WINDOW_HEIGHT*1/3
	self.buttonSpacing = BUTTON_HEIGHT + PADDING*2
	self.saveSlots = {}
	self.name = ''
	self.selected = 0
	self.backButton = Button(PADDING, WINDOW_HEIGHT-PADDING-BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, 'back')
	self.saveButton = Button(self.buttonX, self.firstButtonY + self.buttonSpacing*NUM_SAVE_SLOTS, BUTTON_WIDTH, BUTTON_HEIGHT, 'Over-Write?')
	for i = 1,NUM_SAVE_SLOTS do 
		self.saveSlots[i] = Button(self.buttonX, self.firstButtonY + self.buttonSpacing*(i-1), BUTTON_WIDTH, BUTTON_HEIGHT, 'Save Slot: '..tostring(i))
	end
end

function LoadGameState:enter()
	self.name = ''
	self.selected = 0
	if newGame then
		self.saveButton:setLabel('Over-Write?')
	else
		self.saveButton:setLabel('Load')
	end
end

function LoadGameState:update(dt)
	self.backButton:update()
	if self.backButton:isPressed() then 
		stateMachine:change('start')
	end

	for i, slot in pairs(self.saveSlots) do
		slot:update()
		if slot:isPressed() then 
			self.selected = i 
		end
	end

	for key, pressed in pairs(keysPressed) do
		if key == 'backspace' then
			self.name = string.sub(self.name, 1, -2)
		elseif #key < 2 then
			self.name = self.name..key
		end
	end

	
	if self.selected > 0 then --Has the user selected a save slot?
		self.saveButton:update()
		if not newGame then
			--if allSaveStates[self.selected] == nil then 
					setErrorMessage('this save slot is empty')
			--else 
				activeSave = self.selected
				saveState = allSaveStates[activeSave]
				stateMachine:change('play')
			--end
		else
			if self.saveButton:isPressed() then
				if #self.name > 0 then 
					activeSave = self.selected
					saveState.name = self.name
					createNewSaveState()
					saveGame()
					stateMachine:change('play')
				else 
					setErrorMessage('Please Enter A Name First')
				end
			end
		end
	end
end

function LoadGameState:render()
	self.backButton:render()
	for i, slot in pairs(self.saveSlots) do
		slot:render()
		local slotInfo
		if allSaveStates[i] == nil then 
			slotInfo = 'empty'
		else 
			slotInfo = 'Name: '..allSaveStates[i].name
			slotInfo = slotInfo..'\n\nSave Date: '..allSaveStates[i].saveDate
			slotInfo = slotInfo..' | Play Time (s): '..string.format('%.0f',allSaveStates[i].playTime)
		end
		love.graphics.printf(slotInfo,
				self.buttonX + BUTTON_WIDTH + PADDING,
				self.firstButtonY + self.buttonSpacing*(i-1) - PADDING, 
				WINDOW_WIDTH, 'left')
	end

	if self.selected > 0 then 
		love.graphics.rectangle('line', self.buttonX, self.firstButtonY + self.buttonSpacing*(self.selected-1), BUTTON_WIDTH, BUTTON_HEIGHT)
		self.saveButton:render()
	end

	if newGame then 
		love.graphics.setFont(TITLE3_FONT)
		love.graphics.printf('Whats your name?', 0, 80, WINDOW_WIDTH, 'center')
		love.graphics.printf(self.name, 0, 160, WINDOW_WIDTH, 'center')
	end
end