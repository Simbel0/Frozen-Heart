local Spyware, super = Class(Wave)

function Spyware:init()
	super:init(self)

	self.time = 10
	self.popups = {}
end

function Spyware:onStart()
	Kristal.showCursor()
	local b = self:spawnBullet("secret/memories/spyware", 320, 45)
	table.insert(self.popups, b)
end

function Spyware:onEnd()
	Kristal.hideCursor()
end

return Spyware