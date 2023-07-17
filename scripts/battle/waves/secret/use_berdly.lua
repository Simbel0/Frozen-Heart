local berdly_dead, super = Class(Wave)

function berdly_dead:init()
	super.init(self)
	self:setArenaSize(182, 102)
	self:setArenaOffset(0, 80)
	self.time = -1
	self.check_end = false
end

function berdly_dead:onStart()
	self.ice_berdly = self:spawnSprite("berdly_ice", SCREEN_WIDTH/2, -30)
	self.timer:tween(1.5, self.ice_berdly, {y=100}, "out-expo")
	self.timer:after(1.55, function()
		self.timer:everyInstant(1, function()
			self.ice_berdly:shake(2, 0)
			for i=1,6 do
				local bullet = self:spawnBullet("secret/tornado", self.ice_berdly.x, self.ice_berdly.y, 0, 0)
				bullet.remove_offscreen = false
				bullet.layer = self.ice_berdly.layer-1
				bullet:setPhysics({
					speed_x = Utils.random(5, 10)*(i<=3 and 1 or -1),
					gravity_direction = math.rad(-90),
					gravity = 0.1*i
				})
			end
			Assets.playSound("wing")
		end, 3)
		self.timer:after(4, function()
			self.check_end = true
			local possible_ranges = {{10, self.ice_berdly.x-self.ice_berdly.width}, {self.ice_berdly.x+self.ice_berdly.width, SCREEN_WIDTH-10}}
			for i,bullet in ipairs(self.bullets) do
				local range = Utils.pick(possible_ranges)
				bullet:setPosition(Utils.random(Utils.unpack(range)), -30)
				bullet.produce_snow = false
				bullet.timer = 15*i-1
				bullet.layer = self.ice_berdly.layer+1
				bullet:resetPhysics()
			end
		end)
	end)
end

function berdly_dead:update()
	super.update(self)

	for i,bullet in ipairs(self.bullets) do
		if bullet.timer then
			bullet.timer = bullet.timer - 1
			if bullet.timer <= 0 then
				bullet.timer = nil
				bullet.produce_snow = true
				bullet.move_x = bullet.x<self.ice_berdly.x and 5 or -5
				bullet:setPhysics({
					speed_y = 11+Utils.random(-1.5, 1.5),
					friction = 0.2
				})
				self.timer:after(0.5, function() bullet.remove_offscreen = true end)
			end
		end
		if bullet.move_x then bullet.x = bullet.x + bullet.move_x end
	end

	if self.check_end then
		if #self.bullets == 0 then
			self.check_end = false
			self.timer:script(function(wait)
				local member = Utils.pick(Game.battle:getActiveParty())
				member.should_darken = false
				wait(15/60)
				Assets.playSound(member.chara:getAttackSound(), 1, member.chara:getAttackPitch())
				member:setAnimation("battle/attack")
				wait((1/15)*7)
				local slap = self:spawnSprite(member.chara:getAttackSprite(), Utils.random(self.ice_berdly.x-self.ice_berdly.width/2, self.ice_berdly.x-self.ice_berdly.width/2), Utils.random(self.ice_berdly.y+self.ice_berdly.height/2, self.ice_berdly.y+self.ice_berdly.height/2))
				print(slap:getPosition())
				slap:setLayer(self.ice_berdly.layer+10)
				slap:play(1/15, false, function(s)
					s:remove()
                end)
                wait(1/15)
                self.ice_berdly:shake(5)
                Assets.playSound("damage")
                self.ice_berdly:setPhysics({
                	speed_x = 3,
                	speed_y = -3,
                	gravity = 0.2
                })
                self.ice_berdly.graphics.spin = math.rad(2)
                wait(3)
                member:resetSprite()
                self.finished = true
			end)
		end
	end
end

return berdly_dead