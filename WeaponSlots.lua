WeaponSlots = Class{}

local numberOfSlots = 5
local slotHeight = 40
local slotWidth = 100

function WeaponSlots:init()
	self.slotSpacing = slotWidth + PADDING2
	self.startX = WINDOW_WIDTH/2 - self.slotSpacing*numberOfSlots/2
	self.slotY = PADDING *3
	self.slots = {}
	for i = 1,numberOfSlots do 
		if saveState.weaponSlots[i] == nil then 
			self.slots[i] = Button(self.startX + self.slotSpacing*(i-1), self.slotY, slotWidth, slotHeight, 'Fists')
		else 
			self.slots[i] = Button(self.startX + self.slotSpacing*(i-1), self.slotY, slotWidth, slotHeight, saveState.weaponSlots[i])
		end
	end
end

function WeaponSlots:update(dt)
	for i,slot in pairs(self.slots) do
		slot:update(dt)
		if slot:isPressed() then 
			if saveState.weaponSlots[i] == nil then 
				saveState.weapon = 'Fists'
			else 
				saveState.weapon = saveState.weaponSlots[i]
			end
		end
	end
end

function WeaponSlots:render()
	for i,slot in pairs(self.slots) do
		slot:render()
	end
end