--The saveState table contains everything that is saved to disk between games.
function createNewSaveState()
	saveState = {}

	saveState.name = ''
	saveState.inventory = {}
	saveState.weapon = 'Fists'
	saveState.armor = 'None'
    saveState.xp = 0
    saveState.playTime = 0
    saveState.mapX = 900
    saveState.mapY = 9000
    saveState.health = 300
    saveState.stamina = 100
    saveState.inventoryOpen = false
    saveState.enemyData = {} --A table of data for every enemy on the map.
    saveState.searchablesData = {} --A table of data for every searchable on the map.

	if DEBUG then 
	    saveState.inventory = {['Quartz'] = 100, ['Health Kit'] = 2, ['Football Helmet'] = 1, ['Headband'] = 1,
	    	['Trucker Cap'] = 1, ['Bike Helmet'] = 1, ['Rusty Knife'] = 1, ['9mm Pistol'] = 1,
	    	['Flamethrower'] = 1, ['Assault Rifle'] = 1, ['9mm'] = 100, ['Gasoline'] = 100, ['7.62mm'] = 100}
	    saveState.weapon = 'Assault Rifle'
	    saveState.armor = 'Trucker Cap'

	    saveState.level = 1
	    saveState.xp = 0
	end
end

function spawnEnemy(mapX, mapY, type, level, weapon)
	enemy = {['mapX'] = mapX,
		['mapY'] = mapY,
		['type'] = type,
		level = level,
		health = 100,
		maxHealth = 100,
		weapon = weapon or nil,
		inventory = {}}
	table.insert(saveState.enemyData, enemy)
end

function transformMapToScreen(mapX,mapY)
	local screenX = WINDOW_WIDTH/2 + mapX - saveState.mapX
	local screenY = WINDOW_HEIGHT/2 + mapY - saveState.mapY
	return screenX, screenY
end

--returns the coordinates of a point a given distance and angle from the given point.
function getRelativePoint(x, y, distance, angle)
	local xLeg = math.cos(angle) * distance
	local yLeg = math.sin(angle) * distance
	local outputX = x + xLeg
	local outputY = y + yLeg

	return outputX, outputY
end

function getDistance(point1x, point1y, point2x, point2y)
	local relativeX = point2x - point1x
	local relativeY = point2y - point1y
	local relativeDistance = (relativeX^2 + relativeY^2)^.5
	return relativeDistance
end

--returns the angle of point2 relative to point1. Also returns distance between the points.
function getAngleAndDistance(point1x, point1y, point2x, point2y)
	local relativeX = point2x - point1x
	local relativeY = point2y - point1y
	local relativeDistance = (relativeX^2 + relativeY^2)^.5
	local relativeAngle = 0
	if relativeX == 0 and relativeY == 0 then 
		--do nothing.
	elseif relativeX < 0 then
		relativeAngle = math.atan(relativeY/relativeX) + math.pi
	else 
		relativeAngle = math.atan(relativeY/relativeX)
	end
	if relativeAngle<0 then relativeAngle = relativeAngle + math.pi*2 end

	return relativeAngle, relativeDistance
end 

--returns a factor based on the difference between 2 angles. 
--0 is returned if the angles are the same, 1 is returned if the angles are opposite.
function getAngleDifferenceFactor(angle1, angle2)
	local angleDifference = math.abs(angle1 - angle2)
	if angleDifference > math.pi then 
		angleDifference = 2* math.pi - angleDifference
	end
	local differenceFactor = (angleDifference / math.pi)
	return differenceFactor
end

function clamp(value, min, max)
	if value > max then 
		value = max
	elseif value < min then 
		value = min
	end
	return value
end

function getTriangleLegs (angle, hypotenuse)
	local x = hypotenuse * math.cos(angle)
	local y = hypotenuse * math.sin(angle)
	return x, y 
end

function printInfo()
	love.graphics.setColor(WHITE)
	love.graphics.setFont(BUTTON_FONT)
	--love.graphics.printf('Player Name: '..saveState.name, PADDING, WINDOW_HEIGHT - PADDING * 5, WINDOW_WIDTH, 'left')
	--love.graphics.printf('Play Time: '..string.format('%.0f',saveState.playTime), PADDING, WINDOW_HEIGHT - PADDING*4, WINDOW_WIDTH, 'left')
	love.graphics.printf('FPS: '..tostring(love.timer.getFPS()), PADDING, WINDOW_HEIGHT - PADDING*3, WINDOW_WIDTH, 'left')
end

function countElements(table)
	local count = 0
	if table ~= nil then
		for key, value in pairs(table) do
			count = count + 1
		end
	end
	return count 
end

function calculateTotalMultiplier(multiplierTable)
	local totalMultiplier = 1
	for label, multiplier in pairs(multiplierTable) do
		totalMultiplier = totalMultiplier * multiplier
	end
	return totalMultiplier
end
