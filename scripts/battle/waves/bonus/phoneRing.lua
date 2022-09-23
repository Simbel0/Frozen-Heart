local phoneRing, super = Class(Wave)

function phoneRing:init()
    super:init(self)
    self.time=-1
    self:setArenaOffset(-50, 0)
end

function phoneRing:onStart()
    self:spawnBullet("neo/phone", 470, -20, 1/4)
end

function phoneRing:update()
    -- Code here gets called every frame

    super:update(self)
end

return phoneRing