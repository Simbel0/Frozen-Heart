return function(cutscene, user, target)
	if target.first_shield then
		target.first_shield = false
		cutscene:text("* Make A shield?", "surprise", "queen")
		cutscene:text("* Kris I Like Your Way Of Thinking.", "smirk", "queen")
	else
		cutscene:wait(0.5)
	end
	local queen = Game.battle.encounter.queen
	queen:setAnimation({"act", 1/8, true})
	queen.air_mouv = false
	local glass = Sprite("wine_glass")
	glass:setScale(0.25)
	glass:setOrigin(0.5, 0.5)
	glass.layer = queen.layer-1
	glass:setHitbox(0, 30, glass.width, 1)
	glass:setPosition(queen.x+78, queen.y-((queen.height*2)-20))
	Game.battle:addChild(glass)

	cutscene:wait(0.5)

	Game.battle.timer:tween(0.5, glass, {x=320, y=300, scale_x=0.45, scale_y=0.45, color={1,0,0}})
	cutscene:wait(0.5)
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
			glass.x = glass.x-speed
		elseif Input.down("right") then
			glass.x = glass.x+speed
		end
		glass.x=Utils.clamp(glass.x, 216, 423)
		glass.collider:drawFor(self, 1, 0, 0)

		for i,v in ipairs(bullets) do
			v.collider:drawFor(self, 0, 1, 0)
			v.y = v.y+v.speed

			if v:collidesWith(glass) then
				v:remove()
				table.remove(bullets, i)
				count = count+1
			end

			if v.y>SCREEN_HEIGHT+20 then
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

	Game.battle.timer:tween(0.5, glass, {x=queen.x+78, y=queen.y-((queen.height*2)-20), scale_x=0.25, scale_y=0.25, color={1,1,1}})
	cutscene:wait(0.5)
	glass:setLayer(queen.layer-1)
	Game.battle.timer:tween(0.55, Game.battle, {background_fade_alpha=0})
	local level = count/3
	print("final count = "..level)
	if level>=6 then
		shield_size = 12
	elseif level>=3 then
		shield_size = 10
	elseif level>=1 then
		shield_size = 7
	else
		shield_size = 0
	end
	print("shield level = "..level)

	if shield_size==0 then
		--TODO
	else
		local shield = AcidShield(shield_size)
		queen:addChild(shield)
		queen.air_mouv = true
		cutscene:wait(function()
			return shield:isInTransition()
		end)
		cutscene:endCutscene()
	end
end