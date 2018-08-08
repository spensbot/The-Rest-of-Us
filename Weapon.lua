Weapon = Class{}

local weaponTypes = {
	['knife'] = {
		range = 30,
		spread = math.pi/2,
		damage = 10,
		image = 'images/knife.png',
		scaleFactor = .2,
		animationDuration = .5,
		animationRotation = math.pi/2},
	['fists'] = {
		range = 30,
		spread = math.pi/2,
		damage = 10,
		image = 'images/fists.png',
		scaleFactor = .2,
		animationDuration = 1,
		animationRotation = math.pi/2},
	['pistol'] = {
		range = 30,
		spread = math.pi/2,
		damage = 10,
		image = 'images/pistol.png',
		scaleFactor = .2,
		animationDuration = 1,
		animationRotation = math.pi/2},
	['flame-thrower'] = {
		range = 30,
		spread = math.pi/2,
		damage = 10,
		image = 'images/knife.png',
		scaleFactor = .2,
		animationDuration = 1,
		animationRotation = math.pi/2}
}

function Weapon:init(type)
	self.specs = weaponTypes[type]
	self.image = love.graphics.newImage(self.specs.image)
	self.imageWidth = self.image:getWidth()
	self.rotation = 0
end

function Weapon:update(dt)

end

function Weapon:damage(object)

end

function Weapon:render(x,y)
	love.graphics.draw(self.image, x, y, saveState.playerDirection + self.rotation, PLAYER_SCALE, PLAYER_SCALE, self.imageWidth/2, self.imageWidth/2)
end