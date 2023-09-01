local Cage, super = Class(Bullet)

function Cage:init(part, x, y)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/memories/cage_"..part)

    self.goal_x = x
    self.goal_y = y

    self.part = part

    self.alpha = 0

    self.done = false

    self:fadeTo(1, 1)

    if part == "top" then
        self.physics.direction = math.rad(90)
        self.y = self.y - 50
    else
        self.physics.direction = math.rad(-90)
        self.y = self.y + 50
    end
    self.physics.speed = 0.2
    self.physics.friction = -0.1
end

function Cage:update()
    -- For more complicated bullet behaviours, code here gets called every update

    self.collidable = self.alpha > 0.5
    if self.part == "bottom" and self.top and not self.done then
        if (self.top.y + self.top.height/2)+13 >= self.y - self.width/2 then
            self:resetPhysics()
            self.top:resetPhysics()
            self.wave.timer:after(0.5, function()
                self:fadeOutAndRemove(1)
                self.top:fadeOutAndRemove(1)
            end)
            self.done = true
        end
    end

    super:update(self)
end

function Cage:onRemoveFromStage()
    local part = self.part == "top" and self.bottom or self.top
    part:remove()
end

return Cage