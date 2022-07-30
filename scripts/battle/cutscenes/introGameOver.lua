return function(cutscene)
    cutscene:after(function()
        Game.battle:setState("ACTIONSELECT")
    end)

    cutsceneMusic:stop()
    Game.battle.party[1].sprite.frozen=true
    Game.battle.party[1].sprite.freeze_progress=1
    Game.battle.party[1].sprite:setSprite("battle/hurt")
    Game.battle.party[1].sprite:play()
    local font = Assets.getFont("main")

    local hider=Rectangle(-20, 0, SCREEN_WIDTH+40, SCREEN_HEIGHT)
    hider:setColor(0, 0, 0)
    hider:setLayer(100000)
    Game.battle:addChild(hider)
    cutscene:wait(2)
    cutsceneMusic:play("AUDIO_DEFEAT")
    local logo = Sprite("ui/gameover", 0, 40) --why is it called text in the gameover file?
    logo:setScale(2)
    logo.alpha=0
    logo:setLayer(100010)
    Game.battle:addChild(logo)
    Game.battle.timer:tween(0.9, logo, {alpha=1})
    cutscene:wait(1)
    local dialogue = DialogueText({
        "[voice:susie]It's so cold...",
        "[voice:susie]What... happened...?",
        "[voice:susie]Oh right... I was talking\nto Noelle...",
        "[voice:susie]Did she kill me?",
        "[voice:susie]When did she became so\npowerful...?",
        "[voice:susie]...[wait:2]Man,\n[wait:1]this is so wrong.",
        "[voice:susie]But what can I do about\nit?",
        "[voice:susie]It's not like I can do\nanything now."
    }, 100, 302, {style = "none"})
    dialogue:setLayer(100010)
    Game.battle:addChild(dialogue)
    cutscene:wait(function()
        return dialogue.done
    end)
    dialogue.alpha=0
    local CONTINUE=Text("CONTINUE", 160, 360, nil, nil, nil, "menu")
    CONTINUE.alpha=0
    CONTINUE:setLayer(100010)
    local GIVEUP=Text("GIVE UP", 380, 360, nil, nil, nil, "menu")
    GIVEUP.alpha=0
    GIVEUP:setLayer(100010)
    local heart=Sprite("player/heart_blur")
    heart:setColor(Game:getSoulColor())
    heart.alpha=0
    heart:setScale(2)
    heart:setLayer(100005)
    Game.battle:addChild(heart)
    Game.battle:addChild(CONTINUE)
    Game.battle:addChild(GIVEUP)
    Game.battle.timer:tween(0.3, CONTINUE, {alpha=1})
    Game.battle.timer:tween(0.3, GIVEUP, {alpha=1})
    cutscene:wait(0.4)
    Game.battle.timer:tween(0.3, heart, {alpha=0.6})
    local selected, choose=1, false
    local ideal_x = 80 + (font:getWidth("CONTINUE") / 4 - 10)
    local ideal_y = 180
    local heart_x = ideal_x
    local heart_y = ideal_y
    cutscene:during(function()
        if not choose and not wait then
            if Input.pressed("left") then selected = 1 end
            if Input.pressed("right") then selected = 2 end
            if selected == 1 then
                ideal_x = 80   + (font:getWidth("CONTINUE") / 4 - 10)
                ideal_y = 180
                CONTINUE:setColor(1, 1, 0)
                GIVEUP:setColor(1, 1, 1)
            else
                ideal_x = 190  + (font:getWidth("GIVE UP") / 4 - 10)
                ideal_y = 180
                CONTINUE:setColor(1, 1, 1)
                GIVEUP:setColor(1, 1, 0)
            end

            if Input.pressed("confirm") then
                choose = true
            end

            if (math.abs(heart_x - ideal_x) <= 2) then
                heart_x = ideal_x
            end
            if (math.abs(heart_y - ideal_y) <= 2) then
                heart_y = ideal_y
            end

            local HEARTDIFF = ((ideal_x - heart_x) * 0.3)
            heart_x = heart_x + (HEARTDIFF * DTMULT)

            HEARTDIFF = ((ideal_y - heart_y) * 0.3)
            heart_y = heart_y + (HEARTDIFF * DTMULT)
            heart.x, heart.y=heart_x*2, heart_y*2
        else
            local newPitch=cutsceneMusic.pitch-0.01*DTMULT
            if newPitch>=0 then
                cutsceneMusic.pitch=newPitch
            else
                if cutsceneMusic:isPlaying() then
                    cutsceneMusic:pause()
                end
            end
        end
    end)
    Game.battle.timer:tween(0.3, heart, {alpha=0.6})
    local wait=false
    waitUntilSusieWakeUp=Game.battle.timer:after(10, function() --pretty long name.
        wait=true
    end)
    cutscene:wait(function()
        return choose or wait
    end)
    if not wait then
        Game.battle.timer:cancel(waitUntilSusieWakeUp)
    else
        choose=true
    end
    dialogue.alpha=1
    dialogue:setText({
        "[voice:susie]NO!",
        "[voice:susie]No way I'm letting this\nhappening!",
        "[voice:susie]I ain't giving up now!"
    })
    Game.battle.timer:tween(2, CONTINUE, {alpha=0}, "linear", function() CONTINUE:remove() end)
    Game.battle.timer:tween(2, GIVEUP, {alpha=0}, "linear", function() GIVEUP:remove() end)
    cutscene:wait(function()
        return dialogue.done
    end)
    local susie=Sprite("party/susie/battle/defeatOutlines")
    susie:setPosition(Game.battle.party[1]:getPosition())
    susie:setLayer(100004)
    susie.alpha=0
    Game.battle:addChild(susie)
    Game.battle.timer:tween(2, susie, {alpha=0.6})
    local susie_soul=Sprite("party/susie/battle/defeatOutlines")
    susie_soul:setPosition(Game.battle:getSoulLocation())
    susie:setLayer(100005)
    susie.alpha=0
    Game.battle:addChild(susie_soul)
    dialogue:setText({
        "[voice:susie]Something wrong is going\non and I won't let it\ncontinue!",
        "[voice:susie]Come on!\nBreak, damn prison!",
        "[voice:susie]I have to CONTINUE!"
    })
    cutscene:wait(function()
        return dialogue.done
    end)
    Game.battle.timer:tween(2, dialogue, {alpha=0}, "linear", function() dialogue:remove() end)
    cutscene:wait(2.5)
    Assets.playSound("transform1")
    Game.battle.timer:tween(1, heart, {scale_x=1, scale_y=1, x=susie.x, y=susie.y})
    Game.battle.timer:tween(0.7, susie_soul, {alpha=1})
    afterImageTimer=Game.battle.timer:everyInstant(0.1, function()
        local heartAI=AfterImage(heart, 0.4)
        Game.battle:addChild(heartAI)
    end)
    cutscene:wait(1)
    cutscene:fadeOut(0, {color={1, 1, 1}})
    Game.battle.timer:cancel(afterImageTimer)
    Assets.playSound("transform2")
    cutscene:wait(3)
    logo:remove()
    hider:remove()
    susie:remove()
    susie_soul:remove()
    heart:remove()
    cutscene:fadeIn(0.5, {color={1, 1, 1}})
    cutscene:wait(0.75)
    cutscene:text("* [speed:0.6]It was easy...", "sad", "noelle")
    cutscene:text("* [speed:0.6]Like everyone else...", "sad_side", "noelle")
    local noelle=cutscene:getCharacter("noelle")
    cutscene:setAnimation(noelle, {"walk/left", 1/4, true})
    cutscene:wait(cutscene:slideTo(noelle, noelle.x+20, noelle.y))

    cutscene:setSprite(noelle, "walk/right")
    noelle.alert_icon = Sprite("effects/alert", noelle.sprite.width/2)
    noelle.alert_icon:setOrigin(0.5, 1)
    noelle.alert_icon.layer = 100
    noelle:addChild(noelle.alert_icon)
    noelle:setAnimation("cutscene_shock")
    Game.battle.timer:after(0.8, function()
        noelle.alert_icon:remove()
    end)
    Assets.playSound("boost")
    Game.battle.party[1]:flash()
    local bx, by = Game.battle:getSoulLocation()
    local soul = Sprite("effects/susiesoulshine", bx-15, by-15)
    soul:play(1/15, false, function() soul:remove() end)
    soul:setOrigin(0.25, 0.25)
    soul:setScale(2, 2)
    Game.battle:addChild(soul)
    cutscene:wait(1/4)
    cutscene:text("* Your power shines into Susie!")
    cutscene:text("* Wh-[wait:1]What was...?", "shock", "noelle")
    cutscene:setSprite(noelle, "shocked")
    Assets.playSound("laz_c")
    local hider=Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    hider:setColor(1, 1, 1, 0)
    hider:setLayer(100000)
    Game.battle:addChild(hider)
    Game.battle.timer:tween(0.6, hider, {alpha=1})
    cutscene:wait(1.2)
    Game.battle.party[1].chara.stats["health"]=190*2
    Game.battle.party[1].chara.stats["attack"]=18*2
    Game.battle.party[1].chara.stats["defense"]=2*2
    Game.battle.party[1].chara.stats["magic"]=3*2
    Game.battle.party[1]:heal(999)
    Game.battle.party[1].sprite.frozen=false
    Game.battle.party[1].sprite.freeze_progress=0
    Game.battle.party[1]:resetSprite()
    cutscene:wait(0.75)
    local dialogue = DialogueText({
        "Susie's strength has greatly\nincreased!",
        "She can now cast TENSION ABSORB!"
    }, 70, (SCREEN_HEIGHT/2)-30, {style = "none", color=COLORS["black"]})
    dialogue:setLayer(100010)
    Game.battle:addChild(dialogue)
    cutscene:wait(function()
        return dialogue.done
    end)
    dialogue:remove()
    noelle.x=noelle.x-20
    Game.battle.timer:tween(0.6, hider, {alpha=0}, "linear", function() hider:remove() end)
    cutscene:wait(1.5)
    cutscene:text("* Heh.[wait:1] Didja really thought a little cold could beat me?", "closed_grin", "susie")
    cutscene:text("* Nobody will freeze me to death anytime soon!", "teeth_smile", "susie")
    cutscene:text("* ...", "blush_surprise", "noelle")
    cutscene:setAnimation(noelle, {"battle/idle", 0.2, true})
    cutscene:text("* I-[wait:1]I...[wait:1] I don't...", "afraid", "noelle")
    cutscene:text("* [speed:0.6]I do-[wait:1]don't...[wait:4]\n\nknow...", "down", "noelle")
    local wait, text=cutscene:text("[speed:0.5]* .......................\n.......................\n.......................", "trance", "noelle", {skip=false, wait=false})
    local eyeL=Rectangle(58, 440, 2, 6)
    local eyeR=Rectangle(74, 440, 2, 6)
    eyeL:setColor(0, 0, 0)
    eyeL:setLayer(100000)
    eyeR:setColor(0, 0, 0)
    eyeR:setLayer(100000)
    Game.battle:addChild(eyeL)
    Game.battle:addChild(eyeR)
    cutscene:wait(1)
    Game.battle.timer:tween(3, eyeL, {alpha=0}, "linear", function() eyeL:remove() end)
    Game.battle.timer:tween(3, eyeR, {alpha=0}, "linear", function()
        eyeR:remove()
        Game.battle.music:play("SnowGrave")
        cutscene:setAnimation(noelle, {"battle/trancesition", 0.2, false, next="battle/idleTrance"})
        noelle.x=noelle.x+6
    end)
    cutscene:wait(wait)
    Game.battle.enemies[1].mercy=0
    cutsceneMusic:remove()
    cutscene:text("* ...!", "shock", "susie")
    cutscene:text("* (I must go easy on her...[wait:1] She's anything but fine.)", "shy_down", "susie")
    cutscene:text("* (I just have to be careful of her [color:yellow]SPELLS[color:reset]...)", "nervous", "susie")
    noelle:setAnimation("battle/idleTrance")
    Game.battle.noelle_tension_bar:show()
    Game:setFlag("plot", 2)
    cutscene:endCutscene()
end