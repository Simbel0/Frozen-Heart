local Social_Messages, super = Class(Wave)

function Social_Messages:init()
	super:init(self)

	self.time = 10
end

function Social_Messages:onStart()
	self:spawnBullet("secret/memories/social_queen", Game.battle.arena.left-75, Game.battle.arena.top+Game.battle.arena.height/2)
end

return Social_Messages