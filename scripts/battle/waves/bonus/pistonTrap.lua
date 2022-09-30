local pistonTrap, super = Class(Wave)

function pistonTrap:init()
    super:init(self)
    self.mode = Game.battle.encounter.sneo.wave_loop
    self.time=14
    self:setArenaSize(280, 142)
end

function pistonTrap:onStart()
    local sneo = self.encounter.sneo
    self.org_x=sneo.x
    Game.battle.timer:tween(2, sneo, {x=SCREEN_WIDTH+80}, "out-cubic")
    self.pistons = {
        self:spawnBullet("neo/piston", 50, (Game.battle.arena.bottom-Game.battle.arena.top)+20, nil, nil, true, true),
        self:spawnBullet("neo/piston", SCREEN_WIDTH-50, SCREEN_HEIGHT/2)
    }
end

function pistonTrap:update()
    -- Code here gets called every frame

    super:update(self)
end

function pistonTrap:onEnd()
    local sneo = self.encounter.sneo
    Game.battle.timer:tween(0.5, sneo, {x=self.org_x}, "out-cubic")

    super:onEnd(self)
end

return pistonTrap