local CONTROL, super = Class(Wave)

function CONTROL:init()
	super:init(self)

	self.time = -1
end

function CONTROL:onStart()
	self.box = self:spawnSprite("bullets/memories/box", Game.battle.arena.left+Game.battle.arena.width/2, Game.battle.arena.top/2)

	self.action = self:spawnSpriteTo(self.box, "bullets/memories/act", self.box.width/2, self.box.height/2)
	self.action:setScale(1)
	self.action.current = "act"

	self.reroll = function()
		if self.rerolls > 2 then
			self.finished = true
			return
		end
		self.action.alpha = 1
		self.roll = true
		self.timer:after(1.5, function()
			self.roll = false
			self.timer:after(1, function()
				self.start_attack = true
			end)
		end)
		self.rerolls = self.rerolls + 1
	end

	self.rerolls = 0

	self.reroll()

	self.timer:everyInstant(1/16, function()
		local acts = {"fight", "act", "item", "spare"}

		Utils.removeFromTable(acts, self.action.current)

		if self.roll then
			local act = Utils.pick(acts)
			self.action:setSprite("bullets/memories/"..act)
			self.action.current = act
		end
	end)
end

function CONTROL:update()
	super:update(self)

	if self.start_attack then
		local every_function, time = nil, 1

		local physics, pos = {}, {0, 0}
		if self.action.current == "fight" then
			time = 1/3
			every_function = function()
				pos = {-10, Utils.random(-10, SCREEN_HEIGHT+10)}
				physics = {
					speed=10,
					match_rotation = true
				}
				local b = self:spawnBullet("secret/memories/action", self.action.current, pos[1], pos[2], physics)
				b.rotation = Utils.angle(b, Game.battle.soul)
				b:setHitbox(6.75, 8.7, 13.5, 4)
			end
		elseif self.action.current == "act" then
			time = 1/6
			every_function = function()
				self.action.alpha = 0
				pos = {self.action:getScreenPos()}
				physics = {
					speed = 4,
					direction = math.rad(90)
				}
				local b = self:spawnBullet("secret/memories/action", self.action.current, pos[1], pos[2], physics)
				b.graphics.spin = math.rad(3)
				b.sprite.rotation = 0
				return false
			end
		elseif self.action.current == "spare" then
			time = 1/3
			every_function = function()
				pos = {Utils.random(SCREEN_WIDTH, SCREEN_WIDTH+20), Utils.random(-20, 0)}
				physics = {
					speed = 12,
					direction = math.rad(Utils.random(120, 170))
				}
				local b = self:spawnBullet("secret/memories/action", self.action.current, pos[1], pos[2], physics)
				b.graphics.spin = 3
			end
		elseif self.action.current == "item" then
			time = 1/4
			every_function = function()
				pos = {self.box.x, self.box.y-(self.box.y/2)+5}
				physics = {
					speed_y = -10,
					gravity = -0.5,
					gravity_direction = math.rad(-90+Utils.random(-10, 10))
				}
				local b = self:spawnBullet("secret/memories/action", self.action.current, pos[1], pos[2], physics)
				b.graphics.spin = 1
				b:setHitbox(7.75, 6, 6.5, 5)
			end
		end
		self.timer:after(0.5, function()
			self.timer:every(time, every_function, 30)
			self.timer:after((time*30)+0.25, self.reroll)
		end)
		self.start_attack = false
	end
end

return CONTROL