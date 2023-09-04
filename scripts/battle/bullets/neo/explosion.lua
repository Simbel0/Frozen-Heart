local bullet, super = Class(Bullet)

function bullet:init(x, y, rad, speed, fade_time)
    -- Last argument = sprite path
    super:init(self, x, y)
    self:setOrigin(0.5, 0.5)

    self.collider = CircleCollider(self, 0, 0, rad-2.5)
    self.debug_rect = {0, 0, rad, rad}

    self:setPosition(x, y)

    self.radius = rad
    self.speed = speed
    self:fadeOutAndRemove(fade_time)
end

function bullet:update()
    super:update(self)

    self.radius = self.radius + self.speed * DTMULT
    self.collider.radius = self.radius - 2.5
end

function bullet:draw()
    super:draw(self)

    love.graphics.setColor(self:getDrawColor())
    love.graphics.circle("fill", 0, 0, self.radius)
    love.graphics.setColor(1, 1, 1, 1)
end

return bullet