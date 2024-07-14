return function(cutscene)
	local first=Game.battle.enemies[1].wake_first

	local function createForcePull(b, e)
		local data = {}
		data["value"]=0.5
		data["decrease"]=(0.085-Game.battle.enemies[1].mercy/100)-Utils.random(-1/2, 1/2)/10
		if data["decrease"]>0.085 then data["decrease"]=0.085 end
		if data["decrease"]<=0 then
			if Game.battle.enemies[1].mercy<90 then
				data["decrease"]=0.03
			else
				data["decrease"]=Utils.clamp(data["decrease"], -0.030, 0)
			end
		end
		--(1.09)
		print(data["decrease"])
		data["timer"]=Utils.random(120, 240)

		data["bg"]=Rectangle(93, 90, 430+15, 15)
		data["bg"].color={0, 0, 0}
		data["bg"].layer=BATTLE_LAYERS["top"]+10
		data["bg"].alpha=0
		Game.battle.timer:tween(0.5, data["bg"], {alpha=1})
		Game.battle:addChild(data["bg"])
		data["barPlayer"]=Rectangle(93, 90, (430*data["value"])+15, 15)
		data["barPlayer"].color={1, 0, 1}
		data["barPlayer"].layer=BATTLE_LAYERS["top"]+13
		data["barPlayer"].alpha=0
		Game.battle.timer:tween(0.5, data["barPlayer"], {alpha=1})
		Game.battle:addChild(data["barPlayer"])
		data["barEnemy"]=Rectangle(553, 90, (430*data["value"])+15, 15)
		data["barEnemy"]:setOrigin(1, 0)
		data["barEnemy"].color={1, 1, 0}
		data["barEnemy"].layer=BATTLE_LAYERS["top"]+12
		data["barEnemy"].alpha=0
		Game.battle.timer:tween(0.5, data["barEnemy"], {alpha=1})
		Game.battle:addChild(data["barEnemy"])

		data["text"]=Text("Press "..Input.getText("confirm").." repeatedly!", 205, 40, {style = "none"})
		data["text"].layer=BATTLE_LAYERS["top"]+14
		Game.battle:addChild(data["text"])

		if Game:getFlag("altPull") then
			data["keys"] = {"confirm", "left", "right", "up", "down", "menu", "cancel"}
			--data["decrease"] = data["decrease"] - 0.045+Game.battle.enemies[1].mercy/1000
			print("Look at dis:")
			print(data["decrease"], data["decrease"] - 0.045+Game.battle.enemies[1].mercy/1000)
			--[[if data["decrease"]<=0 then
				if Game.battle.enemies[1].mercy<90 then
					data["decrease"]=0.03
				else
					data["decrease"]=Utils.clamp(data["decrease"], -0.030, 0)
				end
			end]]
			data["choosen_key"] = Utils.pick(data["keys"])
			data["text"]:setText("Press "..Input.getText(data["choosen_key"]).."!")

			data["key_timer"] = 0
			data["key_timer_rect"] = Rectangle(93, 90, (430+15)*(1-data["key_timer"]/100), 7.5)
			data["key_timer_rect"]:setOrigin(0, 1)
			data["key_timer_rect"].layer=BATTLE_LAYERS["top"]+14
			data["key_timer_rect"].alpha=0
			Game.battle.timer:tween(0.5, data["key_timer_rect"], {alpha=1})
			Game.battle:addChild(data["key_timer_rect"])
		end

		return data
	end

	if Game:getFlag("possiblyNeedHelp", 0) >= 3 and Game:getFlag("altPull", nil) == nil then
		local function gonerText(str, wait)
            local text = DialogueText("[speed:0.3][spacing:6][style:GONER][voice:none]" .. str, 80 * 2, 50 * 2, 640, 480, {auto_size = true})
            text.layer = WORLD_LAYERS["top"] + 100
            text.skip_speed = true
            text.parallax_x = 0
            text.parallax_y = 0
            Game.stage:addChild(text)

            if wait == true or wait == nil then
	            cutscene:wait(function() return text.done end)
	            Game.battle.timer:tween(1, text, {alpha = 0})
	            cutscene:wait(1)
	            text:remove()
	        else
	        	return text
	        end
        end

		local hider = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
		hider.alpha = 0
		hider.color = {0, 0, 0}
		Game.stage:addChild(hider)
		Game.battle.timer:tween(2, hider, {alpha=0.5})
		cutscene:wait(2.5)

		gonerText("IT SEEMS[wait:5] YOU HAVE[wait:5]\nSOME DIFFICULTIES.")
		gonerText("PERHAPS YOU ARE\nUNABLE TO PRESS\nTHE KEY FAST\nENOUGH TO\nKEEP UP?")
		gonerText("THAT IS UNFORTUNATE.")
		gonerText("WOULD YOU LIKE\nTO USE AN\nALTERNATIVE\nGAMEPLAY?")
		gonerText("YOU'LL HAVE MORE\nTIME TO PRESS\nA KEY BUT MORE\nKEYS TO PRESS.")
		local text = gonerText("DO YOU AGREE?", false)
		local chosen = nil
        local choicer = GonerChoice(220, 360, {
            { { "YES", 0, 0 }, { "<<" }, { ">>" }, { "NO", 160, 0 } }
        }, function (choice)
            chosen = choice
        end)
        choicer:setSelectedOption(2, 1)
        choicer:setSoulPosition(80, 0)
        Game.stage:addChild(choicer)

        cutscene:wait(function () return chosen ~= nil end)
        Game.world.timer:tween(1, text, {alpha = 0})
	    cutscene:wait(1)
	    text:remove()

	    cutscene:wait(1)

	    if chosen == "YES" then
	    	Game:setFlag("altPull", true)
	    	gonerText("IT IS DONE.")
	    else
	    	Game:setFlag("altPull", false)
	    	gonerText("UNDERSTOOD.")
	    end
	    Kristal.Config["altPull"] = Game:getFlag("altPull")
	    Kristal:saveConfig()
	    gonerText("GOOD LUCK.")

	    Game.battle.timer:tween(1, hider, {alpha=0})
		cutscene:wait(1.5)
		hider:remove()
	end

	local susie=cutscene:getCharacter("susie")
	local noelle=cutscene:getCharacter("noelle")
	if first then
		cutscene:text("* \"Wake up\"...", "neutral", "susie")
	    cutscene:text("* The hell am I supposed to do with that?", "nervous_side", "susie")
	    cutscene:choicer({"Say something\nromantic", "Cast PACIFY"})
	    cutscene:text("* Hold on!", "surprise_frown", "susie")
	    cutscene:text("* That weird ring on her finger...", "surprise", "susie")
	    cutscene:text("* It...[wait:1] looks like a torture device...", "nervous_side", "susie")
	    cutscene:text("* Maybe removing it is a good start?", "neutral_side", "susie")
	    cutscene:text("* Yeah,[wait:1] I'll do that!", "smile", "susie")
	end
    local forcePull = createForcePull(susie, noelle)
    local map={Game.world.map:getImageLayer("room"), Game.world.map:getImageLayer("moon"), Game.world.map:getImageLayer("ferris_wheel")}
    for _,layer in ipairs(map) do
        Game.battle.timer:tween(0.5, layer, {x=layer.x-50}, "out-cubic")
    end
    local orig_susie, orig_noelle=susie.x, noelle.x
    cutscene:slideTo(susie, 305, susie.y, 0.3, "out-cubic")
    cutscene:slideTo(noelle, 346, noelle.y, 0.3, "out-cubic")
    cutscene:wait(0.5)
    Assets.playSound("noise")
    cutscene:wait(0.25)
    if first then
    	cutscene:text("* Wh-Wha-", "trance-surprise", "noelle")
    	cutscene:text("* Merry Christmas!!!", "teeth", "susie")
    else
    	cutscene:wait(0.5)
    end
    local firsttime=true
    local spam_counter = 1
    cutscene:wait(function()
    	--print(forcePull["value"])
    	if not firsttime then
    		forcePull["timer"]=forcePull["timer"]-DTMULT

    		if not Game:getFlag("altPull") then
	    		forcePull["value"]=forcePull["value"]-forcePull["decrease"]*DTMULT
	    	else
	    		print(forcePull["key_timer"], 1-forcePull["key_timer"]/(25+Game.battle.enemies[1].mercy), spam_counter)
	    		forcePull["key_timer"] = forcePull["key_timer"] + DTMULT
	    		forcePull["key_timer_rect"].width = 430*(1-forcePull["key_timer"]/(25+Game.battle.enemies[1].mercy))+15

	    		if forcePull["key_timer"] >= 25+Game.battle.enemies[1].mercy then
	    			Assets.stopAndPlaySound("damage")
	    			forcePull["choosen_key"] = Utils.pick(forcePull["keys"])
    				forcePull["text"]:setText("Press "..Input.getText(forcePull["choosen_key"]).."!")
	    			forcePull["key_timer"] = 0
	    			forcePull["value"]=forcePull["value"]-forcePull["decrease"]*DTMULT*2
	    		end
	    	end
	    	if forcePull["value"]<0 then
    			forcePull["value"]=0
    		elseif forcePull["value"]>1 then
    			forcePull["value"]=1
    		end
    		forcePull["barPlayer"].width=(430*forcePull["value"])
    		forcePull["barEnemy"].width=430-forcePull["barPlayer"].width
    	else
    		if Input.pressed(forcePull["choosen_key"] or "confirm") then
    			firsttime=false
    			if not Game:getFlag("altPull") then
    				forcePull["text"]:remove()
    			end
    		end
    	end

    	local time_succ = nil
    	local spam = 0
    	if Game:getFlag("altPull") then
	    	for i,key in ipairs(forcePull["keys"]) do
	    		if Input.pressed(key) then
	    			if key == forcePull["choosen_key"] then
	    				time_succ = true
	    			else
	    				time_succ = false
	    			end
	    			spam = spam + 1 -- spamming, in my Frozen Heart game?
	    		end
	    	end
	    end

    	if (not Game:getFlag("altPull") and Input.pressed("confirm")) or (Game:getFlag("altPull") and time_succ == true) then
    		Assets.stopAndPlaySound("noise")
    		if spam > 1 then
    			spam_counter = spam_counter + 1
    		end
    		local value=0.25+math.random()/(Game:getFlag("altPull") and 20 or 10)
    		print("Forced! Added "..value.." to the bar's value: "..forcePull["value"].."!")
    		forcePull["value"]=forcePull["value"]+value
    		if Game:getFlag("altPull") then
    			forcePull["choosen_key"] = Utils.pick(forcePull["keys"])
    			forcePull["text"]:setText("Press "..Input.getText(forcePull["choosen_key"]).."!")
    			forcePull["key_timer"] = 0
    		end
    	end
    	if Game:getFlag("altPull") and time_succ == false then
    		Assets.stopAndPlaySound("damage")
			forcePull["choosen_key"] = Utils.pick(forcePull["keys"])
			forcePull["text"]:setText("Press "..Input.getText(forcePull["choosen_key"]).."!")
			forcePull["key_timer"] = 0
			forcePull["value"]=forcePull["value"]-forcePull["decrease"]*DTMULT*2
		end

    	if forcePull["timer"]<=0 then
    		return true
    	end
    	return false
    end)
    if Game:getFlag("altPull") then
		forcePull["text"]:remove()
		Game.battle.timer:tween(0.5, forcePull["key_timer_rect"], {alpha=0}, "linear", function() forcePull["key_timer_rect"]:remove() end)
	end
    forcePull["barPlayer"].width=(430*forcePull["value"])
    forcePull["barEnemy"].width=430-forcePull["barPlayer"].width
    Game.battle.timer:tween(0.5, forcePull["bg"], {alpha=0}, "linear", function() forcePull["bg"]:remove() end)
	Game.battle.timer:tween(0.5, forcePull["barPlayer"], {alpha=0}, "linear", function() forcePull["barPlayer"]:remove() end)
	Game.battle.timer:tween(0.5, forcePull["barEnemy"], {alpha=0}, "linear", function() forcePull["barEnemy"]:remove() end)
    cutscene:slideTo(susie, orig_susie, susie.y, 0.3, "out-cubic")
    cutscene:slideTo(noelle, orig_noelle, noelle.y, 0.3, "out-cubic")
    for _,layer in ipairs(map) do
        Game.battle.timer:tween(0.5, layer, {x=layer.x+50}, "out-cubic")
    end
    cutscene:wait(0.5)
    if forcePull["value"]>0 then
    	if not Game:getFlag("altPull") then
    		Game.battle.enemies[1]:addMercy(Utils.round((10*forcePull["value"])/spam_counter))
    	else
    		if spam_counter > forcePull["value"]*10 then spam_counter = forcePull["value"]*10 end
    		Game.battle.enemies[1]:addMercy(Utils.round((7*forcePull["value"])/spam_counter))
    	end
    	if forcePull["value"]<=0.55 then
    		Game:addFlag("possiblyNeedHelp", 1)
    	end
    else
    	Game.battle.enemies[1]:addMercy(0)
    end
    if Game.battle.enemies[1].mercy<100 then
    	cutscene:wait(1)
    	Assets.playSound("hurt")
    	Game.battle.enemies[1]:hurt(Utils.round(10*(forcePull["value"]+Utils.random())), nil, function()
    		Game.battle.enemies[1]:onDefeatThorn()
    		Game.battle:setState("NONE")
       		cutscene:endCutscene()
    	end)
    	cutscene:text("* Noelle got hurt by the Thorn Ring!")
    	if first then
    		cutscene:text("* Oh great, I also have to be careful of that.", "annoyed", "susie")
    		cutscene:text("* Maybe I can use my spell to heal her?", "neutral_side", "susie")
    		cutscene:text("* Who said I couldn't heal an enemy,[wait:0.5] after all?", "closed_grin", "susie")
    	end
    	Game.battle:finishActionBy(Game.battle.party[1])
    else
    	Assets.playSound("noise")
    	Assets.playSound("snd_ominous_cancel")
    	cutscene:wait(1)
    	Game.battle.timer:tween(2, Game.battle.music, {volume=0})
    	cutscene:wait(2.5)
    	cutscene:text("* Susie got the ThornRing!")
    	Game:setFlag("noelle_battle_status", "no_trance")
    	cutscene:after(function() Game.battle:returnToWorld() end)

    	Game.battle:setState("TRANSITIONOUT")
    	cutscene:wait(1)
    	Game.battle:finishActionBy(Game.battle.party[1])
    end
end