local File, super = Class(Bullet)

function File:init(x, y)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/memories/file")

    self.rotation = math.rad(90+Utils.random(-65, 65))

    self.physics.match_rotation = true

    self.physics.speed = 10
end

function File:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super:update(self)
end

return File