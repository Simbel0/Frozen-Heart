local If_Only, super = Class(Wave)

function If_Only:init()
	super:init(self)

	self.time = 7
	self:setArenaSize(142*1.5, 142)
end

function If_Only:onStart()
	self.timer:everyInstant(2, function()
		local b = self:spawnBullet("secret/memories/ferris", -20, Game.battle.arena.top+40, math.rad(0), 5)
		local b2 = self:spawnBullet("secret/memories/ferris", SCREEN_WIDTH+20, Game.battle.arena.bottom-40, math.rad(180), 5)
	end)
end

return If_Only