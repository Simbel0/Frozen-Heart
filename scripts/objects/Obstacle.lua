local Obstable, super = Class(Object)

function Obstable:init(x, y, dest_x, dest_y, texture, level)
	super.init(self, x, y)

	self.health = level

	self.sprite = Sprite(texture, 0, 0)
	--self.sprite:setOrigin(0.5)
	--self.sprite:setScale(2)
	if self.health == 1 then
		self.sprite:setColor(21/255, 203/255, 231/255)
	elseif self.health == 2 then
		self.sprite:setColor(1, 1, 0)
	elseif self.health == 3 then
		self.sprite:setColor(1, 0, 0)
	end
	self.sprite:setScaleOrigin(0.5)
	self:addChild(self.sprite)

	self.width, self.height = self.sprite.width, self.sprite.height
	self:setHitbox(0, 0, self.width, self.height)

	self.dest_x, self.dest_y = dest_x, dest_y

	self.timer = 0
end

function Obstable:update()
	super.update(self)

	self.timer = self.timer + 4*DTMULT
	if self.timer < 100 then
		self.x = Utils.ease(self.init_x, self.dest_x, self.timer/100, "out-cubic")
		self.y = Utils.ease(self.init_y, self.dest_y, self.timer/100, "out-cubic")
	end

	for i,shot in ipairs(Game.stage:getObjects(YellowSoulShot)) do
		if self:collidesWith(shot) then
			self.health = self.health - (shot.big and 2 or 1)
			if self.health <= 0 then
				self:destroy()
			else
				if self.health == 1 then
					self.sprite:setColor(21/255, 203/255, 231/255)
				elseif self.health == 2 then
					self.sprite:setColor(1, 1, 0)
				end
			end
			if not shot.big then
				shot:destroy("c")
			else
				print(shot.health, shot.ignore)
				if self.health > 0 and shot.health then
					shot.health = shot.health - 1
				end
				if shot.health <= 0 then
					shot:destroy("b")
				end
			end
		end
	end
end

function Obstable:draw()
	super.draw(self)
	if DEBUG_RENDER and self.collider then
        self.collider:draw(0, 0, 1)
    end
end

function Obstable:destroy()
	self.collider = nil
	self.sprite:setGraphics({
		grow = 0.2,
		fade_to = 0,
		fade = 0.2,
		fade_callback = function() self:remove() end
	})
	Utils.removeFromTable(self.table, self)
end

return Obstable