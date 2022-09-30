local protectedCrew, super = Class(Wave)

function protectedCrew:init()
    super:init(self)
    self.mode = Game.battle.encounter.sneo.wave_loop
    self.time=-1
    self:setArenaOffset(-150, 0)
end

function protectedCrew:onStart()
    self.crews={
        self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 130, nil, 1, {430, 130}, true, true),
        self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 240, nil, 1, {430, 240}, true, true),
        self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 130, nil, 1, {550, 130}, true, true),
        self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 240, nil, 1, {550, 240}, true, true),
        self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 185, nil, 1, {485, 185}, true, true)
    }
end

function protectedCrew:update()
    -- Code here gets called every frame
    print(self.crews[1].collidable)
    local j=0

    for i,v in ipairs(self.crews) do
        if not v.collidable then
            j=j+1
        end
    end

    if j==#self.crews and not self.willstop then
        self.willstop = true
        Game.battle.timer:after(1, function()
            self.finished = true
        end)
    end

    super:update(self)
end

return protectedCrew