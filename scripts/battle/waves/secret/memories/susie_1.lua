local How_We_Meet, super = Class(Wave)

function How_We_Meet:init()
	super:init(self)

	self.time = 5
end

function How_We_Meet:onStart()
	self.timer:everyInstant(1/4, function()
		self:spawnBullet("secret/memories/candycane", Utils.random(Game.battle.arena.left, Game.battle.arena.right), -10)
	end)
end

return How_We_Meet