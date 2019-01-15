SearchInterface = Class{}

local visibleDistance = 200 --Distance from the user at which the search interface becomes visible.
local buttonWidth = 110
local buttonHeight = 18
local padding = 5
local backgroundColor = {0,0,0,.85}
local relativeX = -(buttonWidth + padding * 2)/2
local relativeY = -70

function SearchInterface:init(inventory, parent)
	self.parent = parent
	self.screenX = 0
	self.screenY = 0
	self.itemButtons = {}
	self.searchButton = Button(0,0,buttonWidth,buttonHeight,'Search')
	self.inventoryOpen  = false
	self.inventory = inventory
	self.angleToPlayer = 0
	self.distanceToPlayer = 0
	for item, quantity in pairs(inventory) do
		table.insert(self.itemButtons, {item, quantity, Button(0, 0, buttonWidth, buttonHeight, item..' | '..tostring(quantity))})
	end
end

function SearchInterface:update(dt, x, y)
	self.screenX, self.screenY = x, y
	self.angleToPlayer, self.distanceToPlayer = getAngleAndDistance(self.screenX, self.screenY, PLAYER_SCREEN_X, PLAYER_SCREEN_Y)

	if self.distanceToPlayer < visibleDistance and #self.itemButtons > 0 then
		self.searchButton:update(dt, self.screenX + relativeX + padding, self.screenY + relativeY + padding)
		if self.searchButton:isPressed() then 
			if self.inventoryOpen then 
				self.inventoryOpen = false
				self.searchButton.label = 'Search'
			else 
				self.inventoryOpen = true
				self.searchButton.label = 'Exit'
			end
		end
		if self.inventoryOpen then 
			for i, button in pairs(self.itemButtons) do
				button[3]:update(dt, self.screenX + relativeX + padding, self.screenY + relativeY + padding* (i+1) + buttonHeight * (i))
				if button[3]:isPressed() then
					local item = button[1]
					local quantity = button[2]
					if saveState.inventory[item] == nil then 
						saveState.inventory[item] = quantity
					else 
						saveState.inventory[item] = saveState.inventory[item] + quantity
					end
					table.remove(self.itemButtons, i)
				end
			end
		end
	end
end

function SearchInterface:render()
	if self.distanceToPlayer < visibleDistance and #self.itemButtons > 0 then
		if self.inventoryOpen then 
			love.graphics.setColor(backgroundColor)
			love.graphics.rectangle('fill', self.screenX + relativeX, self.screenY + relativeY, 
				buttonWidth + padding*2, (#self.itemButtons+1)*buttonHeight + (#self.itemButtons+2)*padding)
			for i, button in pairs(self.itemButtons) do
				button[3]:render()
			end
		end
		self.searchButton:render()
	end
end