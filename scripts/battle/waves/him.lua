local him, super = Class(Wave)

function him:init()
    super:init(self)
    self.time=20
end

function him:onArenaEnter()
    Game.battle.arena.color={0, 0, 1}
end

function him:onStart()
    self.timer:everyInstant(1.5, function()
        --for i=1,#self.bullets do
        --    self.bullets[i]:remove()
        --end
        for i=1,4 do
            local x = Game.battle.arena.right+30

            local y = (Game.battle.arena.top-40)+45*i

            local bullet = self:spawnBullet("snowflakeBullet", x, y, math.rad(180), 0)
            bullet.alpha=0
            self.timer:tween(0.5, bullet, {alpha=1})
        end
        self.timer:after(0.5, function()
            loop=self.timer:everyInstant(0.25, function()
                if #self.bullets==0 then
                    self.timer:cancel(loop)
                    return
                end
                local b=Utils.pick(self.bullets)
                while b.physics.speed>0 do
                    b=Utils.pick(self.bullets)
                end
                self.timer:tween(1, b.physics, {speed=Utils.random(8, 12)}, "in-quad")
                b.rotate=true
            end, 3)
        end)
    end)
end

function him:update()
    -- Code here gets called every frame

    super:update(self)
end

return him