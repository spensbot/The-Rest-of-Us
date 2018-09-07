HUD = Class{}

local healthColor = {.8,.2,.3,1}
local staminaColor = {.1,.8,.2,1}
local xpColor = {.2,.2,.9,1}
local barHeight = 10
local healthBarWidth = 400
local xpBarWidth = 800
local healthBarX = WINDOW_WIDTH/2 - healthBarWidth/2
local healthBarY = PADDING
local xpBarX = WINDOW_WIDTH/2 - xpBarWidth/2
local xpBarY = WINDOW_HEIGHT - PADDING - barHeight

function HUD:init()
	self.barSpacing = barHeight + PADDING2/2
	self.healthBar = ProgressBar(healthBarX, healthBarY, healthBarWidth, barHeight, healthColor)
	self.staminaBar = ProgressBar(healthBarX, healthBarY+self.barSpacing, healthBarWidth, barHeight, staminaColor)
	self.xpBar = ProgressBar(xpBarX, xpBarY, xpBarWidth, xpBarHeight, xpColor)
	self.weaponSlots = WeaponSlots()
	self.saveButton = Button(WINDOW_WIDTH - PADDING - BUTTON_WIDTH, WINDOW_HEIGHT - PADDING - BUTTON_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT, 'Save')
	self.menuButton = Button(WINDOW_WIDTH - PADDING - BUTTON_WIDTH, WINDOW_HEIGHT - PADDING*2 - BUTTON_HEIGHT*2, BUTTON_WIDTH, BUTTON_HEIGHT, 'Return to Menu')
	self.inventoryButton = Button(WINDOW_WIDTH - PADDING - BUTTON_WIDTH, WINDOW_HEIGHT - PADDING*3 - BUTTON_HEIGHT*3, BUTTON_WIDTH, BUTTON_HEIGHT, 'Inventory')
end

function HUD:update(dt)
	self.healthBar:update(dt,healthBarX, healthBarY, saveState.health, saveState.maxHealth)
	self.staminaBar:update(dt,healthBarX, healthBarY+self.barSpacing, saveState.stamina, saveState.maxStamina)
	self.xpBar:update(dt,xpBarX, xpBarY, saveState.xp, 100)
	self.weaponSlots:update(dt)
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
	self.weaponSlots:render()
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
		ammoString = usingAmmoType..' Ammo: '..saveState.inventory[usingAmmoType]
	end
	love.graphics.printf(ammoString, 0, 110, WINDOW_WIDTH, 'center')
end

function HUD:renderPlayerLevel()
	love.graphics.setFont(TITLE3_FONT)
	love.graphics.printf('Player Level: '..tostring(saveState.level), 0, WINDOW_HEIGHT - PADDING - barHeight - TITLE2_FONT:getHeight(), WINDOW_WIDTH, 'center')
end