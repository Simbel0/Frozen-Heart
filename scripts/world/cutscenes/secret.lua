return {
	intro = function(cutscene)
		cutscene:fadeOut(0)
		love.window.setTitle("Frozen Heart")
        Game:setFlag("plot", 10)

        Kristal.setPresence({
            details = "In the Overworld",
            largeImageKey = "logo_alt",
            largeImageText = "Kristal v" .. tostring(Kristal.Version),
            startTimestamp = os.time(),
            instance = 1
        })

        Game.party[1]:removeSpell("tension_absorb")

        cutscene:wait(2)

        Kristal.showBorder(1)
        cutsceneMusic=Music("flashback_excerpt", 1, 0.3)
        cutscene:setSpeaker("noelle")
        cutscene:text("* [speed:0.5][shake:1]...")
        cutscene:text("* [speed:0.5][shake:1]It hurts... So much...")
        cutscene:text("* [speed:0.5][shake:1]This strength... It's too much...")
        cutscene:text("* [speed:0.5][shake:1]What is going on..[wait:5] with me...?")
        cutscene:text("* [speed:0.5][shake:1]Someone...[wait:3] Someone please...")
        cutscene:text("* [speed:0.5][shake:1]Take this[wait:3] thing off my finger...")
        cutscene:text("* [speed:0.5][shake:1]I'm not...[wait:5] strong enough to do it myself...")

        local susie=cutscene:getCharacter("susie")
        local noelle=cutscene:getCharacter("noelle")
        noelle.actor.path = "party/noelle/dark_c"
        noelle:setSprite("walk")

        cutscene:look(noelle, "up")

        local transition = Game.world:getEvent(20)
        local ts_orix = transition.x

        transition.x=999
        susie.y=560
        noelle.x = noelle.x+20

        Game.world.timer:tween(1, cutsceneMusic, {pitch=1})
        cutscene:fadeIn(0)
        Assets.playSound("snd_dooropen")
        cutscene:wait(cutscene:walkTo(susie, susie.x, 320, 1, "right"))
        cutscene:setSpeaker("susie")
        transition.x=ts_orix
        cutscene:text("* Noelle?[wait:1] I'm back!", "sincere_smile")
        cutscene:text("* Everything will soon be over.", "small_smile")
        cutscene:walkTo(susie, 540, susie.y, 1.5)
        cutscene:text("* Kris will seal the fountain and then everthing-", "small_smile", nil, {auto=true, skip=false})
        cutscene:panTo(635, susie.y, 0.5)
        cutscene:text("* Noelle?", "nervous")
        cutscene:text("* What are you doing?[wait:1] Weren't you sleepy or something?", "nervous_side")
        cutsceneMusic:fade(0, 1, function() cutsceneMusic:remove() end)
        cutscene:text("* ...", nil, "noelle")
        cutscene:text("* No, this is fine.", nil, "noelle")
        cutscene:text("* ...You don't sound fine to me.", "neutral", "susie")
        cutscene:text("* Is there something wrong?", "nervous", "susie")
        cutscene:text("* No, Susie.", nil, "noelle")
        cutscene:wait(0.7)
        cutscene:look(noelle, "left")
        cutscene:wait(0.2)
        susie:shake(5)
        susie:setSprite("shock")
        cutscene:wait(0.5)
        cutscene:text("* I never felt better actually!", "crazy-neutral", "noelle")
        Game.world.music:play("d")
        cutscene:text("* ???", "surprise_frown", "susie")
        cutscene:text("* (What the hell is that face...)", "surprise", "susie")
        susie:setSprite("walk")
        cutscene:text("* Uh... Are you sure?", "nervous", "susie")
        cutscene:text("* You look, uh... Kinda dead tired right now, y'know?", "sus_nervous", "susie")
        cutscene:text("* Don't worry about me, Susie.", "crazy-side", "noelle")
        cutscene:text("* I became stronger.", "crazy-closed_eyes", "noelle")
        cutscene:text("* I can do so many things I couldn't do before.", "crazy-closed_eyes", "noelle")
        cutscene:text("* I solved things by myself.", "crazy-neutral", "noelle")
        cutscene:text("* I took things for myself.", "crazy-neutral", "noelle")
        cutscene:text("* I froze enemies by myself.", "crazy-neutral", "noelle")
        cutscene:text("* Isn't it great?", "crazy-insane", "noelle")
        cutscene:text("* ...", "sad", "susie")
        cutscene:text("* ...", "bangs_neutral", "susie")
        cutscene:text("* What's with the silence treatement?", "crazy-scared", "noelle")
        cutscene:text("* Don't you believe me?", "crazy-scared", "noelle")
        cutscene:text("* Noelle-", "sad_frown", "susie")
        cutscene:text("* That's[wait:5] just[wait:5] fine.", "crazy-neutral", "noelle")
        cutscene:text("* I can show you what I'm capable of[wait:3] right here,[wait:5] right now.", "crazy-snow", "noelle")
        cutscene:text("* Noelle, whatever you're about to do, don-", "surprise_frown", "susie")
        noelle:setSprite("closed-in")
        cutscene:slideTo(noelle, noelle.x+40, noelle.y, 0.5, "out-quad")
        cutscene:wait(0.7)
        noelle:setSprite("spell")
        local ice_emitter = ParticleEmitter(noelle.x-30, noelle.y-70, 0, 0, {
            layer = WORLD_LAYERS["below_ui"],
            every = 0.0001,
            amount = 4,
            texture = "snowflake",
            scale = 1,

            remove_after = 5,

            physics = {
                speed = 20
            },
            angle = {math.rad(235), math.rad(295)}
        })
        Game.world:addChild(ice_emitter)
        cutscene:shakeCamera(5, 1, false)
        Game.world.camera.shake_friction = nil
        print(Game.world.camera.shake_friction)
        susie:setSprite("shock")
        cutscene:slideTo(susie, susie.x-40, susie.y, 0.5, "out-quad")
        cutscene:shakeCharacter(susie, 5)
        local wind=Assets.playSound("snowwind")
        wind:setLooping(false)
        cutscene:wait(0.2)
        --Game.world.music:play("GALLERY")
        local gradient = Sprite("effects/icespell/gradient")
        gradient:setWrap(true, false)
        gradient.layer = WORLD_LAYERS["below_ui"]
        gradient:setScale(2)
        gradient.alpha = 0
        Game.world.timer:tween(3, gradient, {alpha=0.5})
        Game.world:addChild(gradient)
        cutscene:wait(2)
        local snow = Sprite("effects/icespell/snowfall")
        snow:setWrap(true)
        snow:setScale(2)
        snow.alpha = 0
        snow.layer = gradient.layer - 0.6
        snow.physics = {
            speed = 16,
            direction = math.rad(75)
        }
        Game.world:addChild(snow)
        Game.world.timer:tween(1, snow, {alpha=1})
        cutscene:wait(2.5)
        --Game.world.timer:tween(0.5, wind, {volume=0})
        cutscene:wait(cutscene:fadeOut(0.5, {color={1, 1, 1}}))
        -- Do the "Survivor Virovirokun and Ambyu-Lance get frozen part"
        cutscene:panTo(50, susie.y, 0)
        susie:setSprite("battle/defend_6")
        cutscene:wait(1.5)
        cutscene:text("* Ugh...", "", "susie")
        --Game.world.timer:tween(0.5, wind, {volume=1})
        cutscene:wait(cutscene:fadeIn(0.5))

        cutscene:wait(1)
        cutscene:wait(cutscene:slideTo(susie, susie.x-70, susie.y, 0.5))
        cutscene:wait(0.5)
        cutscene:wait(cutscene:slideTo(susie, susie.x-70, susie.y, 0.5))
        cutscene:wait(0.5)

        cutscene:setTextboxTop(true)
        cutscene:text("* Come on...", "down", "susie")

        cutscene:wait(1)
        cutscene:wait(cutscene:slideTo(susie, susie.x-70, susie.y, 0.4))
        cutscene:wait(0.5)
        cutscene:wait(cutscene:slideTo(susie, susie.x-70, susie.y, 0.3))
        cutscene:wait(0.5)

        cutscene:text("* Hnng...", "nervous_b", "susie")
        cutscene:wait(0.3)

        susie.alert_icon = Sprite("effects/alert", susie.sprite.width/2)
        susie.alert_icon:setOrigin(0.5, 1)
        susie.alert_icon.layer = 100
        susie:addChild(susie.alert_icon)
        Game.world.timer:after(0.8, function()
            susie.alert_icon:remove()
        end)
        cutscene:text("* Susie!", nil, "ralsei")

        local ralsei = cutscene:spawnNPC("ralsei", 255, 615, {facing="up"})
        local queen = cutscene:spawnNPC("queen", 282, 600, {facing="up"})

        cutscene:walkTo(ralsei, ralsei.x, 415)
        cutscene:wait(cutscene:walkTo(queen, queen.x, 400))

        cutscene:text("* Susie, what's happening??", "shock", "ralsei")
        cutscene:text("* I don't know.[wait:2] What do you THINK is happening?!", "annoyed", "susie")
        cutscene:wait(cutscene:walkTo(queen, queen.x, 310, 0.3))
        cutscene:look(queen, 'left')
        cutscene:text("* The Theme Of This Room Seems A Little Too Much Respected", "true", "queen")
        cutscene:look(queen, 'right')
        cutscene:text("* Noelle Honey Sweety Darling What Are You-", "smile_side_l", "queen")
        cutscene:text("* Holy Circuits What Happened Susie", "@@", "queen")
        cutscene:text("* I don't know, she just lost it out of nowhere!", "angry_b", "susie")
        cutscene:look(queen, 'down')
        queen:setSprite("walk_unhappy")
        cutscene:text("* ...", "down_c", "queen")
        cutscene:text("* I Thought Sleeping Would Suppr This Power Of Her Deep Inside", "pout", "queen")
        queen:setSprite("walk")
        cutscene:text("* But It Seems I Miscaculated", "sorry", "queen")
        cutscene:text("* What does that even mean??", "teeth", "susie")

        noelle.y=noelle.y-70
        ice_emitter.y=ice_emitter.y-70
        cutscene:detachCamera()
        cutscene:wait(cutscene:panTo(noelle.x, susie.y))
        cutscene:wait(0.5)
        ice_emitter:remove()
        Game.world.camera.shake_friction = 1
        Game.world.timer:tween(1, snow.physics, {speed=4})
        cutscene:wait(1)
        Game.world.music:fade(0, 2.5, function() Game.world.music:stop() end)
        cutscene:wait(cutscene:slideTo(noelle, noelle.x+1100, noelle.y-80, 2))
        cutscene:look(queen, "right")
        cutscene:setSprite(susie, "walk")
        ralsei:setPosition(ralsei.x, ralsei.y-60)
        cutscene:look(ralsei, "right")
        cutscene:wait(cutscene:attachCamera(0.75))

        cutscene:text("* Well That Happened", "bro", "queen")
        cutscene:text("* ...", "sad", "susie")
        cutscene:text("* ...", "shock", "ralsei")
        cutscene:look(queen, "down")
        cutscene:text("* Have Your (Organic) Tongue Froze Up?", "what", "queen")
        cutscene:wait(1)
        Assets.playSound("whip")
        susie:setSprite("turn_around")
        cutscene:text("* WHAT IS GOING ON HERE??", "teeth", "susie")
        cutscene:text("* I'd like to know the same thing.", "smile", "ralsei")
        cutscene:text("* This isn't... what should happen...", "pensive", "ralsei")
        susie:setSprite("walk")
        cutscene:look(susie, "up")
        cutscene:look(ralsei, "up")
        queen:setSprite("walk_unhappy")
        cutscene:look(queen, "right")
        cutscene:text("* Well To Tell The Truth", "pout", "queen")
        cutscene:text("* I Do Not Know Much Either", "sorry", "queen")
        cutscene:text("* When I Noticed That Bergluey Stopped Manifesting Around Me", "pout", "queen")
        cutscene:text("* I Got Worried So I Started Looking For Him", "true", "queen")
        cutscene:text("* But I Never Managed To Detect Him Anywhere", "down_b", "queen")
        cutscene:text("* And When I Went Back To The Mansion Not Only Did Someone Took Over It", "pout", "queen")
        cutscene:text("* But Noelle Was Also Here Extremely Tired And Distraught", "sorry", "queen")
        cutscene:text("* So I Used My Super Cool Flying Chair To Take Us Directly To Her Room", "nice", "queen")
        cutscene:text("* So She Could Finally Rest", "smile_side_r", "queen")
        cutscene:text("* While I Would Generate Another Plan To Expand The Dark World", "smile_side_r", "queen")
        queen:setSprite("walk")
        cutscene:look(queen, "down")
        cutscene:text("* But At The End Of The Day I Guess I Failed Either Way", "sorry", "queen")
        cutscene:text("* So...", "neutral", "susie")
        cutscene:look(susie, "down")
        cutscene:text("* Something happened while we and Kris were separated.", "neutral_side", "susie")
        cutscene:text("* When we reunited, Kris looked distraught as well.", "nervous", "susie")
        cutscene:text("* Don't worry Susie, I'm sure it's not as bad as it seems.", "pleased", "ralsei")
        cutscene:text("* But now, where would Noelle be?", "pensive", "ralsei")
        cutscene:look(susie, "up")
        cutscene:look(ralsei, "up")
        cutscene:text("* Probably The Fountain Room", "smile_side_l", "queen")
        cutscene:text("* Oh no, Kris is in here!", "shock", "ralsei")
        cutscene:look(susie, "right")
        cutscene:text("* Come on everyone! We're going to the fountain!", "angry", "susie")
        cutscene:look(susie, "up")
        cutscene:text("* May I Suggest A Good (Excellent) Way To Get To Krisp", "smile_side_l", "queen")
        cutscene:text("* You don't think...", "annoyed", "susie")
        cutscene:text("* Yes", "lmao", "queen")
        cutscene:look(susie, "right")
        cutscene:wait(1)
        cutscene:text("* Ugh, fine. Let's go.", "suspicious", "susie")
        cutscene:detachCamera()

        cutscene:walkTo(susie, susie.x+1000, susie.y, 4)
        cutscene:walkTo(ralsei, ralsei.x+1000, ralsei.y, 4)
        cutscene:walkTo(queen, queen.x+1000, queen.y, 4)

        cutscene:wait(1)
        cutscene:wait(cutscene:fadeOut(2))
        cutscene:wait(1)
        wind:stop()
        cutscene:gotoCutscene("secret.intro_2")
	end,
    intro_2=function(cutscene)
        Game:setFlag("plot", 10) --debug purpose
        Game.party[1]:removeSpell("tension_absorb") --that too

        local function castIceShock(user, target)
            local function createParticle(x, y)
                local sprite = Sprite("effects/icespell/snowflake", x, y)
                sprite:setOrigin(0.5, 0.5)
                sprite:setScale(1.5)
                sprite.layer = WORLD_LAYERS["bullets"]
                Game.world:addChild(sprite)
                return sprite
            end

            local x, y = target:getRelativePos(target.width/2, target.height/2, Game.world)

            local particles = {}
            Game.world.timer:script(function(wait)
                wait(1/30)
                Assets.playSound("icespell")
                particles[1] = createParticle(x-25, y-20)
                wait(3/30)
                particles[2] = createParticle(x+25, y-20)
                wait(3/30)
                particles[3] = createParticle(x, y+20)
                wait(3/30)
                Game.world:addChild(IceSpellBurst(x, y))
                for _,particle in ipairs(particles) do
                    for i = 0, 5 do
                        local effect = IceSpellEffect(particle.x, particle.y)
                        effect:setScale(0.75)
                        effect.physics.direction = math.rad(60 * i)
                        effect.physics.speed = 8
                        effect.physics.friction = 0.2
                        effect.layer = WORLD_LAYERS["bullets"] - 1
                        Game.world:addChild(effect)
                    end
                end
                wait(1/30)
                for _,particle in ipairs(particles) do
                    particle:remove()
                end
            end)

            return false
        end

        --Set the party correctly so that the room transition can set the party correctly
        Game:addPartyMember("kris", 1)
        Game:movePartyMember("susie", 2)
        Game:addPartyMember("ralsei", 3)

        cutscene:loadMap("fountain_room")

        cutscene:detachFollowers()
        cutscene:detachCamera()
        local kris = cutscene:getCharacter("kris")
        kris:setPosition(150, 280)
        kris:setAnimation({"battle/idle", 1/8, true})
        local susie = cutscene:getCharacter("susie")
        susie:setPosition(-420, 280)
        local ralsei = cutscene:getCharacter("ralsei")
        ralsei:setPosition(-420, 340)
        local sneo = cutscene:spawnNPC("spamtonneo", 525, 240)
        local queen = cutscene:spawnNPC("queen", -450, 300)
        queen:setSprite("walk_unhappy")
        local noelle = cutscene:spawnNPC("noelle", -50, 280)
        noelle.actor.path = "party/noelle/dark_c"
        noelle:setSprite("walk")

        cutscene:wait(cutscene:fadeIn(2))
        Game.world.music:play("Deal Gone Wrong", 0, 1)
        Game.world.music:fade(1, 2)

        cutscene:wait(1)

        Assets.playSound("voice/sneo")
        cutscene:wait(cutscene:slideTo(sneo, sneo.x-100, sneo.y, 1, "out-quad"))
        cutscene:wait(1)
        Assets.playSound("voice/sneo")
        cutscene:wait(cutscene:slideTo(sneo, sneo.x-100, sneo.y, 1, "out-quad"))
        cutscene:wait(1)
        Assets.playSound("voice/sneo")
        cutscene:wait(cutscene:slideTo(sneo, kris.x+50, sneo.y, 1, "out-quad"))
        cutscene:wait(1)

        local laugh = Assets.playSound("snd_sneo_laugh_long")
        sneo.sprite:setAllPartsShaking(2)
        cutscene:wait(function()
            return not laugh:isPlaying()
        end)
        cutscene:wait(2)

        Game.world.music:stop()
        sneo.sprite:setAllPartsShaking(0)
        castIceShock(noelle, sneo)
        cutscene:wait(0.3)
        cutscene:slideTo(kris, kris.x-190/2, kris.y, 1, "out-quad")
        kris:setSprite("kneel")
        sneo.sprite:getPart("body").sprite.frozen = true
        sneo.sprite:getPart("body").sprite.freeze_progress = 1
        Assets.playSound("petrify")
        cutscene:wait(cutscene:slideTo(sneo, sneo.x+190, sneo.y, 1, "out-quad"))
        cutscene:wait(0.5)
        castIceShock(noelle, sneo)
        cutscene:wait(0.3)
        sneo.sprite:getPart("wing_l").sprite.frozen = true
        sneo.sprite:getPart("wing_l").sprite.freeze_progress = 1
        sneo.sprite:getPart("arm_r").sprite.frozen = true
        sneo.sprite:getPart("arm_r").sprite.freeze_progress = 1
        sneo.sprite:getPart("leg_l").sprite.frozen = true
        sneo.sprite:getPart("leg_l").sprite.freeze_progress = 1
        Assets.playSound("petrify")
        cutscene:wait(cutscene:slideTo(sneo, sneo.x+100, sneo.y, 0.7, "out-quad"))
        cutscene:wait(0.2)
        castIceShock(noelle, sneo)
        cutscene:wait(0.3)
        sneo.sprite:getPart("wing_r").sprite.frozen = true
        sneo.sprite:getPart("wing_r").sprite.freeze_progress = 1
        sneo.sprite:getPart("arm_l").sprite.frozen = true
        sneo.sprite:getPart("arm_l").sprite.freeze_progress = 1
        sneo.sprite:getPart("leg_r").sprite.frozen = true
        sneo.sprite:getPart("leg_r").sprite.freeze_progress = 1
        Assets.playSound("petrify")
        cutscene:wait(cutscene:slideTo(sneo, sneo.x+100, sneo.y, 0.3, "out-quad"))
        cutscene:wait(0.1)
        castIceShock(noelle, sneo)
        cutscene:wait(0.3)
        sneo.sprite:getPart("head").sprite.frozen = true
        sneo.sprite:getPart("head").sprite.freeze_progress = 1
        Assets.playSound("petrify")
        cutscene:wait(cutscene:slideTo(sneo, SCREEN_WIDTH+100, sneo.y, 0.2, "out-quad"))

        cutscene:wait(0.5)
        Game.world.camera.keep_in_bounds = false
        cutscene:panTo(-25, Game.world.camera.y)
        cutscene:wait(cutscene:walkTo(noelle, kris.x-50, kris.y))

        sneo:remove()

        cutscene:setTextboxTop(true)

        cutscene:text("* I am here, Kris.", "crazy-closed_eyes", "noelle")
        cutscene:text("* I froze the enemy.", "crazy-side", "noelle")

        cutscene:wait(0.25)
        Assets.playSound("wing")
        kris:shake(2)

        cutscene:wait(1)
        kris.sprite.flip_x = true
        Assets.playSound("laz_c")
        kris:setAnimation({"battle/intro", 1/16, false})
        cutscene:slideTo(noelle, noelle.x-60, noelle.y, 0.5, "out-quad")
        cutscene:wait(1)

        Game.world.music:play("GALLERY")

        cutscene:text("* Kris?", "crazy-scared", "noelle")
        cutscene:text("* Why are you drawing your weapon on me?", "crazy-scared", "noelle")
        cutscene:text("* Why are you shaking and looking at me like that?", "crazy-neutral", "noelle")
        cutscene:text("* Kris...[wait:3] Are you an enemy now?", "crazy-insane", "noelle")

        cutscene:wait(0.3)

        local wait_buster = true
        Assets.playSound("rudebuster_swing")
        local beam = RudeBusterBeam(false, susie.x, susie.y, SCREEN_WIDTH, noelle.y-40, function() wait_buster = false end)
        beam:setLayer(WORLD_LAYERS["above_bullets"])
        Game.world:addChild(beam)
        cutscene:look(noelle, "left")
        cutscene:wait(0.2)
        Assets.playSound("wing")
        cutscene:slideTo(noelle, noelle.x, -50, 0.5)
        Game.world.timer:tween(0.5, Game.world.music, {volume=0}, "linear", function() Game.world.music:pause() end)
        cutscene:wait(function()
            return not wait_buster
        end)
        kris:setSprite("walk")
        cutscene:look(kris, "up")
        cutscene:wait(0.3)
        cutscene:walkTo(susie, kris.x-60, kris.y)
        cutscene:walkTo(ralsei, kris.x, ralsei.y)
        cutscene:walkTo(queen, kris.x-130, queen.y)
        cutscene:wait(1.5)
        cutscene:look(ralsei, "up")

        cutscene:text("* Kris! Are you okay??", "sad_frown", "susie")
        cutscene:text("* Kris, you're shaking...", "sad", "susie")
        cutscene:text("* Do you... need a hug maybe?", "blush", "ralsei")
        queen:setSprite("walk")
        --cutscene:text("* Why Are You Gae", "bro", "queen")
        cutscene:text("* Why Are You Guys Obsessed With Hugs", "what", "queen")
        cutscene:text("* Hey Kris... Do you know something about Noelle?", "nervous_side", "susie")
        cutscene:text("* She became really weird, did you guys do occult or something?", "nervous", "susie")

        kris:shake(5)
        cutscene:text("* Kris... Why?", nil, "noelle")
        cutscene:look(ralsei, "right")
        queen:setSprite("walk_unhappy")
        noelle:setPosition(SCREEN_WIDTH/2, (SCREEN_HEIGHT/2)-20)
        cutscene:during(function()
            noelle.y = ((SCREEN_HEIGHT/2)-20) + math.sin(Kristal.getTime()*3)*20
        end)
        cutscene:wait(cutscene:panTo(320/2, 240))
        cutscene:wait(0.2)
        Game.world.music:resume()
        Game.world.timer:tween(0.5, Game.world.music, {volume=1})
        cutscene:text("* Why did you join the enemies?", "crazy-scared", "noelle")
        cutscene:text("* Wait... WE are the enemies??", "surprise_confused", "ralsei")
        cutscene:text("* Kris, you're shaking even more...", "sad", "susie")
        cutscene:text("* ...", "angry", "susie")

        cutscene:wait(cutscene:walkTo(susie, kris.x+100, kris.y, 2))

        cutscene:wait(0.2)

        susie:setAnimation({"battle/attack", 1/15, false})
        Assets.playSound("laz_c", 1, 0.9)
        cutscene:wait(0.4)

        cutscene:text("* Hey, Noelle!", "angry", "susie")
        cutscene:text("* I don't know what happened to you or if you're still here..", "angry_b", "susie")
        cutscene:text("* But if you hurt my friends, I'll throw you to the ground!", "angry_c", "susie")

        cutscene:look(kris, "right")
        kris.sprite.flip_x = false
        Assets.playSound("laz_c", 1, kris.attack_pitch)
        kris:setAnimation({"battle/intro", 1/15, false})
        Assets.playSound("laz_c", 1, ralsei.attack_pitch)
        ralsei:setAnimation({"battle/intro", 1/15, false})

        cutscene:wait(cutscene:walkTo(queen, queen.x, SCREEN_HEIGHT+150, 0.5))
        cutscene:wait(0.3)
        queen:setAnimation({"chair", 1/8, true})
        cutscene:wait(cutscene:walkTo(queen, queen.x, 230, 0.5))
        cutscene:during(function()
            if Game.battle == nil then
                queen.y = 230 + math.sin(Kristal.getTime()*4)*10
            end
        end)

        cutscene:setTextboxTop(false)
        cutscene:text("* ...", "down_c", "queen")
        cutscene:text("* Noelle", "down_a", "queen")
        cutscene:text("* I Do Not Want To Do This", "pout", "queen")
        cutscene:text("* But You Have Awaken Too Much", "down_b", "queen")
        cutscene:text("* So I Guess We Will Have To Put You To Sleep Ourselves", "pout", "queen")

        noelle:setSprite("closed-in")
        cutscene:slideTo(noelle, noelle.x+40, noelle.y, 0.5, "out-quad")
        cutscene:wait(0.7)
        cutscene:setTextboxTop(true)
        cutscene:text("* Here we go.", "angry_c", "susie")
        noelle:setSprite("spell")
        local ice_emitter = ParticleEmitter(noelle.x-30, noelle.y-80, 0, 0, {
            layer = WORLD_LAYERS["below_ui"],
            every = 0.0001,
            amount = 4,
            texture = "snowflake",
            scale = 1,

            remove_after = 5,

            physics = {
                speed = 20
            },
            angle = {math.rad(235), math.rad(295)}
        })
        Game.world:addChild(ice_emitter)
        cutscene:shakeCamera(5, 1, false)
        Game.world.camera.shake_friction = nil
        local wind=Assets.playSound("snowwind")
        wind:setLooping(false)
        cutscene:wait(0.2)
        local gradient = Sprite("effects/icespell/gradient")
        gradient:setWrap(true, false)
        gradient.layer = WORLD_LAYERS["below_ui"]
        gradient:setScale(2)
        gradient.alpha = 0
        Game.world.timer:tween(3, gradient, {alpha=0.5})
        Game.world:addChild(gradient)
        cutscene:wait(2)
        local snow = Sprite("effects/icespell/snowfall")
        snow:setWrap(true)
        snow:setScale(2)
        snow.alpha = 0
        snow.layer = gradient.layer - 0.6
        snow.physics = {
            speed = 16,
            direction = math.rad(75)
        }
        Game.world:addChild(snow)
        Game.world.timer:tween(1, snow, {alpha=1})
        cutscene:wait(2.5)
        --Game.world.timer:tween(0.5, wind, {volume=0})
        cutscene:wait(cutscene:fadeOut(2, {color = {1, 1, 1}}))
        ice_emitter:remove()
        cutscene:wait(2)
        wind:stop()
        snow.physics.speed = 10
        gradient.alpha = 0.5
        --snow:remove()
        --gradient:remove()
        Game.world.camera:stopShake()
        cutscene:panTo(320, 240, 0)
        noelle.sprite.alpha = 0
        Game:setFlag("plot", 11)
        Game:saveQuick()
        Game.world.music:stop()
        cutscene:startEncounter("secret_battle", false, nil, {on_start=function()
            queen.alpha = 0
            Game.battle.encounter.queen = queen
            Game.battle.encounter.gradient = gradient
            Game.battle.encounter.snow = snow
            Game.world:removeChild(queen)
            Game.battle:addChild(Game.battle.encounter.queen)

            cutscene:fadeIn(1)
        end})
        cutscene:gotoCutscene("secret.ending")
    end,
    quickstart = function(cutscene)
        Game.world.camera.keep_in_bounds = false
        Game.world.fader.alpha = 1
        cutscene:panTo(-25, Game.world.camera.y, 0)
        cutscene:fadeIn(1)
        cutscene:detachCamera()
        cutscene:detachFollowers()
        local kris = cutscene:getCharacter("kris")
        kris:setPosition(-450, 280)
        local susie = cutscene:getCharacter("susie")
        susie:setPosition(-420, 280)
        local ralsei = cutscene:getCharacter("ralsei")
        ralsei:setPosition(-420, 340)
        local queen = cutscene:spawnNPC("queen", -450, 230)
        queen:setAnimation({"chair", 1/8, true})
        local noelle = cutscene:spawnNPC("noelle", SCREEN_WIDTH/2, (SCREEN_HEIGHT/2)-20)
        noelle.actor.path = "party/noelle/dark_c"
        noelle:setSprite("walk")
        cutscene:look(noelle, "left")
        cutscene:fadeIn(2)
        cutscene:during(function()
            noelle.y = ((SCREEN_HEIGHT/2)-20) + math.sin(Kristal.getTime()*3)*20
            if Game.battle == nil then
                queen.y = 230 + math.sin(Kristal.getTime()*4)*10
            end
        end)
        local walks = {
            cutscene:walkTo(kris, 50, 280, 2),
            cutscene:walkTo(susie, 150, 280, 2),
            cutscene:walkTo(ralsei, 50, ralsei.y, 2),
            cutscene:slideTo(queen, -120, queen.y, 2)
        }
        cutscene:wait(function()
            return walks[1]() and walks[2]() and walks[3]() and walks[4]()
        end)
        cutscene:wait(0.5)
        cutscene:wait(cutscene:panTo(320/2, 240))
        cutscene:wait(0.3)

        Assets.playSound("laz_c", 1, susie.attack_pitch)
        susie:setAnimation({"battle/attack", 1/15, false})
        Assets.playSound("laz_c", 1, kris.attack_pitch)
        kris:setAnimation({"battle/intro", 1/15, false})
        Assets.playSound("laz_c", 1, ralsei.attack_pitch)
        ralsei:setAnimation({"battle/intro", 1/15, false})

        cutscene:wait(0.5)

        noelle:setSprite("closed-in")
        cutscene:slideTo(noelle, noelle.x+40, noelle.y, 0.5, "out-quad")
        cutscene:wait(0.7)
        noelle:setSprite("spell")
        local ice_emitter = ParticleEmitter(noelle.x-30, noelle.y-80, 0, 0, {
            layer = WORLD_LAYERS["below_ui"],
            every = 0.0001,
            amount = 4,
            texture = "snowflake",
            scale = 1,

            remove_after = 5,

            physics = {
                speed = 20
            },
            angle = {math.rad(235), math.rad(295)}
        })
        Game.world:addChild(ice_emitter)
        cutscene:shakeCamera(5, 1, false)
        Game.world.camera.shake_friction = nil
        local wind=Assets.playSound("snowwind")
        wind:setLooping(false)
        cutscene:wait(0.2)
        local gradient = Sprite("effects/icespell/gradient")
        gradient:setWrap(true, false)
        gradient.layer = WORLD_LAYERS["below_ui"]
        gradient:setScale(2)
        gradient.alpha = 0
        Game.world.timer:tween(3, gradient, {alpha=0.5})
        Game.world:addChild(gradient)
        cutscene:wait(1)
        local snow = Sprite("effects/icespell/snowfall")
        snow:setWrap(true)
        snow:setScale(2)
        snow.alpha = 0
        snow.layer = gradient.layer - 0.6
        snow.physics = {
            speed = 16,
            direction = math.rad(75)
        }
        Game.world:addChild(snow)
        Game.world.timer:tween(1, snow, {alpha=1})
        cutscene:wait(1.5)
        --Game.world.timer:tween(0.5, wind, {volume=0})
        cutscene:wait(cutscene:fadeOut(1, {color = {1, 1, 1}}))
        ice_emitter:remove()
        cutscene:wait(1)
        wind:stop()
        snow.physics.speed = 10
        gradient.alpha = 0.5
        --snow:remove()
        --gradient:remove()
        Game.world.camera:stopShake()
        cutscene:panTo(320, 240, 0)
        noelle.sprite.alpha = 0
        Game:setFlag("plot", 11)
        Game:setFlag("allow_music_skip", true)
        Game:saveQuick()
        cutscene:startEncounter("secret_battle", false, nil, {on_start=function()
            queen.alpha = 0
            Game.battle.encounter.queen = queen
            Game.battle.encounter.gradient = gradient
            Game.battle.encounter.snow = snow
            Game.world:removeChild(queen)
            Game.battle:addChild(Game.battle.encounter.queen)

            cutscene:fadeIn(1)
        end})
        cutscene:gotoCutscene("secret.ending")
    end,
    ending = function(cutscene)
        if Game.world.map.id ~= "fountain_room" then
            Game:addPartyMember("kris", 1)
            Game:movePartyMember("susie", 2)
            Game:addPartyMember("ralsei", 3)
            Game:removePartyMember("noelle")

            Game:setFlag("plot", 10)
            cutscene:wait(Game.world:loadMap("fountain_room"))
            cutscene:detachCamera()
            cutscene:detachFollowers()

            cutscene:getCharacter("kris"):setPosition(150-190/2, 280)
            cutscene:getCharacter("susie"):setPosition(155, 280)
            cutscene:getCharacter("ralsei"):setPosition(55, 340)
            cutscene:look(cutscene:getCharacter("kris"), "right")
            cutscene:look(cutscene:getCharacter("susie"), "right")
            cutscene:look(cutscene:getCharacter("ralsei"), "right")
        end
        --Game.world.music:stop()

        local kris = cutscene:getCharacter("kris")
        local susie = cutscene:getCharacter("susie")
        local ralsei = cutscene:getCharacter("ralsei")
        local sneo = cutscene:spawnNPC("spamtonneo", -500, 360)
        local noelle = cutscene:spawnNPC("noelle", 520, 300)
        noelle:setSprite("collapsed")
        sneo.flip_x = true
        sneo.sprite:setStringCount(6)
        sneo.sprite:getPart("wing_l"):setSprite(sneo.actor.path.."/wingl_f")
        sneo.sprite:getPart("wing_r"):setSprite(sneo.actor.path.."/wingr_f")
        sneo.sprite:getPart("arm_l"):setSprite(sneo.actor.path.."/arml_f")
        sneo.sprite:getPart("arm_r"):setSprite(sneo.actor.path.."/armr_f")
        sneo.sprite:getPart("leg_l"):setSprite(sneo.actor.path.."/legl_f")
        sneo.sprite:getPart("leg_r"):setSprite(sneo.actor.path.."/legr_f")
        sneo.sprite:getPart("head"):setSprite(sneo.actor.path.."/head_f")
        sneo.sprite:getPart("body"):setSprite(sneo.actor.path.."/body_f")

        sneo.sprite:getPart("wing_l").swing_speed = 0
        sneo.sprite:getPart("wing_r").swing_speed = 0
        sneo.sprite:getPart("arm_l").swing_speed = 0.5
        sneo.sprite:getPart("arm_r").swing_speed = 0
        sneo.sprite:getPart("leg_l").swing_speed = 1
        sneo.sprite:getPart("leg_r").swing_speed = 1.5
        sneo.sprite:getPart("head").swing_speed = 0
        sneo.sprite:getPart("body").swing_speed = 0
        for i,v in ipairs(sneo.sprite.bg_strings) do
            v.visible = false
        end
        local queen = cutscene:spawnNPC("queen", -450, 250)
        queen:setSprite("chair_feelgood")
        queen:play(1/8)
        local queen_base_y = queen.y
        cutscene:during(function()
            if queen then
                queen.y = queen_base_y + math.sin(Kristal.getTime()*4)*10
            end
        end)

        kris:resetSprite()
        susie:resetSprite()
        ralsei:resetSprite()

        cutscene:wait(2)
        --cutscene:setTextboxTop(true)
        cutscene:text("* Did...[wait:3] Did we do it?", "sus_nervous", "susie")
        cutscene:text("* I think so, Susie...", "smile_side", "ralsei")

        cutscene:wait(1)

        Assets.playSound("ui_cancel")
        Assets.playSound("bell")
        susie:setSprite("pose")
        Kristal.callEvent("completeAchievement", "alt")
        cutscene:text("* Hell yeah![wait:2] The $!$! Squad saved the day![react:1]", "closed_grin", "susie", {reactions={
            {"...", "right", "bottom", "owo", "ralsei"}
        }})
        susie:resetSprite()
        cutscene:look(kris, "left")
        cutscene:look(susie, "left")
        cutscene:look(ralsei, "left")
        Game.world.camera.keep_in_bounds = false
        local camera_x = Game.world.camera.x
        cutscene:panTo(-25, Game.world.camera.y)
        Game.world.timer:tween(1.5, queen, {x=-105})
        cutscene:text("* Congratulations Lightners You Have Indeed: Won", "smile", "queen")
        cutscene:text("* I'd Cue The Fanfare But I Don't Have Any For Winning A Battle", "true", "queen")
        queen.flip_x = true
        print(queen.x, queen.sprite.width)
        queen.x = queen.x + queen.sprite.width*4
        print(queen.x, queen.sprite.width)
        local sneo_moov = Game.world.timer:tween(1.5, sneo, {x=-235}, nil)
        cutscene:text("* DOES THAT MEAN I CAN HAVE THE [Mansion] NOW??", nil, "spamtonneo")
        cutscene:text("* No", "lmao", "queen")
        cutscene:text("* YOU F[wait:5][ilthy Weed Invading Your Garden]!!", nil, "spamtonneo")
        cutscene:text("* While I'm Pretty Sure You Have Done A Lot Of Bad Stuff Today", "smile_side_l", "queen")
        cutscene:text("* You Helped Us Saving Noelle So Maybe You Deserve A Little Thing", "lying", "queen")
        cutscene:text("* A SURPRISE DEAL??[wait:3] I'M LISTENING!", nil, "spamtonneo")
        cutscene:text("* Let's Speak Of That Elsewhere So Kris & Co Can Do Their Stuff", "neutral", "queen")
        cutscene:text("* AHAHAHAHA!![wait:2] THANKS KRIS!![wait:2] I'M FINALLY", nil, "spamtonneo")
        cutscene:text("* I'M FINALLY GONNA BE A [[BIG SHOT]] AGAIN!!", nil, "spamtonneo")
        Game.world.timer:cancel(sneo_moov)
        sneo.sprite:setAllPartsShaking(1)
        Game.world.timer:tween(1.5, sneo, {x=-450})
        local laugh = Assets.playSound("snd_sneo_laugh_long")
        cutscene:wait(function() return not laugh:isPlaying() end)
        queen.flip_x = false
        queen.x = queen.x - queen.sprite.width*4
        cutscene:text("* So Uh Yeah", "smile_side_r", "queen")
        cutscene:text("* Do Your Stuff While I [wait:2]\"Kick\"[wait:2] His [wait:2]\"Big Shots\"[wait:2] To The Recycle Bin", "lmao", "queen")
        Game.world.timer:tween(1, queen, {x=-460})
        queen:setAnimation({"chair_ohoho", 1/8, true})
        local laugh = Assets.playSound("queen/laugh")
        cutscene:wait(function() return not laugh:isPlaying() end)
        --cutscene:panTo(SCREEN_HEIGHT/2, Game.world.camera.y)

        cutscene:wait(1)

        cutscene:look(kris, "right")
        cutscene:look(ralsei, "right")

        cutscene:text("* So I guess it's over,[wait:2] right?", "neutral_side", "susie")
        cutscene:look(susie, "right")
        cutscene:text("* We just need to get Noelle over there and we'll be good to go!", "closed_grin", "susie")

        cutscene:wait(cutscene:panTo(camera_x, Game.world.camera.y))

        cutscene:wait(1)

        cutscene:text("* Noelle?", "neutral_side", "susie")
        cutscene:text("* Did we knock her THAT hard??", "nervous_side", "susie")
        cutscene:text("* Oh! Don't worry, Susie!", "surprise_smile", "ralsei")
        cutscene:text("* Nothing a healing spell can't solve.", "wink", "ralsei")

        cutscene:wait(cutscene:walkTo(ralsei, noelle.x - 100, noelle.y, 2))

        cutscene:wait(0.5)

        ralsei:setAnimation({"battle/spell", 1/15, false, next="walk"})
        Assets.playSound("spellcast")
        cutscene:wait(0.5)
        noelle:flash()

        cutscene:wait(2)

        cutscene:text("* ...", "surprise_smile", "ralsei")
        cutscene:text("* Well that's, uhm...", "surprise_neutral_side", "ralsei")
        cutscene:text("* Weird.", "small_smile_side", "ralsei")
        cutscene:text("* Ralsei..? You're sure everything's fine?", "nervous", "susie")
        cutscene:text("* Of course... Let me try again.", "pleased", "ralsei")

        ralsei:setAnimation({"battle/spell", 1/15, false, next="walk"})
        Assets.playSound("spellcast")
        cutscene:wait(0.5)
        noelle:flash()

        cutscene:wait(2)

        cutscene:text("* (Why does it feel like...)", "surprise_neutral_side", "ralsei")
        cutscene:wait(cutscene:walkTo(ralsei, noelle.x+5, noelle.y-5))
        Assets.playSound("noise")
        ralsei:setSprite("landed_1")

        cutscene:wait(3)

        cutscene:walkTo(kris, kris.x + 100, kris.y)
        cutscene:wait(cutscene:walkTo(susie, susie.x + 100, susie.y))

        cutscene:text("* ...[wait:2]Ralsei?", "nervous_side", "susie")

        cutscene:wait(1)

        ralsei:setSprite("landed_2")
        cutscene:text("* Uhm...[wait:2] It may be a stupid question but you two know best...", "small_smile_side", "ralsei")
        cutscene:text("* Can monsters,[wait:2] uhm..[wait:3] Not breathe?", "smile_side", "ralsei")

        cutscene:text("* Uh?[wait:2] Well,[wait:2] I mean...[wait:2] I think some don't need to since they're not--", "nervous_side", "susie")
        cutscene:text("* Wait,[wait:5] WHY[wait:2] are you asking??", "sad", "susie")
        local overlay = Sprite("overlay")
        overlay:setLayer(WORLD_LAYERS["below_textbox"])
        overlay.alpha = 0
        Game.world:addChild(overlay)
        local pre_flashing = true
        cutscene:during(function()
            if pre_flashing and overlay.alpha < 1 then
                overlay.alpha = overlay.alpha + 0.1
                if overlay.alpha >= 1 then
                    pre_flashing = false
                end
            else
                overlay.alpha = Utils.random(0.5, 1)
            end
        end)
        Game.world.music:play("heartbeat")
        Game.stage:shake(0.1, -0.1, 0, 1/6)
        cutscene:text("* ...", "frown_b", "ralsei")
        cutscene:text("* Susie,[wait:3] I...", "frown_b", "ralsei")

        cutscene:panTo(noelle)
        cutscene:walkTo(kris, ralsei.x-65, ralsei.y)
        local wait = cutscene:walkTo(susie, ralsei.x, ralsei.y)
        cutscene:wait(0.5)
        ralsei:resetSprite()
        cutscene:walkTo(ralsei, ralsei.x+80, ralsei.y, 0.5, "left", true)
        cutscene:wait(wait)
        susie:setSprite("landed_1")
        Game.world.fader.fade_color = {0, 0, 0}

        cutscene:text("* NOELLE?!"," sad_frown", "susie")
        Game.world.fader.alpha = 0.1
        cutscene:text("* CAN YOU HEAR US??", "sad_frown", "susie")
        Game.world.fader.alpha = 0.25
        cutscene:text("* There's no way we...", "sad", "susie")
        Game.world.fader.alpha = 0.4
        cutscene:text("* Maybe... That ring...", "pensive", "ralsei")
        Game.world.fader.alpha = 0.55
        cutscene:text("* No way...", "sad", "susie")
        Game.world.fader.alpha = 0.7
        cutscene:text("* Noelle!!", "teeth", "susie")
        Game.world.fader.alpha = 0.85
        cutscene:text("* Come back to us!!", "sad_frown", "susie")
        Game.world.fader.alpha = 1

        cutscene:wait(2)

        cutscene:text("* Come on!!", nil, "susie")

        Game.world.music:fade(0, 1.5)
        Game.stage:stopShake()
        cutscene:setTextboxTop(false)

        cutscene:wait(3)

        cutscene:text("[voice:n]* (Come on...)")

        cutscene:wait(1)

        cutscene:text("[voice:n]* (Where am I...)")

        cutscene:wait(1)

        cutscene:text("[voice:n]* (It's so bright... Too bright...)")

        cutscene:wait(1)

        cutscene:text("[voice:n]* (Why can't I feel anything...?)")

        cutscene:wait(1)

        cutscene:text("[voice:n]* (Susie...[wait:10] Kris...[wait:10] Dad...[wait:10] Dess...)")

        Game:setPartyMembers("noelle")
        Game.party[1].spells = {}
        Game.party[1].health = Game.party[1].stats.health

        cutscene:loadMap("end")

        local p = Kristal.getPresence()
        Kristal.setPresence({
            details = "At the end",
            largeImageKey = "logo_end",
            largeImageText = "Kristal v" .. tostring(Kristal.Version),
            startTimestamp = p.startTimestamp,
            instance = p.instance
        })

        local overlay = Sprite("overlay")
        overlay:setLayer(WORLD_LAYERS["below_textbox"])
        overlay.alpha = 1
        Game.world:addChild(overlay)
        Game.world.music:play("tv_noise", 0)
        local noelle = cutscene:getCharacter("noelle")
        noelle:setPosition(300, 400)
        Game.world.camera.keep_in_bounds = true
        noelle.actor.path = "party/noelle/dark_b"
        noelle:setSprite("walk_kill")
        Game.world.fader:fadeIn(nil, {speed=10})
        Game.world.music:fade(1, 5)
        cutscene:during(function()
            if not overlay then return false end
            overlay:setScreenPos(0, 0)
        end, true)
        cutscene:wait(cutscene:walkTo(noelle, 900, 400, 20))
        cutscene:wait(cutscene:panTo(941+(117/2)-20, Game.world.camera.y))
        cutscene:wait(1)
        cutscene:look(noelle, "up")
        cutscene:wait(2)
        Game.world.fader.alpha = 1
        overlay:remove()
        Game.world.music:stop()

        cutscene:wait(3)

        local text = DialogueText("[noskip][speed:0.3][voice:n]* (I don't want to let go.)", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        text.width, text.height = text:getTextWidth(), text:getTextHeight()
        text:setLayer(WORLD_LAYERS["top"])
        Game.world:addChild(text)
        text:setScreenPos((SCREEN_WIDTH/2)-text.width/2, SCREEN_HEIGHT/2)

        cutscene:wait(function()
            return text.done
        end)
        text:remove()
        cutscene:wait(2)
        Game.world.fader.alpha = 0
        Game.fader.alpha = 1
        Game.fader.fade_color = {0, 0, 0}
        Game.fader:fadeIn(nil, {speed=2})
        cutscene:startEncounter("end", false)
        cutscene:gotoCutscene("full_credits")
    end
}