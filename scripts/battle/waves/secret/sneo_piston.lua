local pistonTrap, super = Class(Wave)

function pistonTrap:init()
    super:init(self)
    self.time=10
end

function pistonTrap:onStart()
    local sneo = self.encounter.sneo
    Game.battle.timer:tween(2, sneo, {alpha=0}, "out-cubic")
    local bullet1 = self:spawnBullet("neo/piston", Game.battle.arena.left-200, Game.battle.arena.top+Game.battle.arena.bottom/2, nil, nil, false, true, true)
    bullet1.animation = function()
        bullet1.y = (bullet1.y_orig-55) + math.sin(bullet1.timer*4)*love.math.random(80, 95)
    end
    bullet1.sprite:play(0.25)
    bullet1.bullet_speed = 7
    local bullet2 = self:spawnBullet("neo/piston", Game.battle.arena.right+200, Game.battle.arena.top+Game.battle.arena.bottom/2, nil, nil, false, false, true)
    bullet2.animation = function()
        bullet2.y = (bullet2.y_orig-55) + math.sin(bullet2.timer*2)*love.math.random(80, 95)
    end
    bullet2.sprite:play(0.25)
    bullet2.bullet_speed = 7
    self.pistons = {
        bullet1,
        bullet2
    }
end

function pistonTrap:update()
    -- Code here gets called every frame

    super:update(self)
end

function pistonTrap:onEnd()
    local sneo = self.encounter.sneo
    Game.battle.timer:tween(0.5, sneo, {alpha=1}, "out-cubic")

    super:onEnd(self)
end

return pistonTrap