local How_Its_Going, super = Class(Wave)

function How_Its_Going:init()
	super:init(self)

	self.time = 7
end

function How_Its_Going:onStart()
	self.timer:everyInstant(1/20, function()
		local x
		if Utils.random()<0.5 then
			x = Utils.random(0, Game.battle.arena.left)
		else
			x = Utils.random(Game.battle.arena.right, SCREEN_WIDTH)
		end
		self:spawnBullet("secret/memories/heraxe", x, -10)
	end)
end

return How_Its_Going