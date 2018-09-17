LoadGameState = Class{__includes = BaseState}

local buttonWidth = 150
local buttonHeight = 30
local allSaveStates = {}

function LoadGameState:init()

	self.buttonX = WINDOW_WIDTH/2 - buttonWidth/2
	self.firstButtonY = WINDOW_HEIGHT*1/3
	self.buttonSpacing = buttonHeight + PADDING*2
	self.saveSlots = {}
	self.name = ''
	self.selected = 0
	self.backButton = Button(PADDING, WINDOW_HEIGHT-PADDING-buttonHeight, buttonWidth, buttonHeight, 'back')
	self.saveButton = Button(self.buttonX, self.firstButtonY + self.buttonSpacing*NUM_SAVE_SLOTS, buttonWidth, buttonHeight, 'Over-Write?')
	for i = 1,NUM_SAVE_SLOTS do 
		self.saveSlots[i] = Button(self.buttonX, self.firstButtonY + self.buttonSpacing*(i-1), buttonWidth, buttonHeight, 'Save Slot: '..tostring(i))
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
    
    self:loadGames()
end

function LoadGameState:update(dt)
	self.backButton:update()
	if self.backButton:isPressed() then 
		stateMachine:change('start')
	end

	for slotNumber, button in pairs(self.saveSlots) do
		button:update()
		if button:isPressed() then 
			button:toggle()
			self.selected = slotNumber
		elseif self.selected ~= slotNumber then 
			button.toggled = false 
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
			if allSaveStates[self.selected] == nil then 
					setErrorMessage('this save slot is empty')
			else 
				global.activeSave = self.selected
				saveState = allSaveStates[global.activeSave]
				stateMachine:change('play')
			end
		else
			if self.saveButton:isPressed() then
				if #self.name > 0 then 
					global.activeSave = self.selected
					saveState.name = self.name
					createNewSaveState()
					self:saveGame(global.activeSave)
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
	for slotNumber, button in pairs(self.saveSlots) do
		button:render()
		local slotInfo
		if allSaveStates[slotNumber] == nil then 
			slotInfo = 'empty'
		else 
			slotInfo = 'Name: '..allSaveStates[slotNumber].name
			slotInfo = slotInfo..'\nSave Date: '..allSaveStates[slotNumber].saveDate
			slotInfo = slotInfo..' | Play Time (s): '..string.format('%.0f',allSaveStates[slotNumber].playTime)
		end
		love.graphics.printf(slotInfo,
			self.buttonX + buttonWidth + PADDING,
			self.firstButtonY + self.buttonSpacing*(slotNumber-1), 
			WINDOW_WIDTH, 'left'
		)
	end

	if self.selected > 0 then 
		love.graphics.rectangle('line', self.buttonX, self.firstButtonY + self.buttonSpacing*(self.selected-1), buttonWidth, buttonHeight)
		self.saveButton:render()
	end

	if newGame then 
		love.graphics.setFont(TITLE3_FONT)
		love.graphics.printf('Whats your name?', 0, 80, WINDOW_WIDTH, 'center')
		love.graphics.printf(self.name, 0, 160, WINDOW_WIDTH, 'center')
	end
end


---------------------------- HELPER FUNCTIONS ---------------------------------


--loads all serialized save states into a single table.
function LoadGameState:loadGames()
	for slot = 1, NUM_SAVE_SLOTS do
		if love.filesystem.exists('save'..tostring(slot)..'.lua') then 
			local chunk = love.filesystem.load('save'..tostring(slot)..'.lua')
			allSaveStates[slot] = chunk()
		end
	end
end

--Serializes 'saveState' and saves it to save_.lua file corresponding to the active save
function LoadGameState:saveGame(slotNumber)
	saveState.saveDate = os.date("%x", os.time())
	local success = love.filesystem.write('save'..tostring(slotNumber)..'.lua', Serialize(saveState))
	setErrorMessage('Game Saved in Slot: '..slotNumber)
	return success
end