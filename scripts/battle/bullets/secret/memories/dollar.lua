local lonelySnow, super = Class(Bullet)

function lonelySnow:init(x, y, dir, speed)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/memories/dollar")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
end

function lonelySnow:update()
    -- For more complicated bullet behaviours, code here gets called every update

    self.physics.direction = self.physics.direction + math.rad(1.5*DTMULT)

    super:update(self)
end

return lonelySnow