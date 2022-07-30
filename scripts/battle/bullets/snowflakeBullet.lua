local snowflakeBullet, super = Class(Bullet)

function snowflakeBullet:init(x, y, dir, speed, rotate, scale)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/snowflakeBullet")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed

    self.rotate=rotate
    self:setScale(scale)
end

function snowflakeBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    if self.rotate then
        self.rotation=math.rad(math.deg(self.rotation)-2*DTMULT)
    end

    super:update(self)
end

return snowflakeBullet