local pistonTrap, super = Class(Wave)

function pistonTrap:init()
    super:init(self)
    self.time=-1
    self:setArenaSize(280, 142)
end

function pistonTrap:onStart()
    self.pistons = {
        self:spawnBullet("neo/piston", 50, SCREEN_HEIGHT/2, nil, nil, true, true),
        self:spawnBullet("neo/piston", SCREEN_WIDTH-50, SCREEN_HEIGHT/2)
    }
end

function pistonTrap:update()
    -- Code here gets called every frame

    super:update(self)
end

function pistonTrap:onEnd()
    super:onEnd(self)
end

return pistonTrap