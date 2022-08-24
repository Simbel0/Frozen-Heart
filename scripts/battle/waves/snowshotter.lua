local snowshotter, super = Class(Wave)

function snowshotter:init()
    super:init(self)
    self.time=20
end

function snowshotter:onArenaEnter()
    Game.battle.arena.color={0, 0, 1}
end

function snowshotter:onStart()
    self.timer:everyInstant(3, function()
        local x, y
        repeat
            x = Utils.random(30, SCREEN_WIDTH-30)
        until (x<Game.battle.arena.left or x>Game.battle.arena.right)
        repeat
            y = Utils.random(30, SCREEN_HEIGHT-30)
        until (y<Game.battle.arena.top or y>Game.battle.arena.bottom)
        local bullet = self:spawnBullet("snowflakeBullet", x, y, math.rad(180), 0)
        local shoot_count = math.random(3,7)
        local shoot_delay = Utils.random(1/2, 2)
        bullet.alpha=0
        self.timer:tween(0.5, bullet, {alpha=1})
        bullet.shoot=self.timer:after(0.5+Utils.random(1/2,1.5), function()
            self.timer:script(function(wait)
                self.timer:everyInstant(shoot_delay, function()
                    local bullet2 = self:spawnBullet("lonelySnow", bullet.x, bullet.y, Utils.angle(bullet.x, bullet.y, Game.battle.soul.x, Game.battle.soul.y), 3)
                end, shoot_count)
                wait(shoot_count*shoot_delay)
                self.timer:tween(0.5, bullet, {alpha=0}, "linear", function()
                    bullet:remove()
                end)
            end)
        end)
    end)
end

return snowshotter