local FreezingSprite, super = Class(Sprite)

function FreezingSprite:init(...)
	super:init(self, ...)

	self.frozen = false
    self.freeze_progress = 1
end

function FreezingSprite:draw()
	super:draw(self)

	if self.texture and self.frozen then
        if self.freeze_progress < 1 then
            Draw.pushScissor()
            Draw.scissorPoints(nil, self.texture:getHeight() * (1 - self.freeze_progress), nil, nil)
        end

        local last_shader = love.graphics.getShader()
        local shader = Kristal.Shaders["AddColor"]
        love.graphics.setShader(shader)
        shader:send("inputcolor", {0.8, 0.8, 0.9})
        shader:send("amount", 1)

        local r,g,b,a = self:getDrawColor()

        love.graphics.setColor(0, 0, 1, a * 0.8)
        love.graphics.draw(self.texture, -1, -1)
        love.graphics.setColor(0, 0, 1, a * 0.4)
        love.graphics.draw(self.texture, 1, -1)
        love.graphics.draw(self.texture, -1, 1)
        love.graphics.setColor(0, 0, 1, a * 0.8)
        love.graphics.draw(self.texture, 1, 1)

        love.graphics.setShader(last_shader)

        love.graphics.setBlendMode("add")
        love.graphics.setColor(0.8, 0.8, 0.9, a * 0.4)
        love.graphics.draw(self.texture)
        love.graphics.setBlendMode("alpha")

        if self.freeze_progress < 1 then
            Draw.popScissor()
        end
    end
end

return FreezingSprite