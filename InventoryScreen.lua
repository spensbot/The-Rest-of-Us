InventoryScreen = Class{}

local buttonWidth = 200
local buttonHeight = 30
local padding = 10
local backgroundColor = {0,0,0,.9}

local screenY = 200
local screenWidth = WINDOW_WIDTH/2
local screenHeight = WINDOW_HEIGHT - screenY * 2
local screenX = (WINDOW_WIDTH - screenWidth)/2

local labelHeight = LABEL_FONT:getHeight()
local labelY = screenY + padding
local listY = labelY + labelHeight + padding
local columnLabels = {'Weapons', 'Ammo', 'Armor', 'Misc'}
local typeDefs = {weaponTypes, ammoTypes, armorTypes, 'misc'}
local columnX = {}
for i = 1, 4 do columnX[i] = screenX + padding + (buttonWidth + padding)*(i-1) end
local rowCounter = {0, 0, 0, 0}

local actionButtonX = WINDOW_WIDTH/2 - (buttonWidth*2 + padding)/2
local actionButtonY = screenY + screenHeight - buttonHeight - padding

function InventoryScreen:init()
	self.itemButtons = {}
	self.dropButton = Button(actionButtonX, actionButtonY, buttonWidth, buttonHeight, 'Drop')
	self.otherButton = Button(actionButtonX + buttonWidth + padding, actionButtonY, buttonWidth, buttonHeight, '')
	self.itemSelected = false
end

function InventoryScreen:update(dt)
	if saveState.inventoryOpen then
		rowCounter = {0,0,0,0}
		self.itemSelected = false
		self.selectedItems = {}

		--add a button for each new item
		for description, quantity in pairs(saveState.inventory) do
			if self.itemButtons[description] == nil or self.itemButtons[description][2] ~= quantity then 
				self.itemButtons[description] = {Button(0, 0, buttonWidth, buttonHeight, description..' | '..tostring(quantity)), quantity}
			end
		end
		--remove buttons for any item that is no longer in the inventory
		for description, data in pairs(self.itemButtons) do
			if saveState.inventory[description] == nil then 
				self.itemButtons[description] = nil 
			end
		end

		--Iterate through each button
		for description, data in pairs(self.itemButtons) do
			quantity = data[2]
			button = data[1]
			--check each item to see if it is a weapon, ammo, armor, or misc. Then assign it's X, Y coordinates appropriately.
			for column, row in ipairs(rowCounter) do
				if typeDefs[column][description] ~= nil or typeDefs[column] == 'misc' then --this item belongs in this column
					button:update(dt, columnX[column], listY + (buttonHeight+padding)*rowCounter[column])
					rowCounter[column] = rowCounter[column] + 1
					if button:isPressed() then 
						button:toggle()
					end
					break
				end
			end
			if button.toggled then 
				self.itemSelected = true
				self.selectedItems['description'] = quantity
			else 
				self.selectedItems['description'] = nil
			end
		end	

		--Update action buttons
		self.dropButton:update(dt)
		if self.dropButton:isPressed() then 
			for description, quantity in pairs(self.selectedItems) do
				addDebug(description, quantity)
				saveState.inventory[description] = nil 
			end
		end
		self.otherButton:update(dt)
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
		for column, label in ipairs(columnLabels) do
			love.graphics.printf(label, columnX[column], labelY, buttonWidth, 'center')
		end
		--Draw weight total

		--Draw action buttons
		if self.itemSelected then
			self.dropButton:render()
			self.otherButton:render()
		end
	end
end