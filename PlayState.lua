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
    --Timer.every(5, function() spawnEnemy(math.random(-300,300), math.random(-300,300)) end)
end

function PlayState:update(dt)
	if saveState.inventoryOpen then 
		dt = 0
	end
	self.player:update(dt)
	self.map:update(dt)
	self.ground:update(dt)
	self.inventoryScreen:update(dt)
	self.hud:update(dt)

	self:calculateCarryWeight()
	self:calculateSpecs(dt)
	self:updateEnemies(dt)
	
	saveState.playTime = saveState.playTime + dt
	
	self.player:updateLast(dt)
	if saveState.health < 0 then 
		stateMachine:change('death')
	end
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


----------------- HELPER FUNCTIONS ------------------------------


function PlayState:calculateCarryWeight()
	global.weight = 0
	global.categoryWeights = {0, 0, 0, 0}
	for item, quantity in pairs(saveState.inventory) do
		for category, name in ipairs(typeDefs) do
			if typeDefs[category][item] ~= nil then
				if typeDefs[category][item]['weight'] ~= nil then 
					global.categoryWeights[category] = global.categoryWeights[category] + typeDefs[category][item]['weight'] * quantity
					global.weight = global.weight + typeDefs[category][item]['weight'] * quantity
				end
			end
		end
	end
end

function PlayState:calculateSpecs(dt)
	--Calculate Damage Dealt Multiplier
	global.multipliers['Damage Dealt'] = {
		['Level'] = 1 + global.level/10
	}

	global.multipliers['Damage Taken']  = {
		['Level'] = 1/(1 + global.level/10),
		['Armor'] = armorTypes[self.player.armor.type].damageTakenMultiplier
	}

	global.multipliers['Travel Speed'] = {
		['Level'] = 1 + global.level/30,
		['Carry Weight'] = 1/(1 + global.weight/100000)
	}

	--The players level is calculated as a "y = (x)^1/2" equation.
	--It is best to offset the graph by a certain number of levels.
	--Otherwise, the player would need to gain 1 xp to advance from 0 to 1...
	if DEBUG then 
		saveState.xp = 400000
	end
	local levelOffset = 3
	local factor = .2
	global.level = self:calculateLevel(saveState.xp, factor, levelOffset)
	global.xpFromLastLevel = saveState.xp - self:calculateXP(global.level, factor, levelOffset)
	global.xpToNextLevel = self:calculateXP(global.level + 1, factor, levelOffset) - self:calculateXP(global.level, factor, levelOffset)
	--saveState.level = clamp(saveState.level, 0, LEVEL_CAP)
	global.maxHealth = 100 + global.level * 5
	global.maxStamina = 100 + global.level * 5
end

function PlayState:calculateLevel(xp, factor, levelShift)
	local xpShift = (levelShift/factor)^2
	local level = math.floor(factor * (saveState.xp + xpShift)^.5 - levelShift)
	return level
end

function PlayState:calculateXP(level, factor, levelShift)
	local xpShift = (levelShift/factor)^2
	local xp = ((level + levelShift)/factor)^2 - xpShift
	return xp
end

function PlayState:updateEnemies(dt)
	--Update all enemies
	for i, enemy in pairs(saveState.enemyData) do
		if self.enemies[i] == nil then 
			self.enemies[i] = Enemy(i)
		end
		self.enemies[i]:update(dt)
	end

	--Remove enemies based on distance from player
	for i, enemy in pairs(saveState.enemyData) do
		if enemy.health <= 0 then
			--saveState.enemyData[i] = nil
			--self.enemies[i] = nil
		end
	end

	--Check if player has damaged enemies, or if enemy has damaged player
	for i, enemy in pairs(self.enemies) do
		local enemyDamage = self.player.weapon:damageCircle(saveState.mapX, saveState.mapY, enemy.data.mapX, enemy.data.mapY, global.playerDirection, enemy.specs.hitRadius,dt)
		enemy:takeDamage(enemyDamage * calculateTotalMultiplier(global.multipliers['Damage Dealt']))
		local playerDamage = enemy.weapon:damageCircle(enemy.data.mapX, enemy.data.mapY, saveState.mapX, saveState.mapY, enemy.rotation, PLAYER_HIT_RADIUS, dt)
		saveState.health = saveState.health - playerDamage * calculateTotalMultiplier(global.multipliers['Damage Taken'])
	end
end
