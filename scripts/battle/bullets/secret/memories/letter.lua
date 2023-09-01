local Letter, super = Class(Bullet)

function Letter:init(letter, x, y, font, use_fader)
    -- Last argument = sprite path
    super:init(self, x, y)

    self.letter = letter
    self.font = font

    self.use_fader = (use_fader ~= nil) and use_fader or true

    self:setScale(1)

    self:setHitbox(3, 11, 7, 12)

    if self.use_fader then
        self.alpha = 0
        self.collidable = false
    end
    print(self.use_fader, use_fader, use_fader ~= nil, use_fader ~= nil and "0" or "1")
end

function Letter:onWaveSpawn(wave)
    self.width = self.font:getWidth(self.letter)
    self.height = self.font:getHeight(self.letter)
    if self.use_fader then
        self:fadeTo(1, 1.5, function()
            wave.timer:after(1, function()
                self:fadeTo(0, 0.5, self.remove)
            end)
        end)
    end
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