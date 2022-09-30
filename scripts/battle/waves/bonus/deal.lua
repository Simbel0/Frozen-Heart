local deal, super = Class(Wave)

function deal:onStart()
    local sneo = self.encounter.sneo
    self.org_x=sneo.x
    Game.battle.timer:tween(2, sneo, {x=SCREEN_WIDTH+80}, "out-cubic")
    self:spawnBullet("neo/pipis", Game.battle.arena.right+120, Game.battle.arena.bottom-Game.battle.arena.top, 0, 0, false, 80, false)
end

function deal:update()
    -- Code here gets called every frame

    super:update(self)
end

function deal:onEnd()
    local sneo = self.encounter.sneo
    Game.battle.timer:tween(0.5, sneo, {x=self.org_x}, "out-cubic")

    super:onEnd(self)
end

return deal