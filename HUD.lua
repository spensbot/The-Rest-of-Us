HUD = Class{}

local healthColor = {.8,.2,.3,1}
local staminaColor = {.1,.8,.2,1}
local xpColor = {.2,.2,.9,1}
local barHeight = 10
local healthBarWidth = 400
local xpBarWidth = WINDOW_WIDTH
local healthBarX = WINDOW_WIDTH/2 - healthBarWidth/2
local healthBarY = PADDING
local xpBarX = WINDOW_WIDTH/2 - xpBarWidth/2
local xpBarY = WINDOW_HEIGHT - barHeight
local buttonWidth = 150
local buttonHeight = 30

function HUD:init()
	self.barSpacing = barHeight + PADDING2/2
	self.healthBar = ProgressBar(healthBarX, healthBarY, healthBarWidth, barHeight, healthColor)
	self.staminaBar = ProgressBar(healthBarX, healthBarY+self.barSpacing, healthBarWidth, barHeight, staminaColor)
	self.xpBar = ProgressBar(xpBarX, xpBarY, xpBarWidth, xpBarHeight, xpColor)
	self.saveButton = Button(WINDOW_WIDTH - PADDING - buttonWidth, WINDOW_HEIGHT - PADDING - buttonHeight, buttonWidth, buttonHeight, 'Save')
	self.menuButton = Button(WINDOW_WIDTH - PADDING - buttonWidth, WINDOW_HEIGHT - PADDING*2 - buttonHeight*2, buttonWidth, buttonHeight, 'Return to Menu')
	self.inventoryButton = Button(WINDOW_WIDTH - PADDING - buttonWidth, WINDOW_HEIGHT - PADDING*3 - buttonHeight*3, buttonWidth, buttonHeight, 'Inventory')
end

function HUD:update(dt)
	self.healthBar:update(dt,healthBarX, healthBarY, saveState.health, global.maxHealth)
	self.staminaBar:update(dt,healthBarX, healthBarY+self.barSpacing, saveState.stamina, global.maxStamina)
	self.xpBar:update(dt,xpBarX, xpBarY, global.xpFromLastLevel, global.xpToNextLevel)
	self.saveButton:update(dt)
	self.menuButton:update(dt)
	self.inventoryButton:update(dt)
	if self.saveButton:isPressed() then 
		saveGame()
	end
	if self.menuButton:isPressed() then 
		stateMachine:change('start')
	end
	if self.inventoryButton:isPressed() then
		saveState.inventoryOpen = not saveState.inventoryOpen
	end
end

function HUD:render()
	self.healthBar:render()
	self.staminaBar:render()
	self.xpBar:render()
	self.saveButton:render()
	self.menuButton:render()
	self.inventoryButton:render()
	self.renderAmmoCount()
	self.renderPlayerLevel()
end

function HUD:renderAmmoCount()
	local usingAmmoType = weaponTypes[saveState.weapon].usesAmmo
	local ammoString = nil
	if usingAmmoType == nil then 
		ammoString = 'Unlimited Use'
	else
		if saveState.inventory[usingAmmoType] == nil then
			ammoString = usingAmmoType..' Ammo: 0'
		else
			ammoString = usingAmmoType..' Ammo: '..saveState.inventory[usingAmmoType]
		end
	end
	love.graphics.printf(ammoString, 0, 60, WINDOW_WIDTH, 'center')
end

function HUD:renderPlayerLevel()
	love.graphics.setFont(LABEL_FONT)
	love.graphics.printf('Player Level: '..tostring(global.level), 0, WINDOW_HEIGHT -PADDING - barHeight - LABEL_FONT:getHeight(), WINDOW_WIDTH, 'center')
end