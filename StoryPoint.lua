StoryPoint = Class{}

local buttonWidth = 150
local buttonHeight = 30
local buttonRelX = -buttonWidth/2
local buttonRelY = -100
local inspectDistance = 300 --User distance from story point where the "inspect" button pops up
local messageBackgroundColor = {0,0,0,.4}
local messageWidth = 500
local messageHeight = 300
local messageRelX = -messageWidth/2
local messageRelY = -60

function StoryPoint:init(mapX, mapY, message)
	self.mapX = mapX
	self.mapY = mapY
	self.screenX = 0
	self.screenY = 0
	self.message = message
	self.inspectButton = Button(0,0,buttonWidth,buttonHeight,'inspect')
	self.open = false

	--Particle system setup
	self.texture = love.graphics.newImage('textures/circle_outline.png')
	self.pSystem = love.graphics.newParticleSystem(self.texture, 1000)
	self.pSystem:setSpread(math.pi/5)
	self.pSystem:setSpeed(50, 100)
	self.pSystem:setParticleLifetime(1, 2)
	self.pSystem:setColors(1,1,.2,.6,   .8,.3,.8,1,   .1,0,.3,.6)
	self.pSystem:setRadialAcceleration(15)
	self.pSystem:setSizes(.5, 3, .4)
	self.pSystem:setSpin(-5, 5)
	self.pSystem:setLinearDamping(0)
	self.pSystem:setEmissionArea('normal', 2, 10)
	self.pSystem:setDirection(-math.pi/2)
	self.pSystem:setEmissionRate(1000)
end

function StoryPoint:update(dt)
	self.screenX, self.screenY = transformMapToScreen(self.mapX,self.mapY)

	self.pSystem:setPosition(0, 0)
	self.pSystem:update(dt)

	if getDistance(saveState.mapX, saveState.mapY, self.mapX, self.mapY) < inspectDistance then 
		self.inspectButton:update(dt, self.screenX + buttonRelX, self.screenY + buttonRelY)
		if self.inspectButton.pressed then 
			self.open = not self.open
			if self.open then 
				self.inspectButton.label = 'exit'
			else 
				self.inspectButton.label = 'inspect'
			end
		end
	else
		self.open = false
	end
end

function StoryPoint:render()
	love.graphics.setColor(WHITE)
	love.graphics.draw(self.pSystem, self.screenX, self.screenY)

	if getDistance(saveState.mapX, saveState.mapY, self.mapX, self.mapY) < inspectDistance then 
		self.inspectButton:render()
		if self.open then 
			love.graphics.setColor(messageBackgroundColor)
			love.graphics.rectangle('fill', self.screenX + messageRelX, self.screenY + messageRelY, messageWidth, messageHeight)
			love.graphics.setColor(WHITE)
			love.graphics.setFont(SMALL_FONT)
			love.graphics.printf(self.message, self.screenX + messageRelX + PADDING, self.screenY + messageRelY + PADDING, messageWidth - PADDING*2, 'left')
		end
	end
end