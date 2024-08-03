return function(cutscene, event)
	local wobbly = Game.world.map.wobbly

	Game.world.music:fade(0, 1, function() Game.world.music:pause() end)
	cutscene:text("* (Holy shit, is that..?)")
	cutscene:wait(cutscene:panTo(1745, 315))
	cutscene:wait(1)

	wobbly:wobble()

	local currPitch = 1.0
	local musiclol = Music("battle", 1, currPitch)
	Game.world.camera:setZoom(2)
	Game.world.camera:setPosition(1745, 285)

	local text = Game.world:spawnObject(Text("[shake:1]OH MY GOD IT4S THE", 0, 0, {style="menu"}))
	text:setScale(1.5)
	local bottom_text = Game.world:spawnObject(Text("[shake:1]THE WOBBLY THING", 0, 0, {style="menu"}))
	bottom_text:setScale(1.5)

	local function coolText(newtext, newbottom_text, fade_time)
		if not Kristal.Config["simplifyVFX"] then
			Game.fader.alpha = 1
		end
		currPitch = currPitch + 0.1
		print(wobbly.sprite.anim_delay)
		wobbly.sprite.anim_delay = wobbly.sprite.anim_delay - (1/30)
		if wobbly.sprite.anim_delay <= 0 then
			wobbly.sprite.anim_delay = 0.0001
		end
		musiclol:setPitch(currPitch)
		text:setText(localize("wobblything_text1")..newtext)
		bottom_text:setText(localize("wobblything_text2")..newbottom_text)
		text:setScreenPos((SCREEN_WIDTH/2)-text:getTextWidth()*1.5, 0)
		bottom_text:setScreenPos((SCREEN_WIDTH/2)-bottom_text:getTextWidth()*1.5, (SCREEN_HEIGHT/1.5)+60)
		if not Kristal.Config["simplifyVFX"] then
			cutscene:fadeIn(fade_time or 3, {global=true, color={1, 1, 1}})
		end
	end
	coolText("OH MY GOD IT4S THE", "THE WOBBLY THING")
	Game.fader.alpha = 1
	cutscene:fadeIn(3, {global=true, color={1, 1, 1}})
	wobbly.sprite.anim_delay = wobbly.sprite.anim_delay + (1/30)
	cutscene:wait(5)
	coolText("FINALLY A GOOD THING", "IN THIS FANGAME")
	cutscene:wait(4)
	coolText("THAT'S SO FUCKING COOL", "JUST LOOK AT IT", 2)
	cutscene:wait(3)
	coolText("MAN I LOVE IT SO MUCH", "HOLY SHIT", 1)
	cutscene:wait(2)
	coolText("BETTER THAN SANS", "FR FR", 0.5)
	cutscene:wait(1)
	coolText("DON'T YOU WANNA", "KISS IT BRO??", 0.5)
	cutscene:wait(0.9)
	coolText("COULD NO-HIT NOELLE", "IN ONE TRY", 0.5)
	cutscene:wait(0.8)
	coolText("I'M GOING MAD", "PLEASE SEND HELP", 0.5)
	cutscene:wait(0.7)
	coolText("BOTTOM TEXT", "NO WAIT", 0.5)
	cutscene:wait(0.6)
	coolText("HOW'S YOUR DAY?", "MINE'S FINE", 0.5)
	cutscene:wait(0.5)
	coolText("LOOK IN THE", "EXAMPLE MOD", 0.5)
	cutscene:wait(0.4)
	coolText("WHEN ALL CLEAR", "DEBUG IS HERE", 0.5)
	cutscene:wait(0.4)
	coolText("SPAMTON PUTS ON", "A BIKINI PLEASE", 0.5)
	cutscene:wait(0.3)
	coolText("HAPPY BIRTHDAY", "RANDOM PERSON", 0.35)
	cutscene:wait(0.3)
	coolText("NYAKO APPROVED", "I THINK?", 0.35)
	cutscene:wait(0.3)
	coolText("PLAY DARK PLACE", "NOT SPONSORED", 0.25)
	cutscene:wait(0.3)
	coolText("HUG THE WOBBLYTHING", "NOW", 0.25)
	cutscene:wait(0.3)
	coolText("I'M CRAZY BRO", "WHERE ARE THE RATS", 0.25)
	cutscene:wait(0.2)
	coolText("AAAAAAAAAAAAAAAAAAAAA", "AAAAAAAAAAAAAAAAAAAAAAAA", 0.15)
	cutscene:wait(0.2)
	coolText("LOVE YOU WOOBLY THING", "WOW TOP TEXT", 0.15)
	cutscene:wait(0.2)
	coolText("GASTER X WOOBLYTHING", "MY TRUE OTP", 0.15)
	cutscene:wait(0.2)
	coolText("", "", 0)
	text:setText(localize("wobblything_text3"))
	bottom_text:setText(localize("wobblything_text4"))
	text:setScreenPos((SCREEN_WIDTH/2)-text:getTextWidth()*1.5, 0)
	bottom_text:setScreenPos((SCREEN_WIDTH/2)-bottom_text:getTextWidth()*1.5, (SCREEN_HEIGHT/1.5)+60)
	musiclol:setPitch(0.2)
	wobbly.sprite:stop()
	cutscene:wait(5)
	text:setText(localize("wobblything_text5"))
	bottom_text:setText(localize("wobblything_text6"))
	text:setScreenPos((SCREEN_WIDTH/2)-text:getTextWidth()*1.5, 0)
	bottom_text:setScreenPos((SCREEN_WIDTH/2)-bottom_text:getTextWidth()*1.5, (SCREEN_HEIGHT/1.5)+60)
	local exp = wobbly:explode(nil, nil, nil, {play_sound=false})
	Assets.playSound("badexplosion")
	cutscene:wait(0.2)
	Assets.stopSound("badexplosion")
	exp:remove()
	text:remove()
	bottom_text:remove()
	musiclol:remove()
	Game.world.music:resume()
	Game.world.camera:setZoom(1)
	cutscene:attachCameraImmediate()

	if Kristal.hasSaveFile() then
		local data = Kristal.getSaveFile()
		data.flags["wobbly"] = true
		Kristal.saveGame(nil, data)
	end
	Game:setFlag("wobbly", true)
end