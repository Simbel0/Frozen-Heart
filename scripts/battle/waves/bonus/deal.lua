local deal, super = Class(Wave)

function deal:onStart()
    local sneo = self.encounter.sneo
    self.org_x=sneo.x
    Game.battle.timer:tween(2, sneo, {x=SCREEN_WIDTH+80}, "out-cubic")
    local pipis = self:spawnBullet("neo/pipis", Game.battle.arena.right+160, (Game.battle.arena.bottom-Game.battle.arena.top)-30, 0, 0, false, 80, false)
    pipis.sprite.alpha=0
    pipis.sprite:fadeTo(1, 0.5)
    local pipis = self:spawnBullet("neo/pipis", Game.battle.arena.right+100, (Game.battle.arena.bottom-Game.battle.arena.top)+80, 0, 0, false, 100, false)
    pipis.sprite.alpha=0
    pipis.sprite:fadeTo(1, 0.5)

    if self.encounter:getFlag("krisWasDown") then
        Game.battle.soul.graze_tp_factor = 5
    end
end

function deal:update()
    -- Code here gets called every frame

    -- if kris was down when the phase started, lower the damage to allow the player to survive
    -- also increases the tp to allow healing more easily
    if self.encounter:getFlag("krisWasDown") then
        for i,bullet in ipairs(self.bullets) do
            if bullet.damage == nil or bullet:getDamage() > 10 then
                bullet.damage = 10
            end
        end
    end

    super:update(self)
end

function deal:onEnd()
    local sneo = self.encounter.sneo
    Game.battle.timer:tween(0.5, sneo, {x=self.org_x}, "out-cubic")

    if self.encounter:getFlag("krisWasDown") then
        self.encounter:setFlag("krisWasDown", false)
    end

    super:onEnd(self)
end

return deal