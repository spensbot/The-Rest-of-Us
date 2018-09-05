Weapon = Class{}

weaponTypes = {
	['Rusty Knife'] = {
		pSystem = {exists = false},
		refreshDuration = .4,
		range = 120,
		spread = math.pi/2,
		dps = 20,
		imagePath = 'images/knife.png',
		soundPaths = {'audio/blade1.wav','audio/blade2.wav','audio/blade3.wav'},
		animationDuration = .15,
		animationRotation = math.pi/2}, 
	['Fists'] = {
		pSystem = {exists = false},
		refreshDuration = .3,
		range = 80,
		spread = math.pi/2,
		dps = 10,
		imagePath = 'images/fists2.png',
		soundPaths = {'audio/punch1.wav','audio/punch2.wav'},
		animationDuration = .15,
		animationRotation = math.pi/2},
	['9mm Pistol'] = {
		usesAmmo = '9mm',
		pSystem = {exists = false},
		refreshDuration = .3,
		range = 800,
		spread = 0,
		dps = 20,
		imagePath = 'images/pistol.png',
		soundPaths = {'audio/pew.wav'},
		animationDuration = .03,
		animationRotation = math.pi/15},
	['Assault Rifle'] = {
		usesAmmo = '7.62mm',
		pSystem = {exists = false},
		refreshDuration = .1,
		range = 800,
		spread = 0,
		dps = 100,
		imagePath = 'images/assaultRifle.png',
		soundPaths = {'audio/pop1.wav','audio/pop2.wav'},
		animationDuration = .02,
		animationRotation = -math.pi/30},
	['Flamethrower'] = {
		usesAmmo = 'Gasoline',
		pSystem = {exists = true, speed = {700,1400}, lifetime = {.3,.5}, texturePath = 'textures/sparkle_cloud.png',
			colors = {.5,.5,1,.8,  .8,.1,.1,.7,  1,1,0,.5,  .4,.4,.2,.5}, sizes = {.3,4}, spin = {5,1000}, damping = 3, emissionArea = {2, 5}},
		refreshDuration = 0,
		range = 400,
		spread = math.pi/4,
		dps = 100,
		imagePath = 'images/flamethrower.png',
		soundPaths = {'audio/flames1.wav'},
		animationDuration = 1,
		animationRotation = 0,
		ammoDrain = 30} --Per second
}

local damageArcColor = {1,1,.1,.5}

function Weapon:init(type)
	self.type = type
	self.specs = weaponTypes[type]
	self.image = love.graphics.newImage(self.specs.imagePath)
	self.imageWidth = self.image:getWidth()
	self.rotation = 0
	self.fired = false
	self.showDamageArea = false
	self.applyDamage = false
	self.sounds = {}
	for i, soundPath in pairs(self.specs.soundPaths) do
		self.sounds[i] = love.audio.newSource(soundPath, 'static')
	end
	if self.specs.pSystem ['exists'] then
		self:setParticleSystem()
	end
end

function Weapon:update(dt, x, y, angle, fire)
	self:handleInput(dt, fire)
	if self.specs.pSystem['exists'] then 
		self:updateParticleSystem(dt, x, y, angle)
	end
	self:playSound(dt)
end

function Weapon:render(x,y,angle)
	self:drawDamageArea(x,y,angle)
	love.graphics.setColor(1,1,1,1)
	if self.specs.pSystem['exists'] then 
		love.graphics.draw(self.pSystem, 0, 0)
	end
	love.graphics.draw(self.image, x, y, angle + self.rotation, PLAYER_SCALE, PLAYER_SCALE, self.imageWidth/2, self.imageWidth/2)

end

function Weapon:damageCircle(mapX,mapY,hitX,hitY,aimAngle,radius,dt)
	local damage = 0
	if self.applyDamage then  
		local relativeAngle, relativeDistance = getAngleAndDistance(mapX,mapY,hitX,hitY)
		
		local allowableDifference = self.specs.spread/2 + math.atan(radius/relativeDistance)

		if relativeDistance < self.specs.range + radius then 
			if aimAngle + allowableDifference > relativeAngle
			and aimAngle - allowableDifference < relativeAngle then 
				if self.specs.refreshDuration == 0 then 
					damage = self.specs.dps * dt 
				else 
					damage = self.specs.dps * self.specs.refreshDuration
				end
			end
		end
	end
	return damage
end

function Weapon:getType()
	return self.type
end



--*************************** HELPER FUNCTIONS FOR WEAPON CLASS ***********************



function Weapon:drawDamageArea(x,y,angle)
	if DEBUG then 
		if self.showDamageArea then
			love.graphics.setColor(damageArcColor)
			if self.specs.spread > 0 then 
				love.graphics.arc('fill', x, y, self.specs.range, -self.specs.spread/2 + angle, self.specs.spread/2 + angle)
			else 
				love.graphics.setLineWidth(2)
				local x2, y2 = getRelativePoint(x, y, self.specs.range, angle)
				love.graphics.line(x, y, x2, y2)
			end
		end
	end
end

function Weapon:playSound(dt)
	if self.specs.refreshDuration == 0 then 
		--This weapon deals continuous damage
		if self.applyDamage then
			self.sounds[1]:play()
		else 
			self.sounds[1]:stop()
		end
	else
		--This weapon deals point damage
		if self.applyDamage then
			if #self.sounds > 0 then 
				local i = math.random(#self.sounds) 
				self.sounds[i]:stop()
				self.sounds[i]:play()
			end
		end
	end
end

function Weapon:setParticleSystem()
	local pTable = self.specs.pSystem
	self.texture = love.graphics.newImage(pTable['texturePath'])
	self.pSystem = love.graphics.newParticleSystem(self.texture, 10000)
	self.pSystem:setSpread(self.specs.spread)
	self.pSystem:setSpeed(pTable.speed[1], pTable.speed[2])
	self.pSystem:setParticleLifetime(pTable.lifetime[1], pTable.lifetime[2])
	self.pSystem:setColors(.5,.5,1,.6,.8,.1,.1,.5,1,1,0,.3,.4,.4,.2,.3)
	self.pSystem:setSizes(pTable.sizes[1], pTable.sizes[2])
	self.pSystem:setSpin(pTable.spin[1], pTable.spin[2])
	self.pSystem:setLinearDamping(pTable['damping'])
	self.pSystem:setEmissionArea('normal', pTable.emissionArea[1], pTable.emissionArea[2])
end

function Weapon:updateParticleSystem(dt, x, y, angle)
	local muzzleX,muzzleY = getRelativePoint(x, y, 110, angle - math.pi/19)
	self.pSystem:setPosition(muzzleX, muzzleY)
	self.pSystem:setDirection(angle)
	if self.applyDamage then 
		self.pSystem:setEmissionRate(2000)
	else
		self.pSystem:setEmissionRate(0)
	end
	self.pSystem:update(dt)
end

function Weapon:handleInput(dt, triggerPull)
	--Check if the player has ammo for this weapon, or if the weapon doesn't use ammo
	if saveState.ammo[self.specs.usesAmmo] == nil or saveState.ammo[self.specs.usesAmmo] > 0 then 

		if self.specs.refreshDuration == 0 then
			--this weapon deals continuous damage
			if triggerPull then 
				self.fired = true
				self.applyDamage = true
				self.showDamageArea = true
				--saveState.ammo[self.specs.usesAmmo] = saveState.ammo[self.specs.usesAmmo] - self.specs.ammoDrain*dt
				saveState.inventory[self.specs.usesAmmo] = clamp(saveState.inventory[self.specs.usesAmmo], 0, 100000)
			else
				self.fired = false
				self.applyDamage = false
				self.showDamageArea = false
			end
		else
			--this weapon deals single-hit damage
			if triggerPull and not self.fired then 
				self.fired = true
				self.applyDamage = true
				self.showDamageArea = true
				Timer.tween(self.specs.animationDuration, {
					[self] = {rotation = -self.specs.animationRotation}
				}): finish(function() Timer.tween(self.specs.animationDuration, {
					[self] = {rotation = 0}
				}) end)
				Timer.after(self.specs.refreshDuration, function() self.fired = false end)
				Timer.after(self.specs.animationDuration, function() self.showDamageArea = false end)
				if saveState.ammo[self.specs.usesAmmo] ~= nil then
					saveState.ammo[self.specs.usesAmmo] = saveState.ammo[self.specs.usesAmmo] - 1
				end
			else
				self.applyDamage = false 
			end
		end
	else 
		self.fired = false
		self.applyDamage = false
		self.showDamageArea = false
	end
end