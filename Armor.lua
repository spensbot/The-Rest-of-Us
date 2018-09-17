Armor = Class{}

function Armor:init(armorType)
	self.type = armorType
	self.specs = armorTypes[self.type]
	if self.specs.image ~= nil then
		self.imageWidth = self.specs.image:getWidth()
	end
end

function Armor:update(dt)
end

function Armor:render(x,y,angle)
	if self.specs.image ~= nil then
		love.graphics.draw(self.specs.image, x, y, angle, PLAYER_SCALE, PLAYER_SCALE, self.imageWidth/2, self.imageWidth/2)
	end
end