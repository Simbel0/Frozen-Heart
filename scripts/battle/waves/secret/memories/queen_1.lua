local Smash, super = Class(Wave)

function Smash:init()
	super:init(self)

	self.time = 10
	self:setArenaSize(142*1.5, 142*1.5)
end

function Smash:onStart()
	self.timer:everyInstant(1, function()
		local x, y = Game.battle.soul.x+Utils.random(5, 25)*Utils.randomSign(), Game.battle.soul.y+Utils.random(5, 25)*Utils.randomSign()
		local top = self:spawnBullet("secret/memories/cage", "top", x, y)
		local bottom = self:spawnBullet("secret/memories/cage", "bottom", x, y)
		top.bottom = bottom
		bottom.top = top
	end)
end

return Smash