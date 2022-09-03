local far_fountain, super = Class(Event, "far_fountain")

function far_fountain:init(data)
	super:init(self, data.x, data.y)

	self.sprite=Sprite("fountain", 20, -5, nil, nil, "world/events/far_fountain")
	self.sprite:play(1/4)
	self.sprite:setScale(2)
	self.sprite:setOrigin(0.5, 0.5)
	self:addChild(self.sprite)
end

return far_fountain