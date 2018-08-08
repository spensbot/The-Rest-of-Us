Player = Class{}

local playerImage = love.graphics.newImage('images/player.png')

function Player:init()
	self.x = WINDOW_WIDTH/2
	self.y = WINDOW_HEIGHT/2
	self.imageWidth = playerImage:getWidth()
	self.width = self.imageWidth*PLAYER_SCALE
	self.playerSpeed = WALK_SPEED
	self.weapon = Weapon('knife')
end

function Player:update(dt)
	if love.keyboard.isDown('lshift') then 
		self.playerSpeed = SPRINT_SPEED
	else
		self.playerSpeed = WALK_SPEED
	end
	playerDy = 0
	playerDx = 0
	if love.keyboard.isDown('w') then 
		playerDy = -self.playerSpeed end
	if love.keyboard.isDown('a') then 
		playerDx = -self.playerSpeed end
	if love.keyboard.isDown('s') then 
		playerDy = self.playerSpeed end
	if love.keyboard.isDown('d') then 
		playerDx = self.playerSpeed end

	speed = (playerDx^2 + playerDy^2)^.5
	correctionFactor = (speed/self.playerSpeed)
	if correctionFactor < 1 then 
		correctionFactor = 1
	end
	playerDx = playerDx/correctionFactor
	playerDy = playerDy/correctionFactor
	saveState.mapX = saveState.mapX - playerDx*dt
	saveState.mapY = saveState.mapY - playerDy*dt

	if mouseRelativeX == 0 and mouseRelativeY == 0 then 
		--do nothing.
	elseif mouseRelativeX < 0 then
		saveState.playerDirection = math.atan(mouseRelativeY/mouseRelativeX) + math.pi
	else 
		saveState.playerDirection = math.atan(mouseRelativeY/mouseRelativeX)
	end

	self.weapon:update(dt)
end

function Player:render()
	love.graphics.print(tostring(speed), 10, 100)
	love.graphics.print(tostring(correctionFactor), 10, 200)
	love.graphics.printf('mapX: '..saveState.mapX
		..'\nmapY: '..saveState.mapY, 10, 300, WINDOW_WIDTH, 'left')
	self.weapon:render(self.x, self.y)
	love.graphics.draw(playerImage, self.x, self.y, saveState.playerDirection, PLAYER_SCALE, PLAYER_SCALE, self.imageWidth/2, self.imageWidth/2)
end