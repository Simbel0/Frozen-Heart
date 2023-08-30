local Falling_grades, super = Class(Wave)

function Falling_grades:init()
	super:init(self)

	self.time = 10
	self:setArenaSize(142*2, 142)
end

function Falling_grades:onStart()
	self.timer:everyInstant(1/4, function()
		self:spawnBullet("secret/memories/grade", Utils.random(Game.battle.arena.left, Game.battle.arena.right), -10)
	end)
end

return Falling_grades