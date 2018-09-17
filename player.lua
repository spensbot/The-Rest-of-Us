Player = Class{}

local playerImage = love.graphics.newImage('images/player.png')
local shadowImage = love.graphics.newImage('images/player_shadow2.png')

function Player:init()
	self.x = WINDOW_WIDTH/2
	self.y = WINDOW_HEIGHT/2
	self.imageWidth = playerImage:getWidth()
	self.width = self.imageWidth*PLAYER_SCALE
	self.playerSpeed = WALK_SPEED
	self.weapon = Weapon(saveState.weapon)
	self.armor = Armor(saveState.armor)
	self.collisionRadius = 35
	self.hitRadius = 35 
end

function Player:update(dt)
	self:switchGear(dt)
	self:handleSprinting(dt)
	self:computePlayerMovement(dt)
	for i, obstacle in pairs(global.obstacles) do
		self:collideRectangle(obstacle.mapX, obstacle.mapY, obstacle.width)
	end
	for i, enemy in pairs(saveState.enemyData) do
		self:collideCircle(enemy.mapX, enemy.mapY, PLAYER_COLLISION_RADIUS)
	end
end

--For objects to display correctly, the player needs to update before all other objects on the map.
--However, some elements of the player class need to update after others.
--In this case we need to send the lMouseDown signal to the weapon after the buttons have updated. This way the player won't fire when pressing a button.
function Player:updateLast(dt)
	self.weapon:update(dt, PLAYER_SCREEN_X, PLAYER_SCREEN_Y, global.playerDirection, lMouseDown, true)
end

function Player:render()
	love.graphics.draw(shadowImage, self.x, self.y, 0, PLAYER_SCALE, PLAYER_SCALE, self.imageWidth/2, self.imageWidth/2)
	self.weapon:render(self.x, self.y, global.playerDirection)
	love.graphics.draw(playerImage, self.x, self.y, global.playerDirection, PLAYER_SCALE, PLAYER_SCALE, self.imageWidth/2, self.imageWidth/2)
	self.armor:render(self.x, self.y, global.playerDirection)
end


--********************** HELPER FUNCTIONS FOR PLAYER *************************


function Player:collideRectangle(mapX, mapY, width, height)
	local height = height or width

	--Center point of the rectangle
	local centerMapX = mapX + width/2
	local centerMapY = mapY + height/2
	local collision = false 

	--Difference between centers of the player and the rectangle
	local centerDifX = saveState.mapX - centerMapX
	local centerDifY = saveState.mapY - centerMapY

	--Check if player is within bounds.
	if math.abs(centerDifX) < width/2 + self.collisionRadius
	and math.abs(centerDifY) < height/2 + self.collisionRadius then 
		collision = true 

		--Adjust the player position to be outside the nearest border.
		if width/2 - math.abs(centerDifX) < height/2 - math.abs(centerDifY) then 
			if centerDifX > 0 then 
				saveState.mapX = saveState.mapX + (width/2 + self.collisionRadius) - centerDifX
			else 
				saveState.mapX = saveState.mapX - (width/2 + self.collisionRadius) - centerDifX
			end
		else 
			if centerDifY > 0 then 
				saveState.mapY = saveState.mapY + (height/2 + self.collisionRadius) - centerDifY
			else 
				saveState.mapY = saveState.mapY - (height/2 + self.collisionRadius) - centerDifY
			end
		end
	end

	return collision
end

function Player:collideCircle(mapX, mapY, radius)
	local angleToCircle, distanceToCircle = getAngleAndDistance(saveState.mapX, saveState.mapY, mapX, mapY)
	if distanceToCircle < self.collisionRadius + radius then 
		local correctionDistance = self.collisionRadius + radius - distanceToCircle
		local correctionX, correctionY = getTriangleLegs (angleToCircle + math.pi, correctionDistance)
		saveState.mapX = saveState.mapX + correctionX
		saveState.mapY = saveState.mapY + correctionY
	end
end

function Player:computePlayerMovement(dt)
	--determine player velocity in X and Y based on keyboard input.
	local playerDy, playerDx = 0 , 0
	if love.keyboard.isDown('w') then 
		playerDy = -self.playerSpeed end
	if love.keyboard.isDown('a') then 
		playerDx = -self.playerSpeed end
	if love.keyboard.isDown('s') then 
		playerDy = self.playerSpeed end
	if love.keyboard.isDown('d') then 
		playerDx = self.playerSpeed end

	--Determine length and direction of player velocity
	local moveDirection, speed = getAngleAndDistance(0, 0, playerDx, playerDy)

	--Correct speed if player is traveling off axis.
		--Without this the player moves faster than "playerSpeed" when traveling diagonally.
	local correctionFactor = speed/self.playerSpeed
	if correctionFactor < 1 then 
		correctionFactor = 1
	end
	correctionFactor = 1/correctionFactor

	--Correct Speed if player is facing a different direction than they are travelling
	correctionFactor = (1 - MOVEMENT_CORRECTION_FACTOR * getAngleDifferenceFactor(global.playerDirection, moveDirection)) * correctionFactor

	playerDx = playerDx * calculateTotalMultiplier(global.multipliers['Travel Speed']) * correctionFactor
	playerDy = playerDy * calculateTotalMultiplier(global.multipliers['Travel Speed']) * correctionFactor

	--Adjust player map position based on speed
	saveState.mapX = saveState.mapX + playerDx*dt
	saveState.mapY = saveState.mapY + playerDy*dt

	global.playerDirection = getAngleAndDistance (PLAYER_SCREEN_X, PLAYER_SCREEN_Y, mouseX, mouseY)
end

function Player:handleSprinting(dt)
	if love.keyboard.isDown('lshift') then
		if saveState.stamina > 0 then  
			self.playerSpeed = SPRINT_SPEED
			saveState.stamina = saveState.stamina - STAMINA_DRAIN*dt
		else 
			saveState.stamina = -20
			self.playerSpeed = WALK_SPEED
		end
	else
		self.playerSpeed = WALK_SPEED
		saveState.stamina = saveState.stamina + STAMINA_REGEN*dt
	end
	saveState.stamina = clamp(saveState.stamina, -20, global.maxStamina)
end

function Player:switchGear(dt)
	if saveState.inventory[saveState.weapon] == nil and saveState.weapon ~= 'Fists' then
		saveState.weapon = 'Fists'
	elseif saveState.weapon ~= self.weapon.type then 
		self.weapon = Weapon(saveState.weapon)
	end

	if saveState.inventory[saveState.armor] == nil and saveState.armor ~= 'None' then
		self.armor = Armor('None')
	elseif saveState.armor ~= self.armor.type then
		self.armor = Armor(saveState.armor)
	end
end