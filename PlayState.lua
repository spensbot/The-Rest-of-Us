PlayState = Class{__includes = BaseState}

function PlayState:init()
	self.player = Player()
	self.map = Map()
	self.ground = Ground()
	self.hud = HUD()
	self.enemies = {}
	self.inventoryScreen = InventoryScreen()
end

function PlayState:enter()
    --MUSIC.song1:play()
    spawnEnemy(math.random(-100,100), math.random(-100,100))
    --Timer.every(5, function() spawnEnemy(math.random(-300,300), math.random(-300,300)) end)
end

function PlayState:update(dt)
	self.player:update(dt)
	self.map:update(dt)
	self.ground:update(dt)
	self.inventoryScreen:update(dt)
	
	--Update all enemies
	for i, enemy in pairs(saveState.enemyData) do
		if self.enemies[i] == nil then 
			self.enemies[i] = Enemy(i)
		end
		self.enemies[i]:update(dt)
	end

	--Check if player has damaged enemies, or if enemy has damaged player
	for i, enemy in pairs(self.enemies) do
		local enemyDamage = self.player.weapon:damageCircle(saveState.mapX, saveState.mapY, enemy.data.mapX, enemy.data.mapY, saveState.playerDirection, enemy.specs.hitRadius,dt)
		enemy:takeDamage(enemyDamage)
		local playerDamage = enemy.weapon:damageCircle(enemy.data.mapX, enemy.data.mapY, saveState.mapX, saveState.mapY, enemy.rotation, PLAYER_HIT_RADIUS, dt)
		saveState.health = saveState.health - playerDamage
	end

	--Remove enemies
	for i, enemy in pairs(saveState.enemyData) do
		if enemy.health <= 0 then
			--saveState.enemyData[i] = nil
			--self.enemies[i] = nil
		end
	end

	self.hud:update(dt)
	saveState.playTime = saveState.playTime + dt
	addDebug('lMouseDown',lMouseDown)
	self.player:updateLast(dt)
end

function PlayState:render()
	self.ground:render()
	self.map:render()
	for i,enemy in pairs(self.enemies) do
		enemy:render()
	end
	self.player:render()
	for i,enemy in pairs(self.enemies) do
		enemy:renderTopLevel()
	end

	self.hud:render()

	self.inventoryScreen:render()
	printInfo()
end