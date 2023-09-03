local Her_Axe, super = Class(Bullet)

function Her_Axe:init(x, y)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/memories/axe")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = math.rad(90+Utils.random(-1, 1))
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = 15

    self.graphics.spin = math.rad(45)
end

function Her_Axe:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super:update(self)
end

return Her_Axe