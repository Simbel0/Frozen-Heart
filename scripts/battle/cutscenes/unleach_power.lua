return function(cutscene, battler, sneo)
    cutscene:after(function()
        Game.battle:setState("ACTIONSELECT")
        Game.battle.battle_ui.current_encounter_text = "* It's the end!"
        Game.battle.battle_ui.encounter_text:setText(Game.battle.battle_ui.current_encounter_text)
    end, true)

    local kris = cutscene:getCharacter("kris")
    local susie = Game.battle.party[2]
    local ralsei = Game.battle.party[3]

    local hider = Rectangle(-20, 0, SCREEN_WIDTH+40, SCREEN_HEIGHT)
    hider:setColor(0, 0, 0, 1)
    hider:setLayer(BATTLE_LAYERS["top"])
    Game.battle:addChild(hider)
    Assets.playSound("noise")
    local fx = ColorMaskFX({0, 0, 0})
    kris:addFX(fx)
    local og_layer = kris.layer
    kris:setLayer(hider.layer+10)
    Game.battle.music:pause()
    cutscene:wait(1.5)
    cutscene:textSpecial("[voice:none][speed:0.7]* ...")
    cutscene:textSpecial("[voice:none][speed:0.7]* If we really share the same goal...")
    cutscene:wait(1)
    Game.battle.timer:tween(1, fx, {color={1, 1, 1}})
    cutscene:textSpecial("[voice:none][speed:0.7]* ...")
    cutscene:textSpecial("[voice:none][speed:0.7]* Can I trust you?")
    local c = -1
    while c~=1 do
        c=cutscene:choicerSpecial({"Yes", "No"})
    end
    kris:setLayer(og_layer)
    cutscene:wait(1.5)
    cutscene:textSpecial("[voice:none][speed:0.7]* ..[speed:1][wait:4]Thanks.")


    Assets.playSound("break2")
    hider:setColor(1, 1, 1)
    kris:removeFX(fx)
    Game.battle.timer:tween(0.5, hider, {alpha=0})
    cutscene:wait(0.5)
    local queen = sneo.encounter.queen
    local kris_power
    Game.battle.timer:after(7/30, function()
        Assets.playSound("boost", 0.8, 1.2)
        Assets.playSound("boost", 0.8, 0.9)

        Game.battle.timer:tween(0.5, kris, {y=80}, "in-out-cubic")
        kris:setSprite("fall")
        kris.sprite:play(1/10)
        kris.sprite.flip_x = true

        battler:flash()
        local bx, by = Game.battle:getSoulLocation()
        local soul = Sprite("effects/soulshine", bx+5, by+5)
        soul:play(1/15, false, function()
            soul:remove()
            for i,friend in ipairs(Game.battle.party) do
                friend:heal(friend.chara:getStat("health"))
            end
        end)
        soul:setOrigin(0.5, 0.5)
        soul:setScale(2, 2)
        Game.battle:addChild(soul)
        Game.battle.timer:tween(0.5, soul, {y=45}, "in-out-cubic")

        kris_power = Game.battle.timer:every(0.2, function()
            local k = AfterImage(kris.sprite, 1)
            k:setScaleOrigin(0.5, 0.5)
            k.graphics["grow"] = 0.005
            k.color = {1, 0, 0}
            Game.battle:addChild(k)
        end)

        susie:setSprite("shock_behind")
        susie:shake(5)
        Game.battle:removeAction("susie")
        ralsei:setSprite("shocked_behind")
        ralsei:shake(5)
        Game.battle:removeAction("ralsei")

        queen:setAnimation({"chair_shocked", 1/8, true})
        queen:shake(5)
        queen.air_mouv = false

        Game.battle.music:resume()
        Game.battle.music.pitch = 1.1

        --[[local box = sneo.battle_ui.action_boxes[user_index]
        box:setHeadIcon("spell")]]

    end)

    cutscene:text("* Kris unleashes the power of your SOUL!", {skip=false})
    Assets.playSound("noise")
    susie.should_darken = true
    susie.darken_timer = 15
    ralsei.should_darken = true
    ralsei.darken_timer = 15
    queen.darken_fx = queen:addFX(RecolorFX(0.5, 0.5, 0.5))
    queen.sprite:pause()
    Game.battle.background_fade_alpha=0.75
    
    local bx, by = Game.battle:getSoulLocation()
    local soul = SoulCutscene(bx, by)
    local soul_outer = Sprite("player/heart_outline_outer", bx, by)
    soul_outer:setColor(1, 0, 0)
    soul_outer.alpha = 0
    Game.battle:addChild(soul)
    soul:setPosition(bx+soul.width/2, by+soul.height/2)
    Game.battle:addChild(soul_outer)
    cutscene:wait(1)
    Assets.playSound("transform1")
    soul_outer.alpha = 0.5
    Game.battle.timer:tween(1, soul_outer, {alpha=1, x=sneo.x+sneo.width/2, y=sneo.y+25})
    cutscene:wait(1.5)
    Assets.stopAndPlaySound("snd_spearrise", 1, 0.9)
    Game.battle.timer:tween(1, soul, {rotation=math.rad(-90)}, "in-out-back", function()
        Assets.playSound("snd_great_shine", 1, 0.8)
        Assets.playSound("snd_great_shine", 1, 1)
        Assets.playSound("snd_closet_impact", 1, 1.5)
        soul:setColor(1, 1, 0)
        Game.world.timer:everyInstant(0.1, function()
            local image=AfterImage(soul.sprite, 0.5)
            image.graphics.grow=0.3
            Game.battle:addChild(image)
        end, 3)
    end)
    cutscene:wait(1.5)
    Assets.playSound("snd_swing", 1, 0.5)
    Game.battle.timer:tween(0.35, soul, {x=220, y=35}, nil, function() Assets.playSound("impact") end)
    cutscene:wait(0.75)
    local x = (sneo.x+sneo.width/2)-20
    local strings = {}
    local obstacles = {}
    local spawn_timer = 29
    local allow_string_shoot = true
    local health_limit = 1
    local continue_cutscene = false
    local has_fps = Kristal.Config["showFPS"]
    cutscene:during(function()
        if has_fps then
            Kristal.Config["showFPS"] = continue_cutscene
        end

        if kris.sprite.sprite ~= "fall" and kris.sprite.flip_x then
            kris:setSprite("fall")
            kris.sprite:play(1/10)
        end

        if not continue_cutscene then
            soul_outer.x = x+math.cos(Kristal.getTime()*10)*70
            if soul_outer.color[2] > 0 then
                soul_outer.color[2] = soul_outer.color[2] - 0.1*DTMULT
                soul_outer.color[3] = soul_outer.color[3] - 0.1*DTMULT
            end
            if Input.pressed("cancel") and allow_string_shoot then
                soul_outer:setColor(1, 1, 1)
                local x, y = soul_outer:getPosition()
                Game.battle:addChild(playerString(x, 0, sneo.body))
            end

            local string_state = false
            for i,v in ipairs(Game.stage:getObjects(playerString)) do
                if v.is_extending and v.extend then
                    string_state = true
                end
                if not v.is_extending and v.extend and not v.counted then
                    v.counted = true
                    table.insert(strings, v)
                    Assets.playSound("noise")
                    for i=#obstacles, 1, -1 do
                        obstacles[i]:destroy()
                    end
                    spawn_timer = 25
                    for i,v in ipairs(sneo.sprite.parts) do
                        v.shake = 1
                        v.friction = 0.1
                    end
                end
            end

            allow_string_shoot = not string_state

            spawn_timer = spawn_timer + DTMULT
            if spawn_timer >= 30 then
                spawn_timer = 0
                if #obstacles < 5 then
                    local limit = 5 - #obstacles
                    for i = #obstacles, limit+#obstacles do
                        local y = soul.y + Utils.random(-15, -2)
                        obstacles[i+1] = Obstacle(SCREEN_WIDTH+20, y, Utils.random(sneo.x-120, (sneo.x+sneo.width)+10), y, Utils.pick({"bullets/snowflakeBullet", "bullets/neo/crew"}), love.math.random(1, health_limit))
                        obstacles[i+1].table = obstacles
                        Game.battle:addChild(obstacles[i+1])
                    end
                end
            end
        end
    end)
    soul.start_shoot = true
    Game.battle:infoText("* Shoot with "..Input.getText("confirm").."![wait:2]\n* Send strings with "..Input.getText("cancel").."!")
    cutscene:wait(function()
        return #strings==3
    end)
    if soul.charge_sfx then
        soul.charge_sfx:stop()
        soul.charge_sfx = nil
    end
    Game.battle.battle_ui.encounter_text:setText("")
    health_limit = 3
    soul.start_shoot = false
    continue_cutscene = true
    spawn_timer = 29
    for i=#obstacles, 1, -1 do
        obstacles[i]:destroy()
    end
    Game.battle.timer:tween(1, soul_outer, {alpha=0})
    Game.battle.timer:tween(1, soul, {alpha=0.5})
    queen.sprite:resume()
    cutscene:wait(1.5)

    local rumble = Assets.playSound("rumble", 1, 1.2)
    print(rumble, rumble.volume, rumble:isPlaying())
    rumble:setLooping(true)
    sneo.sprite:setAllPartsShaking(1)
    for i,v in ipairs(strings) do
        v:shake(1, 1, 0)
    end
    susie:setSprite("shock")
    susie.sprite:setFacing("right")
    ralsei:setSprite("battle/hurt")
    ralsei.sprite:setFacing("right")

    susie.darken_timer = 0
    ralsei.darken_timer = 0
    susie.should_darken = false
    ralsei.should_darken = false
    queen.darken_fx.color = {1, 1, 1}
    Game.battle.background_fade_alpha=0
    Assets.playSound("noise")
    cutscene:wait(2.5)
    rumble:stop()
    Game.fader:fadeIn({speed=0.5, alpha=1})
    sneo.sprite:setAllPartsShaking(0)
    for i,v in ipairs(strings) do
        v:shake(1, 1, 0.1)
    end
    sneo.wing_l:setSprite(sneo.actor.path.."/wingl_break")
    sneo.wing_r:setSprite(sneo.actor.path.."/wingr_break")
    Assets.playSound("grab")
    local ice_shards = {}
    local shards_pos = {
        {483, 176},
        {487, 216},
        {511, 212},
        {511, 194},
        {583, 194},
        {585, 218},
        {553, 246},
        {555, 178}
    }
    for i=1,8 do
        local s = Sprite("enemies/spamton_neo/ice_shards/wing_"..(i<=4 and "l" or "r").."_"..i-(i<=4 and 0 or 4))
        s:setScale(2)
        s:setLayer(sneo.layer+(i<=4 and -10 or 10))
        Game.battle:addChild(s)
        s:setPosition(shards_pos[i][1], shards_pos[i][2])
        s.physics.direction = math.rad(Utils.random(360))
        s.physics.speed = 3
        s.physics.gravity = 0.4
        s:setRotationOrigin(0.5)
        s.graphics.spin = math.rad(10)
        ice_shards[i] = s
    end
    Game.battle.timer:tween(0.5, sneo, {y=240}, "in-out-cubic")
    for i,v in ipairs(strings) do
        Game.battle.timer:tween(0.5, v, {y=v.y-30}, "in-out-cubic")
    end
    cutscene:wait(2)
    Game.battle.timer:tween(1, soul_outer, {alpha=1})
    Game.battle.timer:tween(1, soul, {alpha=1})
    queen.sprite:pause()
    susie.darken_timer = 15
    ralsei.darken_timer = 15
    susie.should_darken = true
    ralsei.should_darken = true
    Game.battle.timer:tween(1, queen.darken_fx, {color={0.5, 0.5, 0.5}})
    Game.battle.timer:tween(1, Game.battle, {background_fade_alpha=0.75})
    cutscene:wait(2)
    continue_cutscene = false
    soul.start_shoot = true
    cutscene:wait(function()
        return #strings==6
    end)
    soul.start_shoot = false
    if soul.charge_sfx then
        soul.charge_sfx:stop()
        soul.charge_sfx = nil
    end
    continue_cutscene = true
    for i=#obstacles, 1, -1 do
        obstacles[i]:destroy()
    end
    sneo.sprite:setAllPartsShaking(1)
    Game.battle.timer:tween(1, soul_outer, {alpha=0})
    Game.battle.timer:tween(1, soul, {alpha=0})
    Game.battle.background_fade_alpha = 0
    susie.should_darken = false
    ralsei.should_darken = false
    queen.sprite:resume()
    queen.darken_fx.color = {1, 1, 1}
    cutscene:wait(2.5)
    sneo.sprite:setAllPartsShaking(0)
    Assets.playSound("weaponpull_fast")
    local flash = Sprite("enemies/spamton_neo/flash", 520, 95)
    flash:setScale(2)
    flash:setLayer(sneo.layer+10)
    Game.battle:addChild(flash)
    flash:setGraphics({
        grow = 0.4,
        fade_to = 0,
        fade = 0.1,
        fade_callback = function() flash:remove() end
    })
    sneo.head:setSprite(sneo.actor.path.."/head_break")
    cutscene:wait(1.5)
    susie:setSprite("walk")
    cutscene:text("* ...", "nervous", "susie")
    cutscene:text("* Kris,[wait:2] I dunno how you're doing that...", "nervous", "susie")
    cutscene:text("* But damn that's cool.", "smile", "susie")
    cutscene:text("* But don't think I'm gonna let you do the whole job yourself!", "closed_grin", "susie")
    cutscene:text("[noskip]* The TENSION is at its fullest![func:tp_up]", nil, nil, {functions={
        tp_up = function()
            Game.tension = 200
            Assets.playSound("boost")
        end
    }})
    local rude_buster = Registry.getSpell("rude_buster")
    Game:removeTension(50)
    local wait, text = cutscene:text("* Susie cast RUDE BUSTER!", {wait=false})
    rude_buster:onCast(susie, sneo)
    cutscene:wait(2)
    cutscene:wait(wait)

    local src = Assets.stopAndPlaySound(ralsei.chara:getAttackSound() or "laz_c")
    src:setPitch(ralsei.chara:getAttackPitch() or 1)

    Assets.playSound("criticalswing")

    for i = 1, 3 do
        local sx, sy = ralsei:getRelativePos(ralsei.width, 0)
        local sparkle = Sprite("effects/criticalswing/sparkle", sx + Utils.random(50), sy + 30 + Utils.random(30))
        sparkle:play(4/30, true)
        sparkle:setScale(2)
        sparkle.layer = BATTLE_LAYERS["above_battlers"]
        sparkle.physics.speed_x = Utils.random(2, 6)
        sparkle.physics.friction = -0.25
        sparkle:fadeOutSpeedAndRemove()
        sneo:addChild(sparkle)
    end

    ralsei:setAnimation("battle/attack", function()
        local damage = 99

        Game:giveTension(Utils.round(150/25))

        local dmg_sprite = Sprite(ralsei.chara:getAttackSprite() or "effects/attack/cut")
        dmg_sprite:setOrigin(0.5, 0.5)
        if crit then
            dmg_sprite:setScale(2.5, 2.5)
        else
            dmg_sprite:setScale(2, 2)
        end
        dmg_sprite:setPosition(sneo:getRelativePos(sneo.width/2, sneo.height/2))
        dmg_sprite.layer = sneo.layer + 0.01
        dmg_sprite:play(1/15, false, function(s) s:remove() end)
        sneo.parent:addChild(dmg_sprite)

        local sound = sneo:getDamageSound() or "damage"
        if sound and type(sound) == "string" then
            Assets.stopAndPlaySound(sound)
        end
        sneo:hurt(damage, ralsei)
        ralsei.chara:onAttackHit(sneo, damage)
    end)

    cutscene:wait(2)

    susie:flash()
    Assets.playSound("boost")
    local bx, by = Game.battle:getSoulLocation()
    local soul = Sprite("effects/soulshine", bx, by)
    soul:play(1/15, false, function()
        soul:remove()
    end)
    soul:setOrigin(0.25, 0.25)
    soul:setScale(2, 2)
    Game.battle:addChild(soul)

    local red_buster = Registry.getSpell("red_buster")
    Game:removeTension(60)
    local wait, text = cutscene:text("* Susie cast RED BUSTER!", {wait=false})
    cutscene:wait((1/15)+0.5)
    red_buster:onCast(susie, sneo)
    cutscene:wait(0.25)
    Game.fader:fadeOut({speed=0.5, color={1, 1, 1}})
    cutscene:wait(0.55)
    sneo.wing_l:setSprite(sneo.actor.path.."/wingl_f")
    sneo.wing_r:setSprite(sneo.actor.path.."/wingr_f")
    sneo.arm_l:setSprite(sneo.actor.path.."/arml_f")
    sneo.arm_r:setSprite(sneo.actor.path.."/armr_f")
    sneo.leg_l:setSprite(sneo.actor.path.."/legl_f")
    sneo.leg_r:setSprite(sneo.actor.path.."/legr_f")
    sneo.head:setSprite(sneo.actor.path.."/head_f")
    sneo.body:setSprite(sneo.actor.path.."/body_f")
    for i,v in ipairs(strings) do
        v:remove()
    end
    Game.battle.battle_ui.encounter_text:setText("")
    sneo.sprite:setStringCount(6)
    for i,v in ipairs(sneo.sprite.bg_strings) do
        v.visible = false
    end
    kris.y = 150
    kris.sprite.flip_x = false
    kris:resetSprite()
    queen:removeFX(queen.darken_fx)
    Game.battle.music.pitch = 1
    queen.air_mouv = true
    queen:setAnimation({"chair_feelgood", 1/8, true})
    Game.battle.timer:cancel(kris_power)
    susie:resetSprite()
    ralsei:resetSprite()
    cutscene:wait(1)
    cutscene:wait(cutscene:fadeIn(1, {global=true}))
    cutscene:wait(1)
    cutscene:battlerText(sneo, "...")
    cutscene:battlerText(sneo, "[[Audible Confusion]]")
    cutscene:text("* That guy looks even weirder without the ice.", "neutral_side", "susie")
    cutscene:text("* What the hell is he?", "nervous", "susie")
    cutscene:battlerText(sneo, "KRIS?[wait:5]\nKRIS.[wait:2]\nKRIS!")
    cutscene:battlerText(sneo, "I CAN [Hear] YOU\n[wait:2] AND [Smell] YOU!")
    cutscene:battlerText(sneo, "I AM NO MORE AN\n[[Ice Scream]].\nI AM")
    cutscene:battlerText(sneo, "SPAMTON G.[wait:3] SPAMTON!!")
    sneo.sprite:setAllPartsShaking(1)
    local laugh = Assets.stopAndPlaySound("snd_sneo_laugh_long")
    cutscene:wait(function()
        return not laugh:isPlaying()
    end)
    sneo.sprite:setAllPartsShaking(0)
    cutscene:wait(1)
    cutscene:battlerText(sneo, "MY NECK IS [Can't\nRotate Properly]")
    cutscene:text("* Wow That's The Guy I Threw Into The Acid Once", "smile", "queen")
    cutscene:text("* But He's Taller Now", "smile_side_r", "queen")
    cutscene:battlerText(sneo, "YOU![wait:3] YOU [Hoochi Mama]!!\n[wait:3]WHAT ARE YOU DOING HERE??")
    cutscene:text("* Well It's My Mansion", "true", "queen")
    cutscene:battlerText(sneo, "...[wait:3][$!@!].")
    kris:setAnimation("battle/act")
    Game.battle.battle_ui.action_boxes[1]:setHeadIcon("act")
    cutscene:text("* You explain the situation to Spamton.")
    kris:setAnimation("battle/act_end")
    Game.battle.battle_ui.action_boxes[1]:resetHeadIcon()
    cutscene:battlerText(sneo, "[Alone In The Dark]?[wait:3] [Corrupted\nBy The Shiny Ring]?[wait:3] [Christmas\nIs Coming Sooner This Year]?")
    cutscene:battlerText(sneo, "KRIS THAT'S[wait:5] A[wait:5] STEAL!\n[wait:7]I WOULD NEVER PUT MY\n[Esteem Customer] INTO\nSUCH DANGER!!")
    cutscene:battlerText(sneo, "Actually I DID.[wait:3] I SOLD YOU\nMY [Commemorative Ring],\n[wait:2]HAVEN'T I?")
    cutscene:text("* Wait,[wait:2] you're the one behind this thing?!", "angry_c", "susie")
    cutscene:battlerText(sneo, "AND NOW YOU WANT\nA [Immediate Refund]??")
    laugh:play()
    sneo.sprite:setAllPartsShaking(1)
    cutscene:wait(1.5)
    sneo.sprite:setAllPartsShaking(0)
    laugh:stop()
    cutscene:wait(1)
    cutscene:battlerText(sneo, "...")
    cutscene:battlerText(sneo, "TELL YOU WHAT KID.")
    cutscene:battlerText(sneo, "THAT [Angel] IS A DANGER\nTO BOTH OF US.[wait:3] TO BOTH\nOF OUR [Hyperlink Blocked].")
    cutscene:battlerText(sneo, "SO I'LL HELP.[wait:3] IT'S A\n[One Time Only Deal]!!\nSO OPEN YOUR EARS YOU\n[Worns]!")
    cutscene:battlerText(sneo, "THE ONLY WAY.[wait:3] TO FREE YOUR\nFRIEND.[wait:3] IS SIMPLY BY.\n[wait:3]DESTROYING.[wait:3] THE RING.")
    cutscene:battlerText(sneo, "AIM ONLY AT IT AND\nTHEN [Hope And Dreams]\nFOR THE BEST.")
    cutscene:text("* Wait,[wait:2] why should we-", "angry", "susie")
    laugh:play()
    sneo.sprite:setAllPartsShaking(2)
    local pitch = 1
    cutscene:wait(function()
        laugh:setPitch(pitch)
        pitch = pitch + 0.01*DTMULT
        return not laugh:isPlaying()
    end)
    sneo.sprite:setAllPartsShaking(0)
    cutscene:battlerText(sneo, "THE DEAL IS\n[Sign Right Here]!!")
    cutscene:battlerText(sneo, "LET'S GO KRIS!![wait:3] LET'S\n[Finish The Job].")

    Game.battle.timer:tween(1, sneo, {y=-150})
    cutscene:wait(cutscene:fadeOut(0.5, {color={1, 1, 1}}))

    Utils.removeFromTable(Game.battle.enemies, sneo)
    table.insert(Game.battle.enemies, Game.battle.encounter.noelle)
    Game.battle.encounter.noelle:setPosition(505, 187)
    Game.battle.encounter.noelle.intend_x = 505
    Game.battle.encounter.noelle.intend_y = 187
    Game.battle.encounter.noelle.visible = true
    Game.battle.encounter.noelle.sprite.alpha = 1
    Game.battle.encounter.noelle.fly_anim = true
    Game.battle.encounter.noelle:registerAct("FriedPipis", "Heals\n120HP", {"kris"}, 32, nil, {"spamton-icon"})
    Game.battle.encounter.noelle.text = {
        "* The end is close.",
        "* The temperature is going up.",
        "* The Angel is falling.",
        "* The ice pillar is breaking apart.",
        "* There's a light piercing the cold.",
        "* You feel warmer."
    }
    Game.battle.encounter.noelle.waves = {
        "secret/snowfall2",
        "secret/iceshocks",
        "secret/kinda_touhou_ngl",
        "secret/snowReject",
        "secret/fight",
        "secret/use_berdly"
    }
    Game.battle.encounter.noelle.comment="(Ring-Aim)"
    Game.battle.encounter.last_section = true

    Game.battle.encounter.snow.alpha = 0.5
    Game.battle.encounter.gradient.alpha = 0.5

    cutscene:wait(2)

    cutscene:fadeIn(0.5)
    cutscene:endCutscene()
end