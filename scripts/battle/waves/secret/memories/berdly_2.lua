local Smash, super = Class(Wave)

function Smash:init()
	super:init(self)

	self.time = 10
	self:setArenaSize(142*2, 122)
	self:setSoulOffset(-110, 0)
end

function Smash:onStart()
	self:spawnBullet("secret/memories/smash_player", Game.battle.arena.right-23, Game.battle.soul.y)
end

return Smash