local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir)
    -- Last argument = sprite path
    super:init(self, x-7, y, "bullets/memories/candycane")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = math.rad(90+Utils.random(-10, 10))
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = 12
end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super:update(self)
end

return SmallBullet