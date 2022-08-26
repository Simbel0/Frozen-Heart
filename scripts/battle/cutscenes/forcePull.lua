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

		data["text"]=Text("Press "..Input.getText("confirm").." repeatly!", 205, 40, {style = "none"})
		data["text"].layer=BATTLE_LAYERS["top"]+14
		Game.battle:addChild(data["text"])

		return data
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
    cutscene:wait(function()
    	print(forcePull["value"])
    	if not firsttime then
    		forcePull["timer"]=forcePull["timer"]-DTMULT

    		forcePull["value"]=forcePull["value"]-forcePull["decrease"]*DTMULT
    		if forcePull["value"]<0 then
    			forcePull["value"]=0
    		elseif forcePull["value"]>1 then
    			forcePull["value"]=1
    		end
    		forcePull["barPlayer"].width=(430*forcePull["value"])
    		forcePull["barEnemy"].width=430-forcePull["barPlayer"].width
    	else
    		if Input.pressed("confirm") then
    			firsttime=false
    			forcePull["text"]:remove()
    		end
    	end

    	if Input.pressed("confirm") then
    		Assets.stopAndPlaySound("noise")
    		local value=0.25+math.random()/10
    		print("Forced! Added "..value.." to the bar's value: "..forcePull["value"].."!")
    		forcePull["value"]=forcePull["value"]+value
    	end

    	if forcePull["timer"]<=0 then
    		return true
    	end
    	return false
    end)
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
    	Game.battle.enemies[1]:addMercy(Utils.round(10*forcePull["value"]))
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