local bullet, super = Class(Bullet)

function bullet:init(x, y, dir, speed)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/neo/crew_bullet")

    self.sprite:setScale(0.5, 0.5)
    self:setHitbox(5, 5, (self.sprite.width/2)-10, (self.sprite.height/2)-10)

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed

    self:setRotationOrigin(0, 0)
end

function bullet:update()
    super:update(self)

    self.rotation = math.rad(math.deg(self.rotation)+5*DTMULT)
end

return bullet