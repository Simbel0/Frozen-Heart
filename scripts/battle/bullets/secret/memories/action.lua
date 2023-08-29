local action, super = Class(Bullet)

function action:init(act, x, y, physics)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/memories/"..act)

    self.sprite:setRotationOrigin(0.5)

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self:setPhysics(physics)

    self.sprite.rotation = math.rad(136)
end

function action:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super:update(self)
end

return action