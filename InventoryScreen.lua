InventoryScreen = Class{}

local buttonWidth = 200
local buttonHeight = 30
local padding = 10
local backgroundColor = {0,0,0,.9}

local screenY = 100
local screenWidth = buttonWidth * 4 + padding * 5
local screenHeight = WINDOW_HEIGHT / 2
local screenX = (WINDOW_WIDTH - screenWidth)/2

local labelHeight = LABEL_FONT:getHeight()
local labelY = screenY + padding
local listY = labelY + labelHeight + padding
local categoryLabels = {'Weapons', 'Ammo', 'Armor', 'Misc'}
local categoryX = {}
for i = 1, 4 do categoryX[i] = screenX + padding + (buttonWidth + padding)*(i-1) end
local rowCounter = {0, 0, 0, 0}
local otherButtonLabels = {'Equip', '', 'Equip', 'Use'}
local otherButtonFunctions = {
	function(item) saveState.weapon = item end,
	function(item) end,
	function(item) saveState.armor = item end,
	function(item) if miscTypes[item]['heals'] ~= nil then saveState.inventory[item]=saveState.inventory[item]-1  saveState.health=saveState.health+10 end end}

local actionButtonX = WINDOW_WIDTH/2 - (buttonWidth*2 + padding)/2
local actionButtonY = screenY + screenHeight - buttonHeight - padding

function InventoryScreen:init()
	self.itemButtons = {}
	self.dropButton = Button(actionButtonX, actionButtonY, buttonWidth, buttonHeight, 'Drop')
	self.otherButton = Button(actionButtonX + buttonWidth + padding, actionButtonY, buttonWidth, buttonHeight, '')
	self.selectedItem = nil
	self.selectedCategory = nil
	self.lastOpen = saveState.inventoryOpen
	self.droppedInventory = {}
end

function InventoryScreen:uponOpen()
	
end

function InventoryScreen:uponClose()
	if self.droppedInventory ~= {} then
		table.insert(global.dropPackages, MapObject(saveState.mapX, saveState.mapY, 'dropPackage', 100, false, self.droppedInventory))
		self.droppedInventory = {}
	end
end

function InventoryScreen:update(dt)
	if saveState.inventoryOpen ~= self.lastOpen then
		self.lastOpen = saveState.inventoryOpen
		if saveState.inventoryOpen then 
			self:uponOpen()
		else
			self:uponClose()
		end
	end

	if saveState.inventoryOpen then
		rowCounter = {0,0,0,0}

		--add a button for each new item
		for item, quantity in pairs(saveState.inventory) do
			if quantity == 0 then 
				saveState.inventory[item] = nil
			end

			if self.itemButtons[item] == nil or self.itemButtons[item][2] ~= quantity then 
				self.itemButtons[item] = {Button(0, 0, buttonWidth, buttonHeight, item..' | '..tostring(quantity)), quantity}
			end
		end
		--remove buttons for any item that is no longer in the inventory
		for item, data in pairs(self.itemButtons) do
			if saveState.inventory[item] == nil then 
				self.itemButtons[item] = nil 
			end
		end

		--Iterate through each button
		for item, data in pairs(self.itemButtons) do
			quantity = data[2]
			button = data[1]
			--check each item to see if it is a weapon, ammo, armor, or misc. Then assign it's X, Y coordinates appropriately.
			for category, row in ipairs(rowCounter) do
				if typeDefs[category][item] ~= nil then --this item belongs in this category
					button:update(dt, categoryX[category], listY + (buttonHeight+padding)*rowCounter[category])
					rowCounter[category] = rowCounter[category] + 1
					if button:isPressed() then 
						button:toggle()
						if button.toggled == true then 
							self.otherButton.label = otherButtonLabels[category]
							self.selectedItem = item
							self.selectedCategory = category
						else 
							self.selectedItem = nil 
							self.selectedCategory = nil 
						end
					end
					break
				end
			end

			--Untoggle any buttons that haven't just been selected.
			if self.selectedItem ~= item then
				button.toggled = false
			end
		end	

		--Update action buttons
		if self.selectedItem ~= nil then 
			self.dropButton:update(dt)
			if self.dropButton:isPressed() then 
				if saveState.inventory[self.selectedItem] ~= nil then
					if self.droppedInventory[self.selectedItem] == nil then 
						self.droppedInventory[self.selectedItem] = 1
					else
						self.droppedInventory[self.selectedItem] = self.droppedInventory[self.selectedItem] + 1
					end
					if saveState.inventory[self.selectedItem] > 1 then
						saveState.inventory[self.selectedItem]  = saveState.inventory[self.selectedItem] - 1
					elseif saveState.inventory[self.selectedItem] == 1 then 
						saveState.inventory[self.selectedItem] = nil
					end
				end
			end
			self.otherButton:update(dt)
			if self.otherButton:isPressed() then 
				otherButtonFunctions[self.selectedCategory](self.selectedItem)
			end
		end
	end
end

function InventoryScreen:render()
	if saveState.inventoryOpen then
		--Draw background
		love.graphics.setColor(backgroundColor)
		love.graphics.rectangle('fill', screenX, screenY, screenWidth, screenHeight)
		--Draw buttons
		for i, button in pairs(self.itemButtons) do
			button[1]:render()
		end
		--Draw labels
		love.graphics.setFont(LABEL_FONT)
		for category, label in ipairs(categoryLabels) do
			love.graphics.printf(label, categoryX[category], labelY, buttonWidth, 'center')
		end
		--Draw weight total
		love.graphics.setFont(BUTTON_FONT)
		for category, x in ipairs(categoryX) do
			local weightString = string.format('Total Weight: %.0fkg', global.categoryWeights[category]/1000)
			love.graphics.printf(weightString, x, listY + (buttonHeight+padding)*rowCounter[category], buttonWidth, 'center')
		end

		--Draw action buttons
		if self.selectedItem ~= nil then
			self.dropButton:render()
			self.otherButton:render()
		end

		self:printMultipliers()
	end
end


--------------HELPER FUNCTIONS------------------


function InventoryScreen:printMultipliers()
	local multiplierY = screenY + screenHeight + padding * 2
	local multiplierHeight = 200
	local multiplierColumnWidth = 150
	local multiplierWidth = (multiplierColumnWidth + padding)*3 + padding
	local multiplierX = (WINDOW_WIDTH-multiplierWidth)/2
	local multiplierRowHeight = 20
	local columnX = 0
	local column = 0
	local rowY = 0
	local totalY = multiplierY + multiplierHeight - padding - multiplierRowHeight

	love.graphics.setColor(backgroundColor)
	love.graphics.rectangle('fill', multiplierX, multiplierY, multiplierWidth, multiplierHeight)

	love.graphics.setColor(WHITE)
	love.graphics.setFont(LABEL_FONT)
	love.graphics.printf('Current Multipliers', multiplierX, multiplierY + padding, multiplierWidth, 'center')

	for multiplierCategory, multiplierTable in pairs(global.multipliers) do
		love.graphics.setFont(LABEL_FONT2)
		rowY = multiplierY + padding + 30
		columnX = multiplierX + padding + (multiplierColumnWidth + padding)*column
		love.graphics.printf(multiplierCategory, columnX, rowY, multiplierColumnWidth, 'center')
		rowY = rowY + 10

		love.graphics.setFont(BUTTON_FONT)
		for sourceDescription, multiplier in pairs(multiplierTable) do
			local multiplierString = sourceDescription..': '..string.format('%.2f', multiplier)
			rowY = rowY + multiplierRowHeight
			love.graphics.printf(multiplierString, columnX , rowY, multiplierColumnWidth, 'center')
		end

		local totalMultiplier = calculateTotalMultiplier(global.multipliers[multiplierCategory])
		local totalMultiplierString = string.format('Total: %.2f',totalMultiplier)
		love.graphics.printf(totalMultiplierString, columnX, totalY, multiplierColumnWidth, 'center')
		column = column + 1
	end
end
