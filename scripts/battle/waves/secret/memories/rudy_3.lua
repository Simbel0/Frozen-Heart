local Loved, super = Class(Wave)

function Loved:init()
	super:init(self)

	self.time = 6.5
	self:setArenaOffset(0, 40)
end

function Loved:onStart()
	self.heart = self:spawnSprite("bullets/memories/love_break", Game.battle.arena.left+Game.battle.arena.width/2, Game.battle.arena.top-90)
	self.heart:stop()
	self.timer:after(1, function()
        self.heart:setFrame(2)
        self.timer:after(1, function()
            for i=1,6 do
                local shard = self:spawnBullet("secret/memories/shard", self.heart.x, self.heart.y)
                shard.physics.direction = math.rad(Utils.random(360))
				shard.physics.speed = 4
				shard.physics.gravity = 0.2
				shard.sprite:play(5/30)
            end
            self.heart:remove()
        end)
    end)
end

return Loved