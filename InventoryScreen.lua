InventoryScreen = Class{}

local buttonWidth = 200
local buttonHeight = 20
local padding = 10
local backgroundColor = {0,0,0,.9}
local screenX = PADDING 
local screenY = PADDING

function InventoryScreen:init()
	self.itemButtons = {}
	for item, quantity in pairs(saveState.inventory) do
		table.insert(self.itemButtons, {item, quantity, Button(0, 0, buttonWidth, buttonHeight, item..' | '..tostring(quantity))})
	end
end

function InventoryScreen:update(dt)
	for i, button in pairs(self.itemButtons) do
		button[3]:update(dt, screenX + padding, screenY + padding * (i) + buttonHeight * (i-1))
		if button[3]:isPressed() then
			
		end
	end	
end

function InventoryScreen:render()
	love.graphics.setColor(backgroundColor)
	love.graphics.rectangle('fill', screenX, screenY, 
		buttonWidth + padding*2, (#self.itemButtons)*buttonHeight + (#self.itemButtons+1)*padding)
	for i, button in pairs(self.itemButtons) do
		button[3]:render()
	end
end