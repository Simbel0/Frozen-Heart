local Grade, super = Class(Bullet)

function Grade:init(x, y)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/memories/chirashi")
    self:setScale(1)

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = math.rad(90)
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = 12

    self.graphics.spin = Utils.random(0.1, 2.0)
end

function Grade:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super:update(self)
end

return Grade