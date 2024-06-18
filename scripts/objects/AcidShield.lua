local AcidShield, super = Class(Object)

function AcidShield:init(size, parent)
	super:init(self, parent.x, 0)

	self.parent = parent

	self.layer = parent.layer
	self.blend = COLORS["green"]
	self.alpha = 0.9
	self.xscale = 1
	self.yscale = 1
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
	self.queenhandx = 50
	self.queenhandy = 20
	self.idealx = self.x
	self.shieldhurt = 0
	self.shieldhurttimer = 0
	self.shieldx = 0
	self.shieldy = 0
	self.alpha = 1
	self.shieldheight = nil
	self.shieldhpgradual = 0
	self.imabouttobreak = 0
	self.imabouttobreak_alpha = 0.4
	self.imabouttobreak_siner = 0
	self.shaketimer = 0
	self.movetimer = 0
	self.movetype = 0
	self.movecon = 0
	self.movepiece = 1
	self.movetimer = 0
	self.destroycon = 0
	self.destroytimer = 0
	self.shieldsize = size

	self.queenhandx = -16
	self.queenhandy = 13

	self.ignore_state = false

	self.shield_top = Assets.getTexture("shield/shield_top")
	self.shield_top_hurt = Assets.getTexture("shield/shield_top_hurt")
	self.shield_middle = Assets.getTexture("shield/shield_middle")
	self.shield_middle_hurt = Assets.getTexture("shield/shield_middle_hurt")
	self.shield_bottom = Assets.getTexture("shield/shield_bottom")
	self.shield_bottom_hurt = Assets.getTexture("shield/shield_bottom_hurt")


	self.shieldpiece_x_origin = {}
	self.shieldpiece_y_origin = {}
	self.shieldpiece_x = {}
	self.shieldpiece_y = {}
	self.shieldpiece_y_save = {}
	self.shieldpiece_visible = {}
	self.shieldpiece_xscale = {}
	self.shieldpiece_yscale = {}
	self.shieldpiece_alpha = {}
	self.shieldpiece_sprite_index = {}
	self.shieldpiece_image_index = {}
	self.shieldpiece_fadetimer = {}
	self.shieldpiece_fadecon = {}
	self.depthorder = {}
	for i = 1,14 do
		self.shieldpiece_x_origin[i] = (self.x + 9)
		if (self.shieldsize == 7) then
			self.shieldpiece_y_origin[i] = (self.y - 55)
		end
		if (self.shieldsize == 10) then
			self.shieldpiece_y_origin[i] = (self.y - 55)
		end
		if (self.shieldsize == 12) then
			self.shieldpiece_y_origin[i] = (self.y - 55)
		end
		self.shieldpiece_x[i] = (self.x + 9)
		self.shieldpiece_y[i] = (self.y - 55)
		self.shieldpiece_y_save[i] = (self.y - 55)
		self.shieldpiece_visible[i] = 1
		self.shieldpiece_xscale[i] = 1
		self.shieldpiece_yscale[i] = 1
		self.shieldpiece_alpha[i] = 0
		self.shieldpiece_sprite_index[i] = nil
		self.shieldpiece_image_index[i] = 0
		self.shieldpiece_fadetimer[i] = 0
		self.shieldpiece_fadecon[i] = 0
		self.depthorder[i] = 1
	end

	--Toby hard-coded the order the shield parts move. Thanks Toby. I won't have to deal with converting a GML formula to Lua (for now)
	if size==7 then
		self.health = 100
		self.moveorder = {
			5,
			4,
			3,
			6,
			7,
			2,
			1
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
		self.shield_parts_texture_hurt = {
			self.shield_top_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_bottom_hurt
		}
	elseif size==10 then
		self.health = 150
		self.moveorder = {
			5,
			4,
			3,
			6,
			7,
			2,
			8,
			1,
			9,
			10
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
		self.shield_parts_texture_hurt = {
			self.shield_top_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_bottom_hurt
		}
	elseif size==12 then
		self.health = 200
		self.moveorder = {
			5,
			4,
			3,
			6,
			7,
			2,
			8,
			1,
			9,
			10,
			11,
			12
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
		self.shield_parts_texture_hurt = {
			self.shield_top_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_middle_hurt,
			self.shield_bottom_hurt
		}
	end
	print(Utils.dump(self.moveorder))
	self.max_health = self.health

	self.swallow = Assets.getSound("swallow")

	self.xstart = self.x
	self.ystart = self.y
end

function AcidShield:hurt(damage)
	self.health = self.health - damage
	self.hurtsfxcon=1
	self.shieldhurt=1
	self.shieldhurttimer=6
	self.swallow:play()
end

function AcidShield:onRemoveFromStage()
	local retro_explosion = RetroExplosion(self.x+205, self.y+130)
	Game.battle:addChild(retro_explosion)

	local queen = Game.battle.encounter.queen
	queen.glass:remove()
	queen:setAnimation({"hurt", 1/14, true})
	queen.physics.speed_x = -30
	queen.physics.gravity = 1.5
	queen.physics.gravity_direction = 0
	queen.shield_broken = true
	queen.shield = nil
end

function AcidShield:draw()
	print(self.movecon)
	self.shieldsiner = self.shieldsiner+DTMULT
	self.y = (math.sin((self.shieldsiner/6))*0.5)*DTMULT

	if self.shaketimer > 0 then
		self.x = ((self.xstart - self.shaketimer*DTMULT) + (self.shaketimer * (2*DTMULT)))
		self.y = ((self.ystart - self.shaketimer*DTMULT) + (self.shaketimer * (2*DTMULT)))
		self.shaketimer = self.shaketimer - DTMULT
	end
	if self.hurtsfxcon == 1 then
		self.hurtsfxtimer = self.hurtsfxtimer + DTMULT
		if not self.swallow:isPlaying() then
			self.swallow:play()
		end
		if self.hurtsfxtimer >= 10 then
			self.hurtsfxcon = 0
			self.hurtsfxtimer = 0
		end
	end

	--Toby wtf
	local a = (self.health / self.max_health)
	if (self.shieldsize == 7) then
		if (a < 0.8571428571428571) then
			self.shield_parts_texture[1] = self.shield_top_hurt
		else
			self.shield_parts_texture[1] = self.shield_top
		end
		if (a < 0.7142857142857143) then
			self.shield_parts_texture[2] = self.shield_middle_hurt
		else
			self.shield_parts_texture[2] = self.shield_middle
		end
		if (a < 0.5714285714285714) then
			self.shield_parts_texture[3] = self.shield_middle_hurt
		else
			self.shield_parts_texture[3] = self.shield_middle
		end
		if (a < 0.42857142857142855) then
			self.shield_parts_texture[4] = self.shield_middle_hurt
		else
			self.shield_parts_texture[4] = self.shield_middle
		end
		if (a < 0.2857142857142857) then
			self.shield_parts_texture[5] = self.shield_middle_hurt
		else
			self.shield_parts_texture[5] = self.shield_middle
		end
		if (a < 0.14285714285714285) then
			self.shield_parts_texture[6] = self.shield_middle_hurt
		else
			self.shield_parts_texture[6] = self.shield_middle
		end
		if (a <= 0) then
			self.shield_parts_texture[7] = self.shield_bottom_hurt
		else
			self.shield_parts_texture[7] = self.shield_bottom
		end
	elseif (self.shieldsize == 10) then
		if (a < 0.9) then
			self.shield_parts_texture[1] = self.shield_top_hurt
		else
			self.shield_parts_texture[1] = self.shield_top
		end
		if (a < 0.8) then
			self.shield_parts_texture[2] = self.shield_middle_hurt
		else
			self.shield_parts_texture[2] = self.shield_middle
		end
		if (a < 0.7) then
			self.shield_parts_texture[3] = self.shield_middle_hurt
		else
			self.shield_parts_texture[3] = self.shield_middle
		end
		if (a < 0.6) then
			self.shield_parts_texture[4] = self.shield_middle_hurt
		else
			self.shield_parts_texture[4] = self.shield_middle
		end
		if (a < 0.5) then
			self.shield_parts_texture[5] = self.shield_middle_hurt
		else
			self.shield_parts_texture[5] = self.shield_middle
		end
		if (a < 0.4) then
			self.shield_parts_texture[6] = self.shield_middle_hurt
		else
			self.shield_parts_texture[6] = self.shield_middle
		end
		if (a < 0.3) then
			self.shield_parts_texture[7] = self.shield_middle_hurt
		else
			self.shield_parts_texture[7] = self.shield_middle
		end
		if (a < 0.2) then
			self.shield_parts_texture[8] = self.shield_middle_hurt
		else
			self.shield_parts_texture[8] = self.shield_middle
		end
		if (a < 0.1) then
			self.shield_parts_texture[9] = self.shield_middle_hurt
		else
			self.shield_parts_texture[9] = self.shield_middle
		end
		if (a <= 0) then
			self.shield_parts_texture[10] = self.shield_bottom_hurt
		else
			self.shield_parts_texture[10] = self.shield_bottom
		end
	elseif (self.shieldsize == 12) then
		if (a < 0.9166666666666666) then
			self.shield_parts_texture[1] = self.shield_top_hurt
		else
			self.shield_parts_texture[1] = self.shield_top
		end
		if (a < 0.8333333333333334) then
			self.shield_parts_texture[2] = self.shield_middle_hurt
		else
			self.shield_parts_texture[2] = self.shield_middle
		end
		if (a < 0.75) then
			self.shield_parts_texture[3] = self.shield_middle_hurt
		else
			self.shield_parts_texture[3] = self.shield_middle
		end
		if (a < (2/3)) then
			self.shield_parts_texture[4] = self.shield_middle_hurt
		else
			self.shield_parts_texture[4] = self.shield_middle
		end
		if (a < 0.5833333333333334) then
			self.shield_parts_texture[5] = self.shield_middle_hurt
		else
			self.shield_parts_texture[5] = self.shield_middle
		end
		if (a < 0.5) then
			self.shield_parts_texture[6] = self.shield_middle_hurt
		else
			self.shield_parts_texture[6] = self.shield_middle
		end
		if (a < 0.4166666666666667) then
			self.shield_parts_texture[7] = self.shield_middle_hurt
		else
			self.shield_parts_texture[7] = self.shield_middle
		end
		if (a < (1/3)) then
			self.shield_parts_texture[8] = self.shield_middle_hurt
		else
			self.shield_parts_texture[8] = self.shield_middle
		end
		if (a < 0.25) then
			self.shield_parts_texture[9] = self.shield_middle_hurt
		else
			self.shield_parts_texture[9] = self.shield_middle
		end
		if (a < 0.16666666666666666) then
			self.shield_parts_texture[10] = self.shield_middle_hurt
		else
			self.shield_parts_texture[10] = self.shield_middle
		end
		if (a < 0.08333333333333333) then
			self.shield_parts_texture[11] = self.shield_middle_hurt
		else
			self.shield_parts_texture[11] = self.shield_middle
		end
		if (a <= 0) then
			self.shield_parts_texture[12] = self.shield_bottom_hurt
		else
			self.shield_parts_texture[12] = self.shield_bottom
		end
	end

	if self.shieldpiece_yscale[1] > 0.1 then
		if self.movecon == 15 and self.alpha > 0 then
			self.alpha = self.alpha - 0.1*DTMULT
		end
		if self.movecon ~= 15 and self.alpha < 1 then
			self.alpha = self.alpha + 0.1*DTMULT
		end
		local x1, y1, x2, y2
		if self.parent.sprite.sprite == "chair" then
			x1 = 10
			y1 = 5
			x2 = 10
			y2 = 22
		else
			x1 = 17
			y1 = 15
			x2 = 17
			y2 = 0
		   end
		if self.appearcon == 3 then
			local a = ((16 - (16 * (self.shieldpiece_yscale[1] / 2))) * 2)
			love.graphics.setColor(0, 1, 0, self.alpha * 0.8)
			love.graphics.setLineStyle("rough")
			love.graphics.setLineWidth(0.5)
			love.graphics.line((self.queenhandx + x1), (self.queenhandy - y1), (self.x + 14), ((self.shieldpiece_y[1] + self.y) - 48))
			love.graphics.setColor(0, 0, 1, self.alpha * 0.8)
			love.graphics.line((self.queenhandx + x2), (self.queenhandy + y2), (self.x + 81), (((self.shieldpiece_y[(self.shieldsize - 1)] + self.y) + 33) - a))
		else
			love.graphics.setColor(0, 1, 0, self.alpha * 0.8)
			love.graphics.setLineStyle("rough")
			love.graphics.setLineWidth(0.5)
			love.graphics.line((self.queenhandx + x1), (self.queenhandy - y1), (self.x + 50), ((self.shieldpiece_y[1] + self.y) + 3))
			love.graphics.line((self.queenhandx + x2), (self.queenhandy + y2), (self.x + 10), ((self.shieldpiece_y[(self.shieldsize - 1)] + self.y) + 53))
		end
	end
	if self.shieldhurt == 0 then

		for i=0, 13 do
			local ii = self.depthorder[(14 - i)]
			love.graphics.setColor(1, 1, 1, self.shieldpiece_alpha[ii])
			if self.shield_parts_texture[ii]~=nil then
				love.graphics.draw(self.shield_parts_texture[ii], self.shieldpiece_x[ii], (self.shieldpiece_y[ii] + self.y), 0, self.shieldpiece_xscale[ii], self.shieldpiece_yscale[ii])
				if self.shieldpiece_fadecon[ii] == 1 then
					if self.shieldpiece_fadetimer[ii] < 10 then
						self.shieldpiece_fadetimer[ii] = self.shieldpiece_fadetimer[ii] + DTMULT
					end
					love.graphics.setColor(1, 1, 1, (self.shieldpiece_fadetimer[ii] / 10))
					love.graphics.draw(self.shield_parts_texture_hurt[ii], self.shieldpiece_x[ii], (self.shieldpiece_y[ii] + self.y), 0, self.shieldpiece_xscale[ii], self.shieldpiece_yscale[ii])
				end
			end
			if self.shieldpiece_fadecon[ii] == 2 then
				self.shieldpiece_fadetimer[ii] = self.shieldpiece_fadetimer[ii] - DTMULT
				if (self.shieldpiece_fadetimer[ii] <= 0) then
					self.shieldpiece_fadetimer[ii] = 0
					self.shieldpiece_fadecon[ii] = 0
				end
				love.graphics.setColor(1, 1, 1, (self.shieldpiece_fadetimer[ii] / 10))
				love.graphics.draw(self.shield_parts_texture_hurt[ii], self.shieldpiece_x[ii], (self.shieldpiece_y[ii] + self.y), 0, self.shieldpiece_xscale[ii], self.shieldpiece_yscale[ii])
			end
			if self.health <= 5 then
				self.imabouttobreak_siner = self.imabouttobreak_siner + 0.5*DTMULT
				self.imabouttobreak_alpha = (0.1 + (math.sin(self.imabouttobreak_siner) / 6))*DTMULT
				--d3d_set_fog(true, c_white, 0, 1) --Apparently, it's basically a blur effect but with colors. And it's outdated in GM2 so does it even work in Deltarune?
				if #self.moveorder>ii then
					love.graphics.setColor(1, 1, 1, self.imabouttobreak_alpha*Utils.clamp(self.alpha, 0, 1))
					love.graphics.draw(self.shield_parts_texture[ii], self.shieldpiece_x[ii], (self.shieldpiece_y[ii] + self.y), 0, self.shieldpiece_xscale[ii], self.shieldpiece_yscale[ii])
				end
				--d3d_set_fog(false, c_black, 0, 0)
			end
		end
	end
	local repeat_i = 0
	repeat
		if (self.appearcon == 1) then
			--{-40, -15, 5, 25, 45, 65, 90, -165, -165, -165, -165, -165, -165, -165}
			if (self.shieldsize == 7) then
				self.shieldpiece_y_origin[1] = 22
				self.shieldpiece_y_origin[2] = 35
				self.shieldpiece_y_origin[3] = 45
				self.shieldpiece_y_origin[4] = 55
				self.shieldpiece_y_origin[5] = 65
				self.shieldpiece_y_origin[6] = 75
				self.shieldpiece_y_origin[7] = 88
			end
			if (self.shieldsize == 10) then
				--{-50, -25, -5, 15, 35, 55, 75, 95, 115, -155, -155, -155, -155, -155}
				self.shieldpiece_y_origin[1] = -8
				self.shieldpiece_y_origin[2] = 5
				self.shieldpiece_y_origin[3] = 15
				self.shieldpiece_y_origin[4] = 25
				self.shieldpiece_y_origin[5] = 35
				self.shieldpiece_y_origin[6] = 45
				self.shieldpiece_y_origin[7] = 55
				self.shieldpiece_y_origin[8] = 65
				self.shieldpiece_y_origin[9] = 75
				self.shieldpiece_y_origin[10] = 88
			end
			if (self.shieldsize == 12) then
				self.shieldpiece_y_origin[1] = -18
				self.shieldpiece_y_origin[2] = -5
				self.shieldpiece_y_origin[3] = 5
				self.shieldpiece_y_origin[4] = 15
				self.shieldpiece_y_origin[5] = 25
				self.shieldpiece_y_origin[6] = 35
				self.shieldpiece_y_origin[7] = 45
				self.shieldpiece_y_origin[8] = 55
				self.shieldpiece_y_origin[9] = 65
				self.shieldpiece_y_origin[10] = 75
				self.shieldpiece_y_origin[11] = 85
				self.shieldpiece_y_origin[12] = 95
			end
			for i=1, 14 do
				self.shieldpiece_yscale[i] = 1
				self.shieldpiece_alpha[i] = 0
			end
			self.appearcon = 0
			self.movetype = 0
			self.movetimer = 0
			self.movecon = 1
			self.movepiece = 1
		end
		if self.movecon == 1 then
			self.movecon = 2
			self.shieldpiece_fadecon[self.moveorder[self.movepiece]] = 1
		end
		if self.movecon == 2 then
			self.movetimer = self.movetimer + 2*DTMULT
			self.shieldpiece_x[self.moveorder[self.movepiece]] = Utils.ease(self.shieldpiece_x_origin[self.moveorder[self.movepiece]], (self.shieldpiece_x_origin[self.moveorder[self.movepiece]] + 15), (self.movetimer / 10), "out-quad")
			self.shieldpiece_alpha[self.moveorder[self.movepiece]] = Utils.lerp(0, 1, (self.movetimer / 10))
			if self.movetimer >= 10 then
				self.movetimer = 0
				self.movecon = 3
			end
		end
		if self.movecon == 3 then
			self.movetimer = self.movetimer + 2*DTMULT
			self.shieldpiece_y[self.moveorder[self.movepiece]] = Utils.lerp(self.shieldpiece_y[self.moveorder[self.movepiece]], self.shieldpiece_y_origin[self.moveorder[self.movepiece]], (self.movetimer / 10))
			if (self.movetimer >= 10) then
				self.movetimer = 0
				self.movecon = 4
				self.shieldpiece_fadecon[self.moveorder[self.movepiece]] = 2
			end
			self:event_user(2)
		end
		if self.movecon == 4 then
			self.movetimer = self.movetimer + 2*DTMULT
			self.shieldpiece_x[self.moveorder[self.movepiece]] = Utils.ease((self.shieldpiece_x_origin[self.moveorder[self.movepiece]] + 15), self.shieldpiece_x_origin[self.moveorder[self.movepiece]], (self.movetimer / 10), "out-quad")
			if (self.movetimer >= 10) then
				self.movetimer = 0
				self.movecon = 5
			end
		end
		if (self.movecon == 5) then
			if (self.movepiece == (self.shieldsize)) then
				self.movecon = 0
				self.movepiece = 0
			else
				self.movepiece = self.movepiece + 1
				self.movecon = 1
			end
		end
		repeat_i = repeat_i + 1
	until repeat_i==3
	repeat_i = 0
	repeat
		if (self.appearcon == 2) then
			self.appearcon = 0
			self.movetype = 0
			self.movetimer = 0
			self.movecon = 10
			self.movepiece = 1
		end
		if (self.movecon == 10) then
			self.movecon = 11
			self.shieldpiece_fadecon[self.moveorder[self.movepiece]] = 1
		end
		if (self.movecon == 11) then
			self.movetimer = self.movetimer + 2*DTMULT
			self.shieldpiece_x[self.moveorder[self.movepiece]] = Utils.ease(self.shieldpiece_x_origin[self.moveorder[self.movepiece]], (self.shieldpiece_x_origin[self.moveorder[self.movepiece]] + 15), (self.movetimer / 10), "out-quad")
			if (self.movetimer >= 10) then
				self.movetimer = 0
				self.movecon = 12
			end
		end
		if (self.movecon == 12) then
			self.movetimer = self.movetimer + 2*DTMULT
			self.shieldpiece_y[self.moveorder[self.movepiece]] = Utils.lerp(self.shieldpiece_y_origin[self.moveorder[self.movepiece]], (self.ystart + 25), (self.movetimer / 10))
			if (self.movetimer >= 10) then
				self.movetimer = 0
				self.movecon = 13
				self.shieldpiece_fadecon[self.moveorder[self.movepiece]] = 2
			end
			self:event_user(2)
		end
		if (self.movecon == 13) then
			self.movetimer = self.movetimer + 2*DTMULT
			self.shieldpiece_x[self.moveorder[self.movepiece]] = Utils.ease((self.shieldpiece_x_origin[self.moveorder[self.movepiece]] + 15), self.shieldpiece_x_origin[self.moveorder[self.movepiece]], (self.movetimer / 10), "out-quad")
			if (self.movetimer >= 10) then
				self.movetimer = 0
				self.movecon = 14
			end
		end
		if (self.movecon == 14) then
			if (self.movepiece == (self.shieldsize)) then
				self.movecon = 15
				self.movepiece = 0
			else
				self.movepiece = self.movepiece + 1
				self.movecon = 10
			end
		end
		if (self.movecon == 15) then
			if (self.movetimer < 50) then
				self.movetimer = self.movetimer + DTMULT
			end
			for i = 1, 12 do
				self.shieldpiece_alpha[i] = Utils.lerp(1, 0, (self.movetimer / 50))
			end
		end
		repeat_i = repeat_i + 1
	until repeat_i == 5
	if self.shieldhurt == 1 then
	    self.shieldx = ((Utils.random(self.shieldhurttimer) - Utils.random(self.shieldhurttimer)) * 2)
	    self.shieldhurttimer = self.shieldhurttimer - DTMULT
	    if (self.shieldhurttimer <= 0) then
	    	self.shieldhurttimer = 0
	        self.shieldhurt = 0
	    end
	    for i = 1, 12 do
	        self.shieldpiece_x[i] = (((self.x + 9) - 6) + love.math.random(12))
	        if self.shield_parts_texture[i]~=nil then
	        	love.graphics.setColor(1, 1, 1, self.shieldpiece_alpha[i])
	        	love.graphics.draw(self.shield_parts_texture[i], self.shieldpiece_x[i], (self.shieldpiece_y[i] + self.y), 0, self.shieldpiece_xscale[i], self.shieldpiece_yscale[i])
	        end
	        if (self.shieldhurt == 0) then
	        	self.shieldpiece_x[i] = (self.x + 9)
	        end
	    end
	end
end

function AcidShield:event_user(nb)
	if nb==2 then
		for i = 1, 14 do
	    	self.shieldpiece_y_save[i] = self.shieldpiece_y[i]
	    end
		local c = 0
		while c < 14 do
    		local b = math.min(self.shieldpiece_y[1], self.shieldpiece_y[2], self.shieldpiece_y[3], self.shieldpiece_y[4], self.shieldpiece_y[5], self.shieldpiece_y[6], self.shieldpiece_y[7], self.shieldpiece_y[8], self.shieldpiece_y[9], self.shieldpiece_y[10], self.shieldpiece_y[11], self.shieldpiece_y[12], self.shieldpiece_y[13], self.shieldpiece_y[14])
    		for i = 1, 14 do
        		if (b == self.shieldpiece_y[i]) then
            		self.depthorder[c] = i
            		c = c + 1
            		self.shieldpiece_y[i] = 9999
        		end
    		end
		end
		for i = 1, 14 do
		    self.shieldpiece_y[i] = self.shieldpiece_y_save[i]
		end
	end
end

function AcidShield:isInTransition()
	return self.movecon~=0
end

return AcidShield