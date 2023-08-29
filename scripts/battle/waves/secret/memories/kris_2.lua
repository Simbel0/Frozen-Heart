local Pranks, super = Class(Wave)

function Pranks:init()
	super:init(self)

	self.time = 10
end

function Pranks:onStart()
	self:spawnBullet("secret/memories/prank", Game.battle.arena.left+Game.battle.arena.right/4, Game.battle.arena.top-30)
end

return Pranks