ammoTypes = {
	['9mm'] = {
		weight = 5
	},
	['7.62mm'] = {
		weight = 10
	},
	['Gasoline'] = {
		weight = 1
	}
}

weaponTypes = {
	['Rusty Knife'] = {
		minLevel = 10,
		weight = 300,
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
		minLevel = 0,
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
		minLevel = 20,
		weight = 500,
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
		minLevel = 30,
		weight = 2000,
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
		minLevel = 40,
		weight = 10000,
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

enemyTypes = {
	['drone'] = { 
		hitRadius = 45,
		collisionRadius = 45,
		ignorantVision = 500, --Distance from which AI can see player, assuming the AI doesn't currently see player.
		knownVision = 1000, --Distance at which AI will loose track of player.
		visionFactor = .5, --Factor that lowers ignorantVision distance when player is behind AI.
		runSpeed = 200,
		scale = .3,
		pursuingImagePath = 'images/enemy_pursuing.png',
		deadImagePath = 'images/enemy_dead.png',
		ignorantImagePath = 'images/enemy_ignorant.png',
		shadowImagePath = 'images/player_shadow2.png',
		level = 10
	}
}

armorTypes = {
	['None'] = {
		minLevel = 0,
		damageTakenMultiplier = 1},
	['Headband'] = {
		minLevel = 10,
		weight = 100,
		image = love.graphics.newImage('images/Headband.png'),
		damageTakenMultiplier = .9},
	['Trucker Cap'] = {
		minLevel = 20,
		weight = 200,
		image = love.graphics.newImage('images/Trucker Cap.png'),
		damageTakenMultiplier = .7},
	['Bike Helmet'] = {
		minLevel = 30,
		weight = 500,
		image = love.graphics.newImage('images/Bike Helmet.png'),
		damageTakenMultiplier = .5},
	['Football Helmet'] = {
		minLevel = 40,
		weight = 1000,
		image = love.graphics.newImage('images/Football Helmet.png'),
		damageTakenMultiplier = .3},
}

miscTypes = {
	['Health Kit'] = {
		weight = 500,
		heals = 50
		},
	['Quartz'] = {
		weight = 1
		},
	['Apple'] = {
		weight = 100,
		heals = 10
		}
}

typeDefs = {weaponTypes, ammoTypes, armorTypes, miscTypes}