local chandeler, super = Class(Event, "chandeler")

function chandeler:init(data)
	super:init(self, data.x, data.y, 0, 0)

	self.sprite=Sprite("chandeler", 0, 0, nil, nil, "tilesets")
	self.sprite:setOrigin(0, 1)
	self:addChild(self.sprite)

	self.glow_sprite=Sprite("chandeler_lights", 0, 0, nil, nil, "tilesets")
	self.glow_sprite_fx=ColorMaskFX(nil, 0)
	self.glow_sprite:addFX(self.glow_sprite_fx)

	self.sprite:addChild(self.glow_sprite)

	self.fade = 0
end

function chandeler:update()
	self.fade = self.fade + 0.075*DTMULT

	self.glow_sprite_fx.amount = Utils.clamp((math.sin(((((1 * self.fade) + 3) * math.pi) / 2)) + 1), 0, 0.25)
end

return chandeler