local phoneRing, super = Class(Wave)

function phoneRing:init()
    super:init(self)
    self.mode = Game.battle.encounter.sneo.wave_loop
    self.time=-1
    self:setArenaOffset(-50, 0)
end

function phoneRing:onStart()
    self:spawnBullet("neo/phone", 470, -20, self.mode==1 and 1/4 or 1/6)
end

function phoneRing:update()
    -- Code here gets called every frame

    super:update(self)
end

return phoneRing