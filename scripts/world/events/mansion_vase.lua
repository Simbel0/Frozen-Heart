local mansion_vase, super = Class(Event, "mansion_vase")

function mansion_vase:init(data)
    super:init(self, data.x, data.y, data.width, data.height)

    self.sprite=Sprite("vase", 0, 0, nil, nil, "tilesets")
    self.sprite:setOrigin(0, 0.5)
    self:addChild(self.sprite)

    self.ystart = self.sprite.y

    self.siner=0
end

function mansion_vase:update(dt)
    self.siner = self.siner + 0.075*DTMULT

    self.sprite.y = (self.ystart + (math.sin((self.siner / 3)) * 10))
end

return mansion_vase