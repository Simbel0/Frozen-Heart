local snowshotter, super = Class(Wave)

function snowshotter:init()
    super:init(self)
    self.time=20
end

function snowshotter:onArenaEnter()
    Game.battle.arena.color={0, 0, 1}
end

function snowshotter:onStart()
    self.timer:everyInstant(3.5, function()
        local x, y
        repeat
            x = Utils.random(30, SCREEN_WIDTH-30)
        until (x<Game.battle.arena.left or x>Game.battle.arena.right)
        repeat
            y = Utils.random(30, SCREEN_HEIGHT-30)
        until (y<Game.battle.arena.top or y>Game.battle.arena.bottom)
        local bullet = self:spawnBullet("snowflakeBullet", x, y, math.rad(180), 0)
        local shoot_count = math.random(7,11)
        local shoot_delay = 1/2
        bullet.alpha=0
        self.timer:tween(0.5, bullet, {alpha=1})
        bullet.shoot=self.timer:after(0.75, function()
            self.timer:script(function(wait)
                self.timer:everyInstant(1/4, function()
                    Assets.playSound("noise")
                    local bullet2 = self:spawnBullet("lonelySnow", bullet.x, bullet.y, Utils.angle(bullet.x, bullet.y, Game.battle.soul.x, Game.battle.soul.y), 6)
                end, shoot_count)
                wait(shoot_count*1/4)
                self.timer:tween(0.5, bullet, {alpha=0}, "linear", function()
                    bullet:remove()
                end)
            end)
        end)
    end)
end

return snowshotter