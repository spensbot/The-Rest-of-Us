Enemy = Class{}

function Enemy:init(identifier)
	self.identifier = identifier
	self.data = saveState.enemyData[identifier]
	self.specs = enemyTypes[self.data.type]
	self.image = love.graphics.newImage(self.specs.ignorantImagePath)
	self.shadowImage = love.graphics.newImage(self.specs.shadowImagePath)
	self.imageWidth = self.image:getWidth()
	self.width = self.imageWidth*self.specs.scale
	self.speed = self.specs.runSpeed
	self.dx = 0
	self.dy = 0
	self.x = 0
	self.y = 0
	self.seesPlayer = false
	self.rotation = 0
	self.angleFromPlayer = 0
	self.healthBar = ProgressBar(0,0,self.width,10)
	self.fire = false
	self.seesPlayer = false
	self.damaged = false
	self.lastHealth = self.data.health
	self.dead = false
	self.armor = Armor('Trucker Cap')
	self.weapon = Weapon('Flamethrower')

	--Assign weapon randomly from list of possible weapons
	--self.weapon = Weapon(self.specs.possibleWeapons[love.math.random(#self.specs.possibleWeapons)])
	self.inventory = {['Quartz'] = 10, [self.armor.type] = 1, ['Health Kit'] = 1}
	if self.weapon.specs.usesAmmo ~= nil then 
		self.inventory[self.weapon.specs.usesAmmo] = 10
	end
	if self.weapon.type ~= 'Fists' then
		self.inventory[self.weapon.type] = 1
	end
	self.searchInterface = SearchInterface(self.inventory)
end

function Enemy:update(dt)
	self.x, self.y = transformMapToScreen(self.data.mapX,self.data.mapY)
	self:AIUpdate(dt)
	self.weapon:update(dt, self.x, self.y, self.rotation, self.fire, false)
	self.healthBar:update(dt,self.x - self.width/2,self.y - 70,self.data.health,self.data.maxHealth)
	self.searchInterface:update(dt, self.x, self.y)
	saveState.enemyData[self.identifier] = self.data
	if self.data.health <= 0 then 
		if self.dead == false then 
			self:uponDeath()
		end
		self.dead = true 
	end
	if self.lastHealth > self.data.health then 
		self.lastHealth = self.data.health
		self.damaged = true 
		if self.data.health <= 0 then 
			self.image = love.graphics.newImage(self.specs.deadImagePath)
		end
	else 
		self.damaged = false 
	end
end

function Enemy:render()
	self.weapon:render(self.x, self.y, self.rotation)
	love.graphics.draw(self.shadowImage, self.x, self.y, 0, self.specs.scale, self.specs.scale, self.imageWidth/2, self.imageWidth/2)
	love.graphics.draw(self.image, self.x, self.y, self.rotation, self.specs.scale, self.specs.scale, self.imageWidth/2, self.imageWidth/2)
	self.armor:render(self.x, self.y, self.rotation)
end

function Enemy:renderTopLevel()
	if self.dead then
		self.searchInterface:render()
	else
		self.healthBar:render()
	end
end

function Enemy:takeDamage(damage)
	self.data.health = self.data.health - damage
	self.data.health = clamp (self.data.health, 0, self.data.maxHealth)
end

function Enemy:AIUpdate(dt)
	if self.dead then 
		self.fire = false
	else 
		local angleToPlayer, distanceToPlayer = getAngleAndDistance(self.data.mapX, self.data.mapY, saveState.mapX, saveState.mapY)

		--Determine if enemy sees player
		local visionDistance = 0
		local correctionFactor = 1 - self.specs.visionFactor * getAngleDifferenceFactor(self.rotation, angleToPlayer)
		if self.seesPlayer then
			self.rotation = angleToPlayer 
			visionDistance = self.specs.knownVision * correctionFactor
			if distanceToPlayer > visionDistance then
				self.seesPlayer = false 
				self.image = love.graphics.newImage(self.specs.ignorantImagePath)
				SOUNDS.enemyLoosesPlayer[love.math.random(#SOUNDS.enemyLoosesPlayer)]:play()
			end
		else  --Enemy doesn't currently see player
			visionDistance = self.specs.ignorantVision * correctionFactor
			if distanceToPlayer < visionDistance or self.damaged == true then 
				self.seesPlayer = true 
				self.image = love.graphics.newImage(self.specs.pursuingImagePath)
				SOUNDS.enemySeesPlayer[love.math.random(#SOUNDS.enemySeesPlayer)]:play()
			end
		end

		--Determine if the enemy is firing it's weapon
		if distanceToPlayer < self.weapon.specs.range + PLAYER_HIT_RADIUS
		and self.seesPlayer then 
			self.fire = true 
		else
			self.fire = false
		end

		--Determine enemy movement
		if self.data.type == 'drone' then
			if self.seesPlayer then 
				if distanceToPlayer > self.specs.collisionRadius + PLAYER_COLLISION_RADIUS then
					self.dx, self.dy = getTriangleLegs (self.rotation, self.speed)
				else 
					self.dx, self.dy = 0, 0
				end
			else --enemy does not see player
				self.dx, self.dy = 0, 0
			end

		elseif self.data.type == 'brawler' then 
		
		end

		self.data.mapX = self.data.mapX + self.dx * dt 
		self.data.mapY = self.data.mapY + self.dy * dt 
		for i, obstacle in pairs(global.obstacles) do
			self:collideRectangle(obstacle.mapX, obstacle.mapY, obstacle.width)
		end
	end
end

function Enemy:collideRectangle(mapX, mapY, width, height)
	local height = height or width

	--Center point of the rectangle
	local centerMapX = mapX + width/2
	local centerMapY = mapY + height/2
	local collision = false 

	--Difference between centers of the player and the rectangle
	local centerDifX = self.data.mapX - centerMapX
	local centerDifY = self.data.mapY - centerMapY

	--Check if enemy is within bounds.
	if math.abs(centerDifX) < width/2 + self.specs.collisionRadius
	and math.abs(centerDifY) < height/2 + self.specs.collisionRadius then 
		collision = true 

		--Adjust the player position to be outside the nearest border.
		if width/2 - math.abs(centerDifX) < height/2 - math.abs(centerDifY) then 
			if centerDifX > 0 then 
				self.data.mapX = self.data.mapX + (width/2 + self.specs.collisionRadius) - centerDifX
			else 
				self.data.mapX = self.data.mapX - (width/2 + self.specs.collisionRadius) - centerDifX
			end
		else 
			if centerDifY > 0 then 
				self.data.mapY = self.data.mapY + (height/2 + self.specs.collisionRadius) - centerDifY
			else 
				self.data.mapY = self.data.mapY - (height/2 + self.specs.collisionRadius) - centerDifY
			end
		end
	end

	return collision
end

function Enemy:uponDeath()
	saveState.xp = saveState.xp + 1000
end