local Letter, super = Class(Bullet)

function Letter:init(letter, x, y, font)
    -- Last argument = sprite path
    super:init(self, x, y)

    self.letter = letter
    self.font = font

    self:setScale(1)

    self:setHitbox(3, 11, 7, 12)

    self.alpha = 0
    self.collidable = false
end

function Letter:onWaveSpawn(wave)
    self.width = self.font:getWidth(self.letter)
    self.height = self.font:getHeight(self.letter)
    self:fadeTo(1, 1.5, function()
        wave.timer:after(1, function()
            self:fadeTo(0, 0.5, self.remove)
        end)
    end)
end

function Letter:update()
    -- For more complicated bullet behaviours, code here gets called every update

    self.collidable = self.alpha > 0.5

    super:update(self)
end

function Letter:draw()
    love.graphics.setFont(self.font)
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.print(self.letter, 0, 0)

    super:draw(self)
end

return Letter