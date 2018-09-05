Map = Class{}

local mapImagePath = 'images/map_small.png'
local gridScale = 200 --number of pixels that corresponds to each pixel in the map image
local miniMapWidth = 150
local markerColor = {0,1,0,1}
local miniBackgroundColor = {.3,.3,.3,.5}
local markerInnerRadius = 2
local markerOutterRadius = 6

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
	for i, obstacle in pairs(obstacles) do
		obstacle:update(dt)
	end
end

function Map:render()
	
	for i, obstacle in pairs(obstacles) do
		obstacle:render()
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
			--look for the black pixels. Add a barrier object for each one.
			if self.mapPixelData[x][y][1] == 0 and self.mapPixelData[x][y][2] == 0 and self.mapPixelData[x][y][3] == 0 and self.mapPixelData[x][y][4] == 1 then 
				local obstacleMapX = (x - self.originOffsetX) * gridScale
				local obstacleMapY = (y - self.originOffsetY) * gridScale
				table.insert(obstacles, Obstacle(obstacleMapX, obstacleMapY, gridScale))
			end
		end
	end
end