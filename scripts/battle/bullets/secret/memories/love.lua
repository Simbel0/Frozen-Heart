local love, super = Class(Bullet)

function love:init(x, y, dir)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/memories/love")
    self:setScale(1.5)

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = 0.1
    self.physics.friction = -0.1

    self.alpha = 0
    self:fadeTo(1, 1)

    self.just_created = true
end

function love:update()
    -- For more complicated bullet behaviours, code here gets called every update
    if self.wave then
        for i,bullet in ipairs(self.wave.bullets) do
            if not (bullet == self) and not self.partner then
                if self:collidesWith(bullet) then
                    if self.just_created then
                        self:remove()
                    else
                        self.partner = bullet
                    end
                end
            end
        end
    end

    if self.partner and self.physics.speed > 0 then
        if Utils.round(self.x) == Utils.round(self.partner.x) then
            self.physics.speed = 0
            self.wave.timer:tween(0.35, self, {scale_x=2, scale_y=2}, "out-cubic", function()
                self.wave.timer:tween(0.25, self, {scale_x=0, scale_y=0}, "in-cubic", function()
                    self:remove()
                end)
            end)
        end
    end

    super:update(self)
    self.just_created = false
end

return love