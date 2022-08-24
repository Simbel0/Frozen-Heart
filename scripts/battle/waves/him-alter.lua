local him, super = Class(Wave)

function him:init()
    super:init(self)
    self.time=20
end

function him:onArenaEnter()
    Game.battle.arena.color={0, 0, 1}
end

function him:onStart()
    self.timer:everyInstant(1/3, function()
        --for i=1,#self.bullets do
        --    self.bullets[i]:remove()
        --end
        local dir = math.random()<0.5 and "left" or "right"
        local x = dir=="right" and Game.battle.arena.left-30 or Game.battle.arena.right+30

        local y = (Game.battle.arena.top-40)+45*math.random(1,4)

        local bullet = self:spawnBullet("snowflakeBullet", x, y, math.rad(180), 0, false, 1, dir)
        bullet.alpha=0
        self.timer:tween(0.5, bullet, {alpha=1})
        self.timer:after(0.5, function()
            self.timer:tween(1, bullet.physics, {speed=dir=="left" and Utils.random(8, 12) or -Utils.random(8, 12)}, "in-quad")
            bullet.rotate=true
        end)
    end)
end

function him:update()
    -- Code here gets called every frame

    super:update(self)
end

return him