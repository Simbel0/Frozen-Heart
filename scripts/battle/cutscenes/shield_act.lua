return function(cutscene, user, target)
	if target.first_shield then
		target.first_shield = false
		cutscene:text("* Make A Shield?", "surprise", "queen")
		cutscene:text("* Kris I Like Your Way Of Thinking.", "smirk", "queen")
	elseif Game.battle.encounter.queen.shield then
		cutscene:text("* Kris I Can't Hold Two Glasses Of Wine In The Same Hand", "sorry", "queen")
		cutscene:text("* Please Get Worse At Dodging If You Want More Of My Battery Acid", "smile_side_r", "queen")
		Game:giveTension(96/2) --You're stoopid but here
		cutscene:endCutscene()
		return
	else
		cutscene:wait(0.5)
	end
	local queen = Game.battle.encounter.queen
	queen:setAnimation({"act", 1/8, true})
	queen.air_mouv = false
	local glass = Sprite("wine_glass")
	glass:setScale(0.2, 0.3)
	glass:setOrigin(0.5, 0.5)
	glass.layer = queen.layer+1
	glass:setHitbox(0, 30, glass.width, 1)
	glass:setPosition(47, 6)
	queen.glass = glass
	queen:addChild(glass)

	local acid1 = Sprite("wine_b")
	acid1.cutout_top = 65 --48
	glass:addChild(acid1)
	local acid2 = Sprite("wine_t")
	acid2.cutout_top = 50 --13
	glass:addChild(acid2)

	cutscene:wait(0.5)

	Assets.playSound("queen_wine_appear")
	Game.battle.timer:tween(0.5, glass, {x=148, y=137, scale_x=0.45/2, scale_y=0.45/2, color={1,0,0}})
	local afimGlass = Game.battle.timer:everyInstant(1/16, function()
        Game.battle:addChild(AfterImage(glass, 1))
    end)

	cutscene:wait(0.5)
	Game.battle.timer:cancel(afimGlass)
	glass:setLayer(BATTLE_LAYERS["above_bullets"])
	Game.battle.timer:tween(0.55, Game.battle, {background_fade_alpha=0.75})

	local count = 0

	local bullets = {}
	local bulletCreation = Game.battle.timer:everyInstant(Utils.random(1/2, 1/4), function()
		local bullet = Sprite("droplet")
		bullet:setLayer(BATTLE_LAYERS["bullets"])
		bullet:setPosition(Utils.random(198, 423), -10)
		bullet:setHitbox(0, 0, bullet.width, bullet.height)
		bullet.speed = Utils.random(4, 6)
		Game.battle:addChild(bullet)
		table.insert(bullets, bullet)
	end)
	local tempUpdate = Game.battle.timer:during(math.huge, function()
		print(count)
		local speed = 4
		if Input.down("cancel") then
			speed = speed*2
		end

		if Input.down("left") then
			glass.x = glass.x-speed*DTMULT
		elseif Input.down("right") then
			glass.x = glass.x+speed*DTMULT
		end
		glass.x=Utils.clamp(glass.x, 96, 200)

		local function mapValue(input, inMin, inMax, outMin, outMax)
	  		local inputRange = inMax - inMin
	  		local outputRange = outMax - outMin
	  		local scaledValue = (input - inMin) / inputRange
	  		return outMin + scaledValue * outputRange
		end

		for i,v in ipairs(bullets) do
			v.y = v.y+v.speed*DTMULT

			if count == 6 and acid1.cutout_top>0 then
				acid1.cutout_top = 0
			end
			if acid1.cutout_top == 0 then
				acid2.cutout_top = mapValue(count, 7, 18, 50, 13)
			end

			if v:collidesWith(glass) then
				v:remove()
				table.remove(bullets, i)
				Assets.stopAndPlaySound("swallow")
				count = count+1
			end

			local x, y = v:getScreenPos()
			if y>SCREEN_HEIGHT+20 then
				v:remove()
				table.remove(bullets, i)
			end
		end
	end)

	cutscene:wait(Utils.random(5, 10))

	Game.battle.timer:cancel(bulletCreation)
	Game.battle.timer:cancel(tempUpdate)
	for i,v in ipairs(bullets) do
		v:remove()
	end
	bullets = nil

	Game.battle.timer:tween(0.5, glass, {x=47, y=10, scale_x=0.2, scale_y=0.3, color={1,1,1}})
	Game.battle.timer:tween(0.5, acid1, {color={0,1,0}})
	Game.battle.timer:tween(0.5, acid2, {color={0,1,0}})
	cutscene:wait(0.5)
	glass:setLayer(queen.layer-1)
	Game.battle.timer:tween(0.55, Game.battle, {background_fade_alpha=0})
	local level = count/3
	local shield_size
	print("final count = "..level)
	if level>=6 then
		shield_size = 12
	elseif level>=4 then
		shield_size = 10
	elseif level>=2 then
		shield_size = 7
	else
		shield_size = 0
	end
	print("shield level = "..shield_size)

	if shield_size==0 then
		cutscene:wait(0.5)
		Assets.playSound(Utils.pick({"queen/hoot", "queen/hoot_2", "queen/hoot_3"}))
		local retro_explosion = RetroExplosion(70, 70)
		Game.battle:addChild(retro_explosion)

		local queen = Game.battle.encounter.queen
		queen.glass:remove()
		queen:setAnimation({"hurt", 1/14, true})
		queen.physics.speed_x = -30
		queen.physics.gravity = 1.5
		queen.physics.gravity_direction = 0
		queen.shield_broken = true
		queen.shield = nil
		cutscene:wait(function()
			return not queen.shield_broken
		end)
		cutscene:endCutscene()
	else
		local shield = AcidShield(shield_size, queen)
		queen:addChild(shield)
		shield.appearcon = 1
		queen.air_mouv = true
		queen.shield = shield
		cutscene:wait(function()
			return not shield:isInTransition()
		end)
		cutscene:endCutscene()
	end
end