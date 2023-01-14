local AcidShield, super = Class(Object)

function AcidShield:init(size, parent)
	super:init(self, parent.x, 0)

	self.layer = parent.layer
	self.blend = COLORS["green"]
	self.alpha = 0.9
	self.xscale = 2
	self.yscale = 2
	self.angle = 0
	self.speed = 0
	self.appeartimer = 0
	self.hurtsfxtimer = 0
	self.hurtsfxcon = 0
	self.siner = 0
	self.con = 0
	self.createeffect = 0
	self.timer = 0
	self.turn = 0
	self.shieldsiner = 0
	self.shieldstate = 0
	self.shieldtimer = 0
	self.appearcon = 0
	self.queenhandx = 510
	self.queenhandy = 115
	self.idealx = self.x
	self.shieldhurt = 0
	self.shieldhurttimer = 0
	self.shieldx = 0
	self.shieldy = 0
	self.shieldalpha = 1
	self.shieldheight = nil
	self.shieldhpgradual = 0
	self.imabouttobreak = 0
	self.imabouttobreak_alpha = 0.4
	self.imabouttobreak_siner = 0
	self.shaketimer = 0
	self.movetimer = 0
	self.movetype = 0
	self.movecon = 0
	self.movepiece = 0
	self.movetimer = 0
	self.destroycon = 0
	self.destroytimer = 0
	self.shieldsize = size

	self.shield_top = Assets.getTexture("shield/shield_top")
	self.shield_top_hurt = Assets.getTexture("shield/shield_top_hurt")
	self.shield_middle = Assets.getTexture("shield/shield_middle")
	self.shield_middle_hurt = Assets.getTexture("shield/shield_middle_hurt")
	self.shield_bottom = Assets.getTexture("shield/shield_bottom")
	self.shield_bottom_hurt = Assets.getTexture("shield/shield_bottom_hurt")

	--Toby hard-coded the order the shield parts move. Thanks Toby. I won't have to deal with converting a GML formula to Lua (for now)
	if size==7 then
		self.health = 400
		self.moveOrder = {
			4,
			3,
			2,
			5,
			6,
			1,
			0
		}
		self.shield_parts_texture = {
			self.shield_top,
			self.shield_middle,
			self.shield_middle,
			self.shield_middle,
			self.shield_middle,
			self.shield_middle,
			self.shield_bottom
		}
	elseif size==10 then
		self.health = 500
		self.moveOrder = {
			4,
			3,
			2,
			5,
			6,
			1,
			7,
			0,
			8,
			9
		}
		self.shield_parts_texture = {
			self.shield_top,
			self.shield_middle,
			self.shield_middle,
			self.shield_middle,
			self.shield_middle,
			self.shield_middle,
			self.shield_middle,
			self.shield_middle,
			self.shield_middle,
			self.shield_bottom
		}
	elseif size==12 then
		self.health = 600
		self.moveOrder = {
			4,
			3,
			2,
			5,
			6,
			1,
			7,
			0,
			8,
			9,
			10,
			11
		}
		self.shield_parts_texture = {
			self.shield_top,
			self.shield_middle,
			self.shield_middle,
			self.shield_middle,
			self.shield_middle,
			self.shield_middle,
			self.shield_middle,
			self.shield_middle,
			self.shield_middle,
			self.shield_middle,
			self.shield_middle,
			self.shield_bottom
		}
	end
	self.max_health = self.health

	self.swallow = Assets.getSound("swallow")
end

function AcidShield:hurt()
	self.hurtsfxcon=1
	self.shieldhurt=1
	self.shieldhurttimer=6
	self.swallow:play()
end

function AcidShield:onRemoveFromStage()
	local retro_explosion = RetroExplosion(self.x+40, self.y+120)
	Game.battle:addChild(retro_explosion)
end

function AcidShield:draw()
	self.shieldsiner = self.shieldsiner+1
	self.y = (math.sin((self.shieldsiner/6))*0.5)

	if self.shaketimer > 0 then
		self.x = ((xstart - self.shaketimer) + (self.shaketimer * 2))
		self.y = ((ystart - self.shaketimer) + (self.shaketimer * 2))
		self.shaketimer = self.shaketimer - 1
	end
	if self.hurtsfxcon == 1 then
		self.hurtsfxtimer = self.hurtsfxtimer + 1
		if not self.swallow:isPlaying() then
			self.swallow:play()
		end
		if self.hurtsfxtimer == 10 then
			self.hurtsfxcon = 0
			self.hurtsfxtimer = 0
		end
	end

	--Toby wtf
	local a
	if (self.shieldhp / self.shieldmaxhp) <= (self.health / self.max_health) then
		a = (self.shieldhp / self.shieldmaxhp)
		if self.shieldsize == 7 then
			if a < 0.8571428571428571 then
				self.shield_parts_texture[0] = self.shield_top_hurt
			else
				self.shield_parts_texture[0] = self.shield_top
			end
			if a < 0.7142857142857143 then
				self.shield_parts_texture[1] = self.shield_middle_hurt
			else
				self.shield_parts_texture[1] = self.shield_middle
			end
			if (a < 0.5714285714285714) then
				self.shield_parts_texture[2] = self.shield_middle_hurt
			else
				self.shield_parts_texture[2] = self.shield_middle
			end
			if (a < 0.42857142857142855) then
				self.shield_parts_texture[3] = self.shield_middle_hurt
			else
				self.shield_parts_texture[3] = self.shield_middle
			end
			if (a < 0.2857142857142857) then
				self.shield_parts_texture[4] = self.shield_middle_hurt
			else
				self.shield_parts_texture[4] = self.shield_middle
			end
			if (a < 0.14285714285714285) then
				self.shield_parts_texture[5] = self.shield_middle_hurt
			else
				self.shield_parts_texture[5] = self.shield_middle
			end
			if (a <= 0) then
				self.shield_parts_texture[6] = self.shield_bottom_hurt
			else
				self.shield_parts_texture[6] = self.shield_bottom
			end
		elseif (self.shieldsize == 10) then
			if (a < 0.9) then
				self.shield_parts_texture[0] = self.shield_top_hurt
			else
				self.shield_parts_texture[0] = self.shield_top
			end
			if (a < 0.8) then
				self.shield_parts_texture[1] = self.shield_middle_hurt
			else
				self.shield_parts_texture[1] = self.shield_middle
			end
			if (a < 0.7) then
				self.shield_parts_texture[2] = self.shield_middle_hurt
			else
				self.shield_parts_texture[2] = self.shield_middle
			end
			if (a < 0.6) then
				self.shield_parts_texture[3] = self.shield_middle_hurt
			else
				self.shield_parts_texture[3] = self.shield_middle
			end
			if (a < 0.5) then
				self.shield_parts_texture[4] = self.shield_middle_hurt
			else
				self.shield_parts_texture[4] = self.shield_middle
			end
			if (a < 0.4) then
				self.shield_parts_texture[5] = self.shield_middle_hurt
			else
				self.shield_parts_texture[5] = self.shield_middle
			end
			if (a < 0.3) then
				self.shield_parts_texture[6] = self.shield_middle_hurt
			else
				self.shield_parts_texture[6] = self.shield_middle
			end
			if (a < 0.2) then
				self.shield_parts_texture[7] = self.shield_middle_hurt
			else
				self.shield_parts_texture[7] = self.shield_middle
			end
			if (a < 0.1) then
				self.shield_parts_texture[8] = self.shield_middle_hurt
			else
				self.shield_parts_texture[8] = self.shield_middle
			end
			if (a <= 0) then
				self.shield_parts_texture[9] = self.shield_bottom_hurt
			else
				self.shield_parts_texture[9] = self.shield_bottom
			end
		elseif (self.shieldsize == 12) then
			if (a < 0.9166666666666666) then
				self.shield_parts_texture[0] = self.shield_top_hurt
			else
				self.shield_parts_texture[0] = self.shield_top
			end
			if (a < 0.8333333333333334) then
				self.shield_parts_texture[1] = self.shield_middle_hurt
			else
				self.shield_parts_texture[1] = self.shield_middle
			end
			if (a < 0.75) then
				self.shield_parts_texture[2] = self.shield_middle_hurt
			else
				self.shield_parts_texture[2] = self.shield_middle
			end
			if (a < (2/3)) then
				self.shield_parts_texture[3] = self.shield_middle_hurt
			else
				self.shield_parts_texture[3] = self.shield_middle
			end
			if (a < 0.5833333333333334) then
				self.shield_parts_texture[4] = self.shield_middle_hurt
			else
				self.shield_parts_texture[4] = self.shield_middle
			end
			if (a < 0.5) then
				self.shield_parts_texture[5] = self.shield_middle_hurt
			else
				self.shield_parts_texture[5] = self.shield_middle
			end
			if (a < 0.4166666666666667) then
				self.shield_parts_texture[6] = self.shield_middle_hurt
			else
				self.shield_parts_texture[6] = self.shield_middle
			end
			if (a < (1/3)) then
				self.shield_parts_texture[7] = self.shield_middle_hurt
			else
				self.shield_parts_texture[7] = self.shield_middle
			end
			if (a < 0.25) then
				self.shield_parts_texture[8] = self.shield_middle_hurt
			else
				self.shield_parts_texture[8] = self.shield_middle
			end
			if (a < 0.16666666666666666) then
				self.shield_parts_texture[9] = self.shield_middle_hurt
			else
				self.shield_parts_texture[9] = self.shield_middle
			end
			if (a < 0.08333333333333333) then
				self.shield_parts_texture[10] = self.shield_middle_hurt
			else
				self.shield_parts_texture[10] = self.shield_middle
			end
			if (a <= 0) then
				self.shield_parts_texture[11] = self.shield_bottom_hurt
			else
				self.shield_parts_texture[11] = self.shield_bottom
			end
		end
	else
		a = (self.health / self.max_health)
		if (self.shieldsize == 7) then
			if (a < 0.8571428571428571) then
				self.shield_parts_texture[0] = self.shield_top_hurt
			else
				self.shield_parts_texture[0] = self.shield_top
			end
			if (a < 0.7142857142857143) then
				self.shield_parts_texture[1] = self.shield_middle_hurt
			else
				self.shield_parts_texture[1] = self.shield_middle
			end
			if (a < 0.5714285714285714) then
				self.shield_parts_texture[2] = self.shield_middle_hurt
			else
				self.shield_parts_texture[2] = self.shield_middle
			end
			if (a < 0.42857142857142855) then
				self.shield_parts_texture[3] = self.shield_middle_hurt
			else
				self.shield_parts_texture[3] = self.shield_middle
			end
			if (a < 0.2857142857142857) then
				self.shield_parts_texture[4] = self.shield_middle_hurt
			else
				self.shield_parts_texture[4] = self.shield_middle
			end
			if (a < 0.14285714285714285) then
				self.shield_parts_texture[5] = self.shield_middle_hurt
			else
				self.shield_parts_texture[5] = self.shield_middle
			end
			if (a <= 0) then
				self.shield_parts_texture[6] = self.shield_bottom_hurt
			else
				self.shield_parts_texture[6] = self.shield_bottom
			end
		elseif (self.shieldsize == 10) then
			if (a < 0.9) then
				self.shield_parts_texture[0] = self.shield_top_hurt
			else
				self.shield_parts_texture[0] = self.shield_top
			end
			if (a < 0.8) then
				self.shield_parts_texture[1] = self.shield_middle_hurt
			else
				self.shield_parts_texture[1] = self.shield_middle
			end
			if (a < 0.7) then
				self.shield_parts_texture[2] = self.shield_middle_hurt
			else
				self.shield_parts_texture[2] = self.shield_middle
			end
			if (a < 0.6) then
				self.shield_parts_texture[3] = self.shield_middle_hurt
			else
				self.shield_parts_texture[3] = self.shield_middle
			end
			if (a < 0.5) then
				self.shield_parts_texture[4] = self.shield_middle_hurt
			else
				self.shield_parts_texture[4] = self.shield_middle
			end
			if (a < 0.4) then
				self.shield_parts_texture[5] = self.shield_middle_hurt
			else
				self.shield_parts_texture[5] = self.shield_middle
			end
			if (a < 0.3) then
				self.shield_parts_texture[6] = self.shield_middle_hurt
			else
				self.shield_parts_texture[6] = self.shield_middle
			end
			if (a < 0.2) then
				self.shield_parts_texture[7] = self.shield_middle_hurt
			else
				self.shield_parts_texture[7] = self.shield_middle
			end
			if (a < 0.1) then
				self.shield_parts_texture[8] = self.shield_middle_hurt
			else
				self.shield_parts_texture[8] = self.shield_middle
			end
			if (a <= 0) then
				self.shield_parts_texture[9] = self.shield_bottom_hurt
			else
				self.shield_parts_texture[9] = self.shield_bottom
			end
		elseif (self.shieldsize == 12) then
			if (a < 0.9166666666666666) then
				self.shield_parts_texture[0] = self.shield_top_hurt
			else
				self.shield_parts_texture[0] = self.shield_top
			end
			if (a < 0.8333333333333334) then
				self.shield_parts_texture[1] = self.shield_middle_hurt
			else
				self.shield_parts_texture[1] = self.shield_middle
			end
			if (a < 0.75) then
				self.shield_parts_texture[2] = self.shield_middle_hurt
			else
				self.shield_parts_texture[2] = self.shield_middle
			end
			if (a < (2/3)) then
				self.shield_parts_texture[3] = self.shield_middle_hurt
			else
				self.shield_parts_texture[3] = self.shield_middle
			end
			if (a < 0.5833333333333334) then
				self.shield_parts_texture[4] = self.shield_middle_hurt
			else
				self.shield_parts_texture[4] = self.shield_middle
			end
			if (a < 0.5) then
				self.shield_parts_texture[5] = self.shield_middle_hurt
			else
				self.shield_parts_texture[5] = self.shield_middle
			end
			if (a < 0.4166666666666667) then
				self.shield_parts_texture[6] = self.shield_middle_hurt
			else
				self.shield_parts_texture[6] = self.shield_middle
			end
			if (a < (1/3)) then
				self.shield_parts_texture[7] = self.shield_middle_hurt
			else
				self.shield_parts_texture[7] = self.shield_middle
			end
			if (a < 0.25) then
				self.shield_parts_texture[8] = self.shield_middle_hurt
			else
				self.shield_parts_texture[8] = self.shield_middle
			end
			if (a < 0.16666666666666666) then
				self.shield_parts_texture[9] = self.shield_middle_hurt
			else
				self.shield_parts_texture[9] = self.shield_middle
			end
			if (a < 0.08333333333333333) then
				self.shield_parts_texture[10] = self.shield_middle_hurt
			else
				self.shield_parts_texture[10] = self.shield_middle
			end
			if (a <= 0) then
				self.shield_parts_texture[11] = self.shield_bottom_hurt
			else
				self.shield_parts_texture[11] = self.shield_middle
			end
		end
	end
end

return AcidShield