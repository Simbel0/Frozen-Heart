local Love, super = Class(Wave)

function Love:init()
	super:init(self)

	self.time = 10
	self:setArenaSize(162, 142)
end

function Love:onStart()
	self.timer:every(1/3, function()
		self:spawnBullet("secret/memories/love", Game.battle.arena.left-50, Utils.random(Game.battle.arena.top, Game.battle.arena.bottom), math.rad(0))
		self:spawnBullet("secret/memories/love", Game.battle.arena.right+50, Utils.random(Game.battle.arena.top, Game.battle.arena.bottom), math.rad(180))
	end)
end

return Love