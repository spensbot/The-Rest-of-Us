Armor = Class{}

armorTypes = {
	['Headband'] = {
		image = love.graphics.newImage('images/Headband.png'),
		damageFactor = .9},
	['Trucker Cap'] = {
		image = love.graphics.newImage('images/Trucker Cap.png'),
		damageFactor = .7},
	['Bike Helmet'] = {
		image = love.graphics.newImage('images/Bike Helmet.png'),
		damageFactor = .5},
	['Football Helmet'] = {
		image = love.graphics.newImage('images/Football Helmet.png'),
		damageFactor = .3},
}

function Armor:init(armorType)
	self.type = armorType
	self.specs = armorTypes[self.type]
	self.imageWidth = self.specs.image:getWidth()
end

function Armor:update(dt)
end

function Armor:render(x,y,angle)
	love.graphics.draw(self.specs.image, x, y, angle, PLAYER_SCALE, PLAYER_SCALE, self.imageWidth/2, self.imageWidth/2)
end