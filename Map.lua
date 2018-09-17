Map = Class{}

local mapImagePath = 'images/map_1.png'
local gridScale = 300 --number of pixels that corresponds to each pixel in the map image
local miniMapWidth = 150
local markerColor = {0,1,0,1}
local miniBackgroundColor = {.1,.1,.1,.7}
local markerInnerRadius = 2
local markerOutterRadius = 6
local terrainObjects = {}
local maxTerrainObjects = 80
local minTerrainSpacing = 350
local storyPointsData = {
	{400, 400, "Welcome, Maurice, to the best game you've ever played."}
}
local storyPoints = {}

function Map:init()
	self.mapImage = love.graphics.newImage(mapImagePath)
	self.mapImageData = love.image.newImageData(mapImagePath)
	self.mapPixelData = {}
	self.mapImageWidth = self.mapImage:getWidth()
	self.mapImageHeight = self.mapImage:getHeight()
	self.miniMapHeight = miniMapWidth * self.mapImageHeight/self.mapImageWidth
	self.miniMapScale = miniMapWidth/self.mapImageWidth
	self.miniMapX = WINDOW_WIDTH - miniMapWidth - PADDING*2
	self.miniMapY = PADDING*2
	self.markerX = 0
	self.markerY = 0
	self.originOffsetX = 0
	self.originOffsetY = 0
	self:readMapData()
end

function Map:update(dt)
	self.markerX = self.miniMapX + (self.originOffsetX-1)*self.miniMapScale + saveState.mapX/gridScale*self.miniMapScale
	self.markerY = self.miniMapY + (self.originOffsetY-1)*self.miniMapScale + saveState.mapY/gridScale*self.miniMapScale
	self:updateTerrainObjects(dt)
	self:updateObstacles(dt)
	self:updateStoryPoints(dt)
end

function Map:render()
	for i, terrainObject in pairs(terrainObjects)do
		terrainObject:render()
	end
	for i, obstacle in pairs(global.obstacles) do
		obstacle:render()
	end
	for i, storyPoint in pairs(storyPoints) do
		storyPoint:render()
	end
	love.graphics.setColor(miniBackgroundColor)
	love.graphics.rectangle('fill', self.miniMapX - PADDING, PADDING, miniMapWidth + PADDING*2, self.miniMapHeight + PADDING*2, 10)
	love.graphics.setColor(WHITE)
	love.graphics.draw(self.mapImage, self.miniMapX, self.miniMapY, 0, self.miniMapScale, self.miniMapScale)
	love.graphics.setLineWidth(2)
	love.graphics.setColor(markerColor)
	love.graphics.circle('line', self.markerX, self.markerY, markerOutterRadius)
	love.graphics.circle('fill', self.markerX, self.markerY, markerInnerRadius)
end


------------------------------------ HELPER FUNCTIONS -------------------------------------


function Map:readMapData()
--Read image data to a matrix
	--iterate 1 column at a time
	for x = 1, self.mapImageData:getWidth() do
		local column = {} 
		--iterate through each pixel in the column
		for y = 1, self.mapImageData:getHeight() do
			local pixel = {}
			pixel[1],pixel[2],pixel[3],pixel[4] = self.mapImageData:getPixel(x-1, y-1)

			--If the pixel is white, set the map origin there.
			if pixel[1] == 1 and pixel[2] == 1 and pixel[3] == 1 and pixel[4] == 1 then 
				self.originOffsetX = x
				self.originOffsetY = y
			end
			column[y] = pixel
		end
		self.mapPixelData[x] = column
	end

	--Iterate through the matrix, and look for certain pixel types to generate the map.
	--Iterate through 1 column at a time
	for x = 1, self.mapImageData:getWidth() do
		--Iterate throught each pixel in the column
		for y = 1, self.mapImageData:getHeight() do
			
			if self.mapPixelData[x][y][4] == 1 then --Something should be placed in this space.
				local obstacleMapX, obstacleMapY = self:getMapCoordinatesFromPixel(x,y)

				--look for the black pixels. Add a barrier object for each one.
				if self.mapPixelData[x][y][1] == 0 and self.mapPixelData[x][y][2] == 0 and self.mapPixelData[x][y][3] == 0 then
					table.insert(global.obstacleData, {obstacleMapX, obstacleMapY, ['type'] = 'barrier'})

				--Pixels with only red will spawn enemies. A higher red value should spawn a stronger enemy.
				elseif self.mapPixelData[x][y][1] > 0 and self.mapPixelData[x][y][2] == 0 and self.mapPixelData[x][y][3] == 0 then
					spawnEnemy(self:getMapCoordinatesFromPixel(x, y))

				--Pixels with only blue will spawn searchables.
				elseif self.mapPixelData[x][y][1] == 0 and self.mapPixelData[x][y][2] == 0 and self.mapPixelData[x][y][3] > 0 then
					local inventoryTable = {['Quartz'] = 10, ['Health Kit'] = 1}
					table.insert(global.obstacleData, {obstacleMapX, obstacleMapY, ['type'] = 'chest', ['inventory'] = inventoryTable})
				end
			end
		end
	end
end

function Map:getMapCoordinatesFromPixel(x,y)
	local mapX, mapY = 0, 0
	mapX = (x - self.originOffsetX) * gridScale
	mapY = (y - self.originOffsetY) * gridScale
	return mapX, mapY
end

function Map:updateTerrainObjects(dt)
	local spawnDistance = WINDOW_WIDTH*1.5
	--First, remove objects that are too far from the player
	for i, terrainObject in pairs(terrainObjects) do
		if math.abs((terrainObject.mapX - saveState.mapX)) > spawnDistance
		or math.abs((terrainObject.mapY - saveState.mapY)) > spawnDistance then 
			table.remove(terrainObjects, i)
		end
	end

	--Next, add objects as necessary to reach maxTerrainObjects
	local attempts = 0
	while #terrainObjects < maxTerrainObjects do
		local relativeX = math.random(-spawnDistance, spawnDistance) 
		local relativeY = math.random(-spawnDistance, spawnDistance) 
		local newMapX = saveState.mapX + relativeX
		local newMapY = saveState.mapY + relativeY

		--Ensure that the new object will not appear in the screen.
		if math.abs(newMapX - saveState.mapX) > WINDOW_WIDTH*2/3
		or math.abs(newMapY - saveState.mapY) > WINDOW_HEIGHT*2/3 then
			--Ensure that the new terrain object will not be too close to existing objects.
			local hasSpace = true
			for i, terrainObject in pairs(terrainObjects) do 
				if math.abs((terrainObject.mapX - newMapX)) < minTerrainSpacing
				and math.abs((terrainObject.mapY - newMapY)) < minTerrainSpacing then
					hasSpace = false
				end
			end
			if hasSpace then
				table.insert(terrainObjects, Obstacle(newMapX, newMapY, gridScale, 'terrain'))
				attempts = 0
			end
		end
		if attempts > maxTerrainObjects then 
			break
		end
		attempts = attempts + 1
	end

	--Update the terrain objects
	for i, terrainObject in pairs(terrainObjects)do
		terrainObject:update(dt)
	end
end

function Map:updateObstacles(dt) 
	local spawnDistance = WINDOW_WIDTH
	--Remove objects that are too far from the player
	for i, obstacle in pairs(global.obstacles) do
		if math.abs((obstacle.mapX - saveState.mapX)) > spawnDistance
		or math.abs((obstacle.mapY - saveState.mapY)) > spawnDistance then 
			global.obstacles[i] = nil
		end
	end

	--Add objects for any object data that is close to the player
	for i, obstacleData in pairs(global.obstacleData) do

		--Check if an Obstacle instance exists for that data point.
		if global.obstacles[i] == nil then

			--If the obstacle is within spawn distance from the player, create an Obstacle instance.
			if math.abs((obstacleData[1] - saveState.mapX)) < spawnDistance
			and math.abs((obstacleData[2] - saveState.mapY)) < spawnDistance then 
				if obstacleData['type'] == 'chest' then
					global.obstacles[i] = Obstacle(obstacleData[1], obstacleData[2], gridScale/2, 'chest', obstacleData['inventory'])
				else
					global.obstacles[i] = Obstacle(obstacleData[1], obstacleData[2], gridScale, 'barrier')
				end
			end
		end
	end

	for i, obstacle in pairs(global.obstacles) do
		obstacle:update(dt)
	end
end

function Map:updateStoryPoints(dt) 
	local spawnDistance = WINDOW_WIDTH
	--Remove objects that are too far from the player
	for i, storyPoint in pairs(storyPoints) do
		if math.abs((storyPoint.mapX - saveState.mapX)) > spawnDistance
		or math.abs((storyPoint.mapY - saveState.mapY)) > spawnDistance then 
			storyPoints[i] = nil
		end
	end

	--Add objects for any object data that is close to the player
	for i, storyPointData in pairs(storyPointsData) do

		--Check if an Obstacle instance exists for that data point.
		if storyPoints[i] == nil then

			--If the obstacle is within spawn distance from the player, create an Obstacle instance.
			if math.abs((storyPointData[1] - saveState.mapX)) < spawnDistance
			and math.abs((storyPointData[2] - saveState.mapY)) < spawnDistance then 
				storyPoints[i] = StoryPoint(storyPointData[1], storyPointData[2], storyPointData[3])
			end
		end
	end

	for i, storyPoint in pairs(storyPoints) do
		storyPoint:update(dt)
	end
end