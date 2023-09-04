local mail, super = Class(Bullet)

function mail:init(x, y, dir, speed)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/neo/mail")
    print(x, y)
    self.sprite:setFrame(love.math.random(1, 2))

    self.sprite:setScale(0.5, 0.5)
    self:setHitbox((self.sprite.width/4)-2.5, (self.sprite.height/4)-2.5, 5, 5)

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.rotation = dir

    self.physics.match_rotation = true
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
end

function mail:update()
    super:update(self)
end

return mail