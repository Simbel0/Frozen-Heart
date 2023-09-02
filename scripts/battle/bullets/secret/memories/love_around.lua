local love, super = Class(Bullet)

function love:init(x, y, dir)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/memories/love")
    self:setScale(1.5)

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir

    self.go_go = false
end

function love:update()
    -- For more complicated bullet behaviours, code here gets called every update
    super:update(self)
end

function love:onRemoveFromStage()
    Utils.removeFromTable(self.wave.bullets, self)
end

return love