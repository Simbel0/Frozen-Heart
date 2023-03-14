return {
    killing_spamton=function(cutscene, quick_start)
        print(quick_start)

        local function statusMessage(color, hit_count, crit)

            local offset = (hit_count * 20)

            local amount
            if color[2]==0 then
                amount = 208 + love.math.random(10) + (crit and 100 or 0)
            else
                amount = 684 + love.math.random(20)
            end

            local percent = DamageNumber("dmg", amount,  434,  220 - offset, color)
            percent.layer=WORLD_LAYERS["top"]

            Game.world:addChild(percent)
        end

        local spamton_boss = Game:getFlag("spamton_boss")
        local ending = Game:getFlag("noelle_battle_status", "no_trance")

        if Game.world.map.id~="fountain_room" then
            cutscene:wait(cutscene:loadMap("fountain_room"))
        end

        cutscene:fadeOut(0)
        Kristal.hideBorder(1)
        cutscene:wait(1)

        if spamton_boss and ending=="killkill" then
            Game:removePartyMember("susie")
            Game:addPartyMember("kris")
            Game:movePartyMember("kris", 1)
            cutscene:gotoCutscene("spamton_cutscenes.standing_here")
        end

        local laugh=Assets.playSound("snd_sneo_laugh_long")
        cutscene:wait(function()
            return not laugh:isPlaying()
        end)
        cutscene:wait(0.5)

        if not quick_start or ending~="killkill" then
            local i=0
            Game.world.timer:everyInstant(1/22, function()
                Assets.playSound("voice/sneo")
                i=i+1
            end, 20)
            cutscene:wait(function()
                return i>=19
            end)
            cutscene:wait(0.75)
        end

        if ending == "no_trance" then
            Assets.playSound("icespell")
            Assets.playSound("rudebuster_swing")
            cutscene:wait(0.2)
            Assets.playSound("damage")
            statusMessage({1, 1, 0}, 0)
            cutscene:wait(0.1)
            Assets.stopAndPlaySound("damage")
            statusMessage({1, 1, 0}, 1)
            cutscene:wait(0.1)
            Assets.stopAndPlaySound("damage")
            Assets.playSound("rudebuster_hit")
            statusMessage({1, 1, 0}, 2)
            statusMessage({1, 0, 1}, 3)
        elseif ending == "killspare" then
            Assets.playSound("rudebuster_swing")
            cutscene:wait(0.3)
            Assets.stopAndPlaySound("damage")
            Assets.playSound("rudebuster_hit")
            statusMessage({1, 0, 1}, 0)
            cutscene:wait(0.1)
            Assets.playSound("rudebuster_swing")
            cutscene:wait(0.3)
            Assets.stopAndPlaySound("damage")
            Assets.playSound("rudebuster_hit")
            statusMessage({1, 0, 1}, 1)
            cutscene:wait(0.1)
            Assets.playSound("rudebuster_swing")
            cutscene:wait(0.3)
            Assets.stopAndPlaySound("damage")
            Assets.playSound("rudebuster_hit")
            statusMessage({1, 0, 1}, 2)
            cutscene:wait(0.1)
            Assets.playSound("criticalswing")
            cutscene:wait(0.3)
            Assets.stopAndPlaySound("damage")
            Assets.playSound("rudebuster_hit")
            statusMessage({1, 0, 1}, 3, true)
        elseif ending == "thorn_kill" then
            Assets.playSound("icespell")
            cutscene:wait(0.2)
            Assets.playSound("damage")
            statusMessage({1, 1, 0}, 0)
            cutscene:wait(0.1)
            Assets.stopAndPlaySound("damage")
            statusMessage({1, 1, 0}, 1)
            cutscene:wait(0.1)
            Assets.stopAndPlaySound("damage")
            statusMessage({1, 1, 0}, 2)
        end
        cutscene:wait(2.5)

        if spamton_boss then
            Game:setFlag("plot", 4)

            Game:addPartyMember("kris")
            Game:movePartyMember("kris", 1)

            if ending=="thorn_kill" then
                Game:removePartyMember("susie")
                Game:addPartyMember("noelle")
            end

            print("Previous inventory: "..Utils.dump(Game.inventory:getStorage("items")))
            local temp_inv = {
                "cd_bagel",
                "cd_bagel",
                "cd_bagel"
            }
            print("Temp Inventory first: "..Utils.dump(temp_inv))

            local items = Game.inventory:getStorage("items")
            local yeah = {}
            for i=#items, 1, -1 do
                local item = items[i]
                table.insert(yeah, item.id)
                Game.inventory:removeItem(item)
            end
            for k,v in pairs(Utils.reverse(yeah)) do
                table.insert(temp_inv, v)
            end
            print("Temp Inventory after transfer: "..Utils.dump(temp_inv))

            while #temp_inv>12 do
                table.remove(temp_inv, 1)
            end
            print("Temp Inventory after full check: "..Utils.dump(temp_inv))

            for k,v in pairs(temp_inv) do
                Game.inventory:addItem(v)
            end
            print("New inventory: "..Utils.dump(Game.inventory:getStorage("items")))

            cutscene:wait(cutscene:loadMap("fountain_room"))
            cutscene:detachFollowers()

            laugh:play()
            Game.world.timer:every(0.5, function()
                if not laugh:isPlaying() then return false end

                laugh:setPitch(Utils.random(1, 2))
            end)
            cutscene:wait(function()
                return not laugh:isPlaying()
            end)
            if not quick_start then
                cutscene:wait(0.5)
                spamtonMusic=Music("SnowGrave NEO")
                Game:setBorder("simple")
                Kristal.showBorder(1)
                cutscene:wait(function()
                    print(spamtonMusic:tell())
                    return spamtonMusic:tell()>=8
                end)
            end
            sneo=Game.world:spawnNPC("spamtonneo", 525, 330)
            cutscene:getCharacter("kris"):setPosition(310, 300)
            cutscene:getCharacter("susie"):setPosition(310, 370)
            cutscene:getCharacter("noelle"):setPosition(310, 427)
            cutscene:look("kris", "right")
            cutscene:look("susie", "right")
            cutscene:look("noelle", "right")
            cutscene:fadeIn(0)
            cutscene:startEncounter("bonus_battle", false, sneo)
            if Game:getFlag("spamton_conclusion", "undefined") == "killed" then
                local sneo = cutscene:getCharacter("spamtonneo")
                local kris = cutscene:getCharacter("kris")
                for i,v in ipairs(sneo.sprite.parts) do
                    if v.id~="head" then
                        v.sprite.frozen = true
                        v.sprite.freeze_progress = 1
                    end
                    v.swing_speed = 0
                end
                cutscene:getCharacter("noelle"):setSprite("walk")
                Game.world:getEvent(2).adjust=0
                sneo.sprite:setStringCount(1)
                sneo.sprite.bg_strings[1].alpha = 0
                local fg_sx, fg_sy = sneo.sprite:getRelativePos(ox, oy, sneo)
                sneo.sprite.fg_strings[1].x = (fg_sx+sneo.width/2)-8
                sneo.sprite.fg_strings[1].swing_speed = 0
                cutscene:setTextboxTop(true)
                sneo.sprite:setHeadAnimating(false)
                sneo.sprite:getPart("head"):setSprite("npcs/spamton/head_death")
                cutscene:wait(0.7)
                Game.fader:fadeIn(nil, {speed=2})
                cutscene:wait(2.5)
                cutscene:text("* ...", nil, sneo)
                cutscene:text("* Ah! Look at you! You can't even move a limb!", "smirk", "susie")
                cutscene:look("kris", "up")
                cutscene:look("susie", "up")
                cutscene:look("noelle", "up")
                cutscene:text("* Come on, Kris. Let's seal the fountain!", "smile", "susie")
                cutscene:look("kris", "right")
                cutscene:look("noelle", "right")
                cutscene:text("* KRIS... WAIT...", nil, sneo)
                cutscene:text("* Kris, just ignore him.", "neutral_side", "susie")
                cutscene:look("susie", "right")
                cutscene:wait(cutscene:walkTo(kris, kris.x+80, kris.y, 1))
                cutscene:wait(0.7)
                cutscene:text("* Kris??", "sad_frown", "susie")
                cutscene:text("* ..Well if you think it's worth listening...", "neutral", "susie")
                cutscene:text("* What do you want, weirdo?", "annoyed", "susie")
                cutscene:wait(1)
                Game.world.music:play("spamton_neo_after", 1, 1)
                cutscene:text("* IT...[wait:1]\nIt seems that even after all this...", nil, sneo)
                cutscene:text("* Even after reaching the top, I always seem to be doomed to fall back down.", nil, sneo)
                cutscene:text("* Even then, I can't be anything more than a simple puppet...", nil, sneo)
                cutscene:text("* But you three, it may not look like it..", nil, sneo)
                cutscene:text("* But you may be able to free yourself of your strings.", nil, sneo)
                cutscene:wait(1)
                cutscene:text("* Kris...", nil, sneo)
                cutscene:fadeOut(0)
                Game.world.music:stop()
                cutscene:wait(1)
                cutscene:text("* Good luck. You'll need it.", nil, sneo)
                cutscene:wait(0.5)
                Assets.playSound("snd_icespell2")
                cutscene:wait(2.5)
                --cutscene:text("* (You got the PuppetScarf.)")
                --cutscene:text("* (You got the ShadowCrystal.)")
                cutscene:gotoCutscene("ending.closing_fountain")
            end
        else
            cutscene:gotoCutscene("ending.closing_fountain")
        end
    end,
    closing_fountain=function(cutscene)
        cutscene:fadeOut(0)
        Kristal.hideBorder(1)
        cutscene:wait(1)

        local soul = Sprite("player/heart", SCREEN_WIDTH/2, SCREEN_HEIGHT-100)
        soul.color={1, 0, 0}
        --soul.rotation=math.rad(180)
        soul.layer=WORLD_LAYERS["top"]+10
        soul:setOrigin(0.5, 0.5)
        Game.world:addChild(soul)
        Game.world.timer:everyInstant(0.1, function()
            local image=AfterImage(soul, 0.5)
            image.graphics.grow=0.3
            Game.world:addChild(image)
        end, 3)
        Assets.playSound("snd_great_shine")
        cutscene:wait(2.5)
        Game.world.timer:tween(6, soul, {y=150})
        cutscene:wait(7)
        Assets.playSound("snd_revival")
        Game.world.timer:everyInstant(0.1, function()
            local image=AfterImage(soul, 0.5)
            image.graphics.grow=0.3
            Game.world:addChild(image)
        end, 3)
        local tab={}
        for i=0, 4 do
            local s=Rectangle(soul.x, soul.y, 1, 999)
            s:setOrigin(0.5, 0.5)
            s.color={1-0.1*i, 1-0.1*i, 1-0.1*i}
            s.layer=soul.layer-(1+i)
            s.graphics.grow=7+4*i
            tab[i+1]=s
            Game.world:addChild(s)
        end
        cutscene:wait(2)
        Game.world.timer:tween(1, soul, {alpha=0}, "linear", function()
            soul:remove()
        end)
        cutscene:wait(3)
        for i=1, 3 do
            Game.world.timer:tween(1, tab[i], {alpha=0}, "linear", function()
                tab[i]:remove()
            end)
        end
        cutscene:wait(2)
        Kristal.showBorder(1)
        cutscene:fadeIn(1)
        cutscene:mapTransition("computer_lab")
        cutscene:endCutscene()
    end,
    killkill=function(cutscene)
        local kris   = Game.world:spawnNPC("kris_lw", Game.world.map.markers["kris"].x, Game.world.map.markers["kris"].y, {facing="up"})
        local susie  = Game.world:spawnNPC("susie_lw", Game.world.map.markers["susie"].x, Game.world.map.markers["susie"].y, {facing="up"})
        local noelle = Game.world:spawnNPC("noelle_lw", 417, 226, {facing="down"})
        noelle:setLayer(Game.world:getEvent(3).layer+1)
        noelle:setSprite("desk/desk_sleep")

        cutscene:wait(3)

        Assets.playSound("phone")
        noelle:setSprite("desk/desk_wake_up_left")

        cutscene:wait(1)

        Assets.playSound("phone")

        cutscene:wait(1)

        Assets.playSound("phone")

        cutscene:wait(1)

        cutscene:text("* ...", "nervous_side", "susie")

        Assets.playSound("phone")

        cutscene:wait(1)

        Assets.playSound("phone")
        noelle:setSprite("desk/desk_wake_up_left")

        cutscene:wait(1)

        cutscene:text("* H-Huh?[wait:1] Berdly's...[wait:1] alarm...?", "shock_b", "noelle")
        cutscene:text("* A dream...?[wait:1] It was really just a...", "smile_closed", "noelle")

        noelle:setSprite("desk/desk_shocked")
        noelle:shake(4)

        cutscene:wait(1.5)

        cutscene:text("* Su-[wait:0.5]Susie?!", "shock", "noelle")
        cutscene:text("* He-[wait:0.5]Hey,[wait:1] Susie...![wait:1] What...[wait:1] are you doing here?", "surprise_smile", "noelle")
        cutscene:text("* Uh...[wait:1] You invited us to study,[wait:1] remember?", "nervous", "susie")
        noelle:setSprite("desk/desk_awake")
        cutscene:text("* O-[wait:0.5]Oh,[wait:1] right,[wait:1] I did that.[wait:1] Haha...[wait:1] Ha...", "smile_closed", "noelle")
        cutscene:text("* ...Noelle,[wait:1] are you okay?", "nervous", "susie")
        cutscene:text("* You're,[wait:1] uh,[wait:1] sweating bullets.", "nervous_side", "susie")
        cutscene:text("* A-[wait:0.5]Ah![wait:1] Well,[wait:1] uhm...", "surprise_frown", "noelle")
        cutscene:text("* I just had a nightmare!", "surprise_smile", "noelle")
        cutscene:text("* A very bad one...", "down", "noelle")
        cutscene:text("* ...", "annoyed_down", "susie")
        cutscene:text("* So,[wait:1] uh...", "neutral", "susie")
        cutscene:text("* What...[wait:1] happened?", "neutral_side", "susie")
        noelle:setSprite("desk/desk_shocked")
        noelle:shake(4)
        cutscene:text("* A-[wait:0.5]AH WELL,[wait:1] Uhm,[wait:1] you see ---", "afraid", "noelle")
        noelle:setSprite("desk/desk_awake_left")
        cutscene:text("* H-[wait:0.5]HEY BERDLY![wait:1] It's time to g-[wait:0.5]go!", "silly", "noelle")

        cutscene:wait(2)

        noelle:setSprite("desk/desk_awake_left_unhappy")
        cutscene:text("* ...Be-[wait:0.5]Berdly...?", "surprise_smile", "noelle")

        cutscene:wait(2)

        cutscene:wait(cutscene:slideTo(noelle, noelle.x-40, noelle.y, 0.15))
        cutscene:wait(0.25)
        noelle:setSprite("walk_books")
        noelle:setLayer(0.15)
        Game.world:getEvent(6):remove()
        Game.world:getEvent(7):remove()
        cutscene:wait(cutscene:slideTo(noelle, noelle.x, noelle.y-40, 0.15))

        cutscene:text("* W-[wait:0.5]Wow,[wait:1] Berdly,[wait:1] you've been studying too much,[wait:1] haha.", "smile_closed", "noelle")
        cutscene:text("* Maybe it's good for you to continue to sleep.", "smile_side", "noelle")
        cutscene:text("* Sweet dreams!", "smile_closed", "noelle")

        cutscene:wait(cutscene:walkToSpeed(noelle, 550, noelle.y, 8))
        cutscene:look(kris, "right")
        cutscene:look(susie, "right")
        cutscene:wait(cutscene:walkToSpeed(noelle, noelle.x, 380, 8))
        noelle:setLayer(0.2)
        Game.world.timer:after(0.20, function() noelle:setLayer(susie.layer) end)
        cutscene:wait(cutscene:walkToSpeed(noelle, 330, noelle.y, 8, "up"))
        cutscene:look(kris, "down")
        cutscene:look(susie, "down")

        cutscene:wait(0.5)
        cutscene:setTextboxTop(true)

        cutscene:text("* A-[wait:0.5]And, Su-[wait:0.5]Susie... Do you... Uhm...", "confused_surprise_b", "noelle")
        cutscene:text("* What?", "neutral_side", "susie")
        cutscene:text("* Ne-[wait:0.5]Nevermind![wait:1] Bye Susie![wait:1] Bye Kris!", "surprise_smile", "noelle")
        cutscene:wait(cutscene:walkToSpeed(noelle, noelle.x, noelle.y+300, 8))
        cutscene:wait(1.5)

        cutscene:look(kris, "left")
        cutscene:look(susie, "right")
        cutscene:text("* Well that was weird.", "neutral_side", "susie")
        cutscene:text("* H-[wait:0.5]Hey![wait:1] Don't look at me like that!", "shy_b", "susie")
        cutscene:text("* I didn't do anything to her!!", "shy_b", "susie")
        cutscene:text("* Just gather everything and let's go!", "shy", "susie")

        cutscene:wait(cutscene:walkToSpeed(susie, 320, susie.y, 8))
        cutscene:wait(0.15)
        Game.world.timer:after(0.20, function() cutscene:look(kris, "down") end)
        cutscene:wait(cutscene:walkToSpeed(susie, susie.x, susie.y+400, 8))

        cutscene:wait(1)

        cutscene:fadeOut(2)
        cutscene:wait(2)

        cutscene:wait(2)

        local CutMusic = Music("flashback_excerpt")
        CutMusic.pitch = 0.3

        cutscene:text("* What the hell was that?", "","susie")
        cutscene:text("* If I didn't stop myself back there...", "", "susie")
        cutscene:text("* Noelle would have been...", "", "susie")
        cutscene:text("* ...", "", "susie")
        cutscene:text("* Now that I think about it,[wait:0.5] Kris looked so weird when we reunited.", "", "susie")
        cutscene:text("* Like something terrible just happened.", "", "susie")
        cutscene:text("* Could it be that...?", "", "susie")
        cutscene:text("* ...Well I sure hope not.", "", "susie")
        cutscene:text("* It's fucking terrifying...", "", "susie")
        CutMusic:stop()
        cutscene:text("[speed:0.75]* When your choices don't matter anymore.", "", "susie")

        Assets.playSound("snd_dooropen")

        cutscene:wait(1)

        cutscene:text("* ... Man, it got late, didn't it...?", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* ... guess you should go home, huh?", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* Alright, you don't have to say it.", nil, "susie")
        cutscene:text("* Don't wanna walk home by yourself, huh?", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* Well, if you're going to MAKE me, I guess...", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* Let's go.", nil, "susie")

        cutscene:gotoCutscene("CREDITS")
    end,
    killspare=function(cutscene)
        local kris   = Game.world:spawnNPC("kris_lw", Game.world.map.markers["kris"].x, Game.world.map.markers["kris"].y, {facing="up"})
        local susie  = Game.world:spawnNPC("susie_lw", Game.world.map.markers["susie"].x, Game.world.map.markers["susie"].y, {facing="up"})
        local noelle = Game.world:spawnNPC("noelle_lw", 417, 226, {facing="down"})
        noelle:setLayer(Game.world:getEvent(3).layer+1)
        noelle:setSprite("desk/desk_sleep")

        cutscene:wait(3)

        Assets.playSound("phone")
        noelle:setSprite("desk/desk_wake_up_left")

        cutscene:wait(1)

        Assets.playSound("phone")

        cutscene:wait(1)

        cutscene:text("* H-Huh?[wait:1] Berdly's...[wait:1] alarm...?", "shock_b", "noelle")
        cutscene:text("* A dream...?[wait:1] It was really just a...", "smile_closed", "noelle")

        noelle:setSprite("desk/desk_shocked")
        noelle:shake(4)

        cutscene:wait(1.5)

        cutscene:text("* Su-[wait:0.5]Susie?!", "shock", "noelle")
        cutscene:text("* He-[wait:0.5]Hey,[wait:1] Susie...![wait:1] What...[wait:1] are you doing here?", "surprise_smile", "noelle")
        cutscene:text("* Uh...[wait:1] You invited us to study,[wait:1] remember?", "nervous", "susie")
        noelle:setSprite("desk/desk_awake")
        cutscene:text("* O-[wait:0.5]Oh,[wait:1] right,[wait:1] I did that.[wait:1] Haha...[wait:1] Ha...", "smile_closed", "noelle")
        cutscene:text("* ...Noelle,[wait:1] are you okay?", "nervous", "susie")
        cutscene:text("* You're,[wait:1] uh,[wait:1] sweating bullets.", "nervous_side", "susie")
        cutscene:text("* A-[wait:0.5]Ah![wait:1] Well,[wait:1] uhm...", "surprise_frown", "noelle")
        cutscene:text("* I just had a nightmare!", "surprise_smile", "noelle")
        cutscene:text("* A very bad one...", "down", "noelle")
        cutscene:text("* ...", "annoyed_down", "susie")
        cutscene:text("* So,[wait:1] uh...", "neutral", "susie")
        cutscene:text("* What...[wait:1] happened?", "neutral_side", "susie")
        noelle:setSprite("desk/desk_shocked")
        noelle:shake(4)
        cutscene:text("* A-[wait:0.5]AH WELL,[wait:1] Uhm,[wait:1] you see ---", "afraid", "noelle")
        noelle:setSprite("desk/desk_awake_left")
        cutscene:text("* H-[wait:0.5]HEY BERDLY![wait:1] It's time to g-[wait:0.5]go!", "silly", "noelle")

        cutscene:wait(2)

        noelle:setSprite("desk/desk_awake_left_unhappy")
        cutscene:text("* ...Be-[wait:0.5]Berdly...?", "surprise_smile", "noelle")

        cutscene:wait(2)

        cutscene:wait(cutscene:slideTo(noelle, noelle.x-40, noelle.y, 0.15))
        cutscene:wait(0.25)
        noelle:setSprite("walk_books")
        noelle:setLayer(0.15)
        Game.world:getEvent(6):remove()
        Game.world:getEvent(7):remove()
        cutscene:wait(cutscene:slideTo(noelle, noelle.x, noelle.y-40, 0.15))

        cutscene:text("* W-[wait:0.5]Wow,[wait:1] Berdly,[wait:1] you've been studying too much,[wait:1] haha.", "smile_closed", "noelle")
        cutscene:text("* Maybe it's good for you to continue to sleep.", "smile_side", "noelle")
        cutscene:text("* Sweet dreams!", "smile_closed", "noelle")

        cutscene:wait(cutscene:walkToSpeed(noelle, 550, noelle.y, 8))
        cutscene:look(kris, "right")
        cutscene:look(susie, "right")
        cutscene:wait(cutscene:walkToSpeed(noelle, noelle.x, 380, 8))
        noelle:setLayer(0.2)
        Game.world.timer:after(0.20, function() noelle:setLayer(susie.layer) end)
        cutscene:wait(cutscene:walkToSpeed(noelle, 330, noelle.y, 8, "up"))
        cutscene:look(kris, "down")
        cutscene:look(susie, "down")

        cutscene:wait(0.5)
        cutscene:setTextboxTop(true)

        cutscene:text("* A-[wait:0.5]And, Su-[wait:0.5]Susie... Do you... Uhm...", "confused_surprise_b", "noelle")
        cutscene:text("* Wh... What are you doing?", "nervous_side", "susie")
        cutscene:text("* Yo... You don't have a tail, do you, Susie?", "smile_closed", "noelle")
        cutscene:text("* H-Huh!? N-No way, of course not!", "teeth_b", "susie")
        cutscene:text("* Really? That's great!", "smile_closed", "noelle")
        noelle:setSprite("walk_books")
        cutscene:wait(cutscene:walkToSpeed(noelle, noelle.x, noelle.y+300, 8))
        cutscene:wait(1.5)
        cutscene:wait(cutscene:walkToSpeed(noelle, noelle.x, noelle.y+300, 8))
        cutscene:wait(1.5)

        cutscene:look(kris, "left")
        cutscene:look(susie, "right")
        cutscene:text("* Well that was weird.", "neutral_side", "susie")
        cutscene:text("* H-[wait:0.5]Hey![wait:1] Don't look at me like that!", "shy_b", "susie")
        cutscene:text("* I didn't do anything to her!!", "shy_b", "susie")
        cutscene:text("* Just gather everything and let's go!", "shy", "susie")

        cutscene:wait(cutscene:walkToSpeed(susie, 320, susie.y, 8))
        cutscene:wait(0.15)
        Game.world.timer:after(0.20, function() cutscene:look(kris, "down") end)
        cutscene:wait(cutscene:walkToSpeed(susie, susie.x, susie.y+400, 8))

        cutscene:wait(1)

        cutscene:fadeOut(2)
        cutscene:wait(2)

        cutscene:wait(2)

        local CutMusic = Music("flashback_excerpt")
        CutMusic.pitch = 0.3

        cutscene:text("* What the hell was that?", "","susie")
        cutscene:text("* It's a good thing I managed to spare her..", "", "susie")
        cutscene:text("* Otherwise, Noelle would have been...", "", "susie")
        cutscene:text("* ...", "", "susie")
        cutscene:text("* Now that I think about it,[wait:0.5] Kris looked so weird when we reunited.", "", "susie")
        cutscene:text("* Like something terrible just happened.", "", "susie")
        cutscene:text("* Could it be that...?", "", "susie")
        cutscene:text("* ...Well I sure hope not.", "", "susie")
        cutscene:text("* 'cause it kinda felt like...", "", "susie")
        CutMusic:stop()
        cutscene:text("[speed:0.75]* My choices had stop mattering.", "", "susie")

        Assets.playSound("snd_dooropen")

        cutscene:wait(1)

        cutscene:text("* ... Man, it got late, didn't it...?", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* ... guess you should go home, huh?", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* Alright, you don't have to say it.", nil, "susie")
        cutscene:text("* Don't wanna walk home by yourself, huh?", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* Well, if you're going to MAKE me, I guess...", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* Let's go.", nil, "susie")

        cutscene:gotoCutscene("CREDITS")
    end,
    thorn_kill=function(cutscene)
        local kris   = Game.world:spawnNPC("kris_lw", Game.world.map.markers["kris"].x, Game.world.map.markers["kris"].y, {facing="up"})
        local susie  = Game.world:spawnNPC("susie_lw", Game.world.map.markers["susie"].x, Game.world.map.markers["susie"].y, {facing="up"})
        local noelle = Game.world:spawnNPC("noelle_lw", 417, 226, {facing="down"})
        noelle:setLayer(Game.world:getEvent(3).layer+1)
        noelle:setSprite("desk/desk_sleep")

        cutscene:wait(3)

        Assets.playSound("phone")
        noelle:setSprite("desk/desk_wake_up_left")

        cutscene:wait(1)

        Assets.playSound("phone")

        cutscene:wait(1)

        cutscene:text("* H-Huh?[wait:1] Berdly's...[wait:1] alarm...?", "shock_b", "noelle")
        cutscene:text("* A dream...?[wait:1] It was really just a...", "smile_closed", "noelle")

        noelle:setSprite("desk/desk_shocked")
        noelle:shake(4)

        cutscene:wait(1.5)

        cutscene:text("* Susie?!", "shock", "noelle")
        cutscene:text("* Susie![wait:1] What are you doing here?", "blush_question", "noelle")
        cutscene:text("* Uhh...", "nervous", "susie")
        cutscene:text("* You invited us to study,[wait:1] remember?", "smirk", "susie")
        noelle:setSprite("desk/desk_awake")
        cutscene:text("* Oh,[wait:1] right![wait:1] I did, didn't I?[wait:1] Haha!", "smile_closed", "noelle")
        cutscene:text("* ... uhh,[wait:1] you're in a good mood.", "nervous", "susie")
        cutscene:text("* Did you, uh, have a good dream?", "small_smile", "susie")
        cutscene:text("* It was a nightmare.", "smile_closed", "noelle")
        cutscene:text("* Hm.", "neutral_side", "susie")
        cutscene:text("* I'm... just happy I woke up.", "sad_smile_b", "noelle")
        cutscene:text("* ...", "nervous_side", "susie")
        cutscene:text("* The... end was nice, though.", "blush_smile", "noelle")
        cutscene:text("* What happened?", "surprise_smile", "susie")
        noelle:setSprite("desk/desk_shocked")
        noelle:shake(4)
        cutscene:text("* HAHA, well, umm ---", "blush_big_smile", "noelle")
        noelle:setSprite("desk/desk_awake_left")
        cutscene:text("* HAHA HEY, Berdly time to get up and go!", "blush_surprise_smile", "noelle")

        cutscene:wait(1.3)

        noelle:setSprite("desk/desk_awake_left_unhappy")
        cutscene:text("* ...Berdly?", "frown", "noelle")

        cutscene:wait(1.3)

        cutscene:wait(cutscene:slideTo(noelle, noelle.x-40, noelle.y, 0.15))
        cutscene:wait(0.25)
        noelle:setSprite("walk_books")
        noelle:setLayer(0.15)
        Game.world:getEvent(6):remove()
        Game.world:getEvent(7):remove()
        Assets.playSound("wing")
        cutscene:wait(cutscene:slideTo(noelle, noelle.x, noelle.y-40, 0.15))

        cutscene:text("* Gosh,[wait:1] you've been studying too much,[wait:1] Berdly.", "smile_closed", "noelle")
        cutscene:text("* Honestly, you deserve a little rest, y'know?", "smile_side", "noelle")
        cutscene:text("* Sweet dreams!", "smile_closed", "noelle")

        cutscene:wait(cutscene:walkToSpeed(noelle, 550, noelle.y, 8))
        cutscene:look(kris, "right")
        cutscene:look(susie, "right")
        cutscene:wait(cutscene:walkToSpeed(noelle, noelle.x, 380, 8))
        noelle:setLayer(0.2)
        Game.world.timer:after(0.20, function() noelle:setLayer(susie.layer) end)
        cutscene:wait(cutscene:walkToSpeed(noelle, 330, noelle.y, 8, "up"))
        cutscene:look(kris, "down")
        cutscene:look(susie, "down")
        noelle:setAnimation({"head_tilt", 0.35, false})
        cutscene:wait(1.5)

        cutscene:setTextboxTop(true)

        cutscene:text("* Wh... What are you doing?", "nervous_side", "susie")
        cutscene:text("* You don't have a tail, do you, Susie?", "smile", "noelle")
        cutscene:text("* H-Huh!? N-No way, of course not!", "teeth_b", "susie")
        cutscene:text("* Really? That's great!", "smile_closed", "noelle")
        noelle:setSprite("walk_books")
        cutscene:wait(cutscene:walkToSpeed(noelle, noelle.x, noelle.y+300, 8))
        cutscene:wait(1.5)

        cutscene:look(kris, "left")
        cutscene:look(susie, "right")
        cutscene:text("* That was weird,[wait:1] Kris.", "neutral_side", "susie")
        cutscene:text("* Somehow, it doesn't feel like we just saved the world...", "sus_nervous", "susie")
        cutscene:wait(0.2)
        susie:shake(5)
        susie:setSprite("shocked")
        cutscene:wait(1)
        susie:setSprite("shake")
        susie:play(1/12)
        kris.visible=false
        susie.flip_x=true
        susie.x=susie.x+10
        cutscene:text("* KRIS!! Hey, wait a sec, Kris!!", "shock_down", "susie")
        cutscene:text("* We... We just actually saved the world, didn't we!?", "shy_b", "susie")
        cutscene:text("* Damn, we really are heroes!", "shy_b", "susie")
        cutscene:text("* And no one even knows!", "shy", "susie")
        kris.visible=true
        susie.flip_x=false
        susie.x=susie.x-10
        susie:setSprite("walk")
        cutscene:look(susie, "down")
        cutscene:text("* ... guess it's better that way though, right?", "shy_down", "susie")
        cutscene:look(susie, "right")
        cutscene:text("* People'd freak out if they knew the world's in danger.", "shy_b", "susie")
        susie:setSprite("scratch")
        susie:play(1/6)
        cutscene:text("* And Noelle...", "smirk", "susie")
        cutscene:wait(0.5)
        susie.sprite:stop()
        cutscene:text("* Maybe it's better if she forgets, too...", "shy_down", "susie")
        cutscene:text("* ...", "neutral", "susie")
        susie:setSprite("walk")
        cutscene:text("* Whatever, let's get out of here.", "neutral_side", "susie")
        cutscene:wait(cutscene:walkToSpeed(susie, 320, susie.y, 8))
        cutscene:wait(0.15)
        Game.world.timer:after(0.20, function() cutscene:look(kris, "down") end)
        cutscene:wait(cutscene:walkToSpeed(susie, susie.x, susie.y+400, 8))

        cutscene:wait(1)

        cutscene:fadeOut(2)
        cutscene:wait(2)

        cutscene:wait(2)

        local CutMusic = Music("flashback_excerpt")
        CutMusic.pitch = 0.3

        cutscene:text("* Man, that was weird...", "","susie")
        cutscene:text("* Noelle always acted weird, but that's on another level.", "", "susie")
        cutscene:text("* And even then, where did she even get that thing she was wearing??", "", "susie")
        cutscene:text("* Does she like pain or something??", "", "susie")
        cutscene:text("* ...", "", "susie")
        cutscene:text("* Now that I think about it,[wait:0.5] Kris looked so weird when we reunited.", "", "susie")
        cutscene:text("* Like something terrible just happened.", "", "susie")
        cutscene:text("* Could it be that...?", "", "susie")
        cutscene:text("* ...well I sure hope not.", "", "susie")
        cutscene:text("* Kris and Noelle are childhood pals, right?", "", "susie")
        CutMusic:stop()
        cutscene:text("* I don't believe Kris would give something like that to their friend.", "", "susie")

        Assets.playSound("snd_dooropen")

        cutscene:wait(1)

        cutscene:text("* ... Man, it got late, didn't it...?", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* ... guess you should go home, huh?", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* Alright, you don't have to say it.", nil, "susie")
        cutscene:text("* Don't wanna walk home by yourself, huh?", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* Well, if you're going to MAKE me, I guess...", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* Let's go.", nil, "susie")

        cutscene:gotoCutscene("CREDITS")
    end,
    no_trance=function(cutscene)
        local kris   = Game.world:spawnNPC("kris_lw", Game.world.map.markers["kris"].x, Game.world.map.markers["kris"].y, {facing="up"})
        local susie  = Game.world:spawnNPC("susie_lw", Game.world.map.markers["susie"].x, Game.world.map.markers["susie"].y, {facing="up"})
        local noelle = Game.world:spawnNPC("noelle_lw", 417, 226, {facing="down"})
        noelle:setLayer(Game.world:getEvent(3).layer+1)
        noelle:setSprite("desk/desk_sleep")

        cutscene:wait(3)

        Assets.playSound("phone")
        noelle:setSprite("desk/desk_wake_up_left")

        cutscene:wait(1)

        Assets.playSound("phone")

        cutscene:wait(1)

        cutscene:text("* H-Huh?[wait:1] Berdly's...[wait:1] alarm...?", "shock_b", "noelle")
        cutscene:text("* A dream...?[wait:1] It was really just a...", "smile_closed", "noelle")

        noelle:setSprite("desk/desk_shocked")
        noelle:shake(4)

        cutscene:wait(1.5)

        cutscene:text("* Susie?!", "shock", "noelle")
        cutscene:text("* Susie![wait:1] What are you doing here?", "blush_question", "noelle")
        cutscene:text("* Uhh...", "nervous", "susie")
        cutscene:text("* You invited us to study,[wait:1] remember?", "smirk", "susie")
        noelle:setSprite("desk/desk_awake")
        cutscene:text("* Oh,[wait:1] right![wait:1] I did, didn't I?[wait:1] Haha!", "smile_closed", "noelle")
        cutscene:text("* ... uhh,[wait:1] you're in a good mood.", "nervous", "susie")
        cutscene:text("* Did you, uh, have a good dream?", "small_smile", "susie")
        cutscene:text("* It was a nightmare.", "smile_closed", "noelle")
        cutscene:text("* Hm.", "neutral_side", "susie")
        cutscene:text("* I'm... just happy I woke up.", "sad_smile_b", "noelle")
        cutscene:text("* ...", "nervous_side", "susie")
        cutscene:text("* The... end was nice, though.", "blush_smile", "noelle")
        cutscene:text("* What happened?", "surprise_smile", "susie")
        noelle:setSprite("desk/desk_shocked")
        noelle:shake(4)
        cutscene:text("* HAHA, well, umm ---", "blush_big_smile", "noelle")
        noelle:setSprite("desk/desk_awake_left")
        cutscene:text("* HAHA HEY, Berdly time to get up and go!", "blush_surprise_smile", "noelle")

        cutscene:wait(1.3)

        noelle:setSprite("desk/desk_awake_left_unhappy")
        cutscene:text("* ...Berdly?", "frown", "noelle")

        cutscene:wait(1.3)

        cutscene:wait(cutscene:slideTo(noelle, noelle.x-40, noelle.y, 0.15))
        cutscene:wait(0.25)
        noelle:setSprite("walk_books")
        noelle:setLayer(0.15)
        Game.world:getEvent(6):remove()
        Game.world:getEvent(7):remove()
        Assets.playSound("wing")
        cutscene:wait(cutscene:slideTo(noelle, noelle.x, noelle.y-40, 0.15))

        cutscene:text("* Gosh,[wait:1] you've been studying too much,[wait:1] Berdly.", "smile_closed", "noelle")
        cutscene:text("* Honestly, you deserve a little rest, y'know?", "smile_side", "noelle")
        cutscene:text("* Sweet dreams!", "smile_closed", "noelle")

        cutscene:wait(cutscene:walkToSpeed(noelle, 550, noelle.y, 8))
        cutscene:look(kris, "right")
        cutscene:look(susie, "right")
        cutscene:wait(cutscene:walkToSpeed(noelle, noelle.x, 380, 8))
        noelle:setLayer(0.2)
        Game.world.timer:after(0.20, function() noelle:setLayer(susie.layer) end)
        cutscene:wait(cutscene:walkToSpeed(noelle, 330, noelle.y, 8, "up"))
        cutscene:look(kris, "down")
        cutscene:look(susie, "down")
        noelle:setAnimation({"head_tilt", 0.35, false})
        cutscene:wait(1.5)

        cutscene:setTextboxTop(true)

        cutscene:text("* Wh... What are you doing?", "nervous_side", "susie")
        cutscene:text("* You don't have a tail, do you, Susie?", "smile", "noelle")
        cutscene:text("* H-Huh!? N-No way, of course not!", "teeth_b", "susie")
        cutscene:text("* Really? That's great!", "smile_closed", "noelle")
        noelle:setSprite("walk_books")
        cutscene:wait(cutscene:walkToSpeed(noelle, noelle.x, noelle.y+300, 8))
        cutscene:wait(1.5)

        cutscene:look(kris, "left")
        cutscene:look(susie, "right")
        cutscene:text("* That was weird, Kris.", "neutral_side", "susie")
        cutscene:look(susie, "up")

        cutscene:wait(1)
        cutscene:text("* Kris,[wait:0.5] by the way...", "bangs_neutral", "susie")
        cutscene:look(susie, "right")
        cutscene:text("* You have a lot of explaining to do.", "neutral", "susie")
        cutscene:text("* Like, do you know who was that dude who attacked you?", "neutral_side", "susie")
        cutscene:text("* You would have been dead without me and Noelle.", "sus_nervous", "susie")
        cutscene:text("* ...", "sus_nervous", "susie")
        cutscene:text("* Well if you don't wanna talk about it..", "nervous", "susie")
        cutscene:text("* That's fine too,[wait:2] I guess.", "smirk", "susie")
        cutscene:text("* Just be more careful next time or something.", "nervous", "susie")
        cutscene:text("* In any case, let's get out of here.", "nervous", "susie")
        cutscene:wait(cutscene:walkToSpeed(susie, 320, susie.y, 8))
        cutscene:wait(0.15)
        Game.world.timer:after(0.20, function() cutscene:look(kris, "down") end)
        cutscene:wait(cutscene:walkToSpeed(susie, susie.x, susie.y+400, 8))

        cutscene:wait(1)

        cutscene:fadeOut(2)
        cutscene:wait(2)

        cutscene:wait(2)

        local CutMusic = Music("flashback_excerpt")
        CutMusic.pitch = 0.3

        cutscene:text("* Man, that was confusing.", "","susie")
        cutscene:text("* This voice,[wait:2] Noelle,[wait:2] this giant puppet...", "", "susie")
        cutscene:text("* What kind of shady stuff is going on with Kris?", "", "susie")
        cutscene:text("* ...", "", "susie")
        cutscene:text("* Now that I think about it,[wait:0.5] Kris looked so weird when we reunited.", "", "susie")
        cutscene:text("* Like something terrible just happened.", "", "susie")
        cutscene:text("* Does it have something to do with Noelle?", "", "susie")
        cutscene:text("* ...", "", "susie")
        cutscene:text("* Eh, whatever.", "", "susie")
        cutscene:text("* I believe in Kris.[wait:2] Whatever's going on..", "", "susie")
        cutscene:text("* I'm sure they'll find a way arou-", "", "susie")
        CutMusic:stop()

        Assets.playSound("snd_dooropen")

        cutscene:wait(0.5)

        cutscene:text("* Damn, Kris! I didn't hear you arrive!", "", "susie")
        cutscene:text("* Yo-You didn't hear anything just now, right?", "", "susie")
        cutscene:text("* Why?[wait:0.5] No reason!", "", "susie")
        cutscene:wait(0.5)
        cutscene:text("* ... In any case, it got late, didn't it...?", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* ... guess you should go home, huh?", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* Alright, you don't have to say it.", nil, "susie")
        cutscene:text("* Don't wanna walk home by yourself, huh?", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* Well, if you're going to MAKE me, I guess...", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* Let's go.", nil, "susie")

        cutscene:wait(1)

        cutscene:text("* Uh?", "", "susie")
        cutscene:text("* What are you saying Kris?", "", "susie")
        cutscene:text("* He was...", "", "susie")
        cutscene:text("* A big shot...?", "", "susie")

        cutscene:gotoCutscene("CREDITS")
    end,
    iceshock=function(cutscene)
        local kris   = Game.world:spawnNPC("kris_lw", Game.world.map.markers["kris"].x, Game.world.map.markers["kris"].y, {facing="up"})
        local susie  = Game.world:spawnNPC("susie_lw", Game.world.map.markers["susie"].x, Game.world.map.markers["susie"].y, {facing="up"})
        local noelle = Game.world:spawnNPC("noelle_lw", 417, 226, {facing="down"})
        noelle:setLayer(Game.world:getEvent(3).layer+1)
        noelle:setSprite("desk/desk_sleep")

        cutscene:wait(3)

        Assets.playSound("phone")
        noelle:setSprite("desk/desk_wake_up_left")

        cutscene:wait(1)

        Assets.playSound("phone")

        cutscene:wait(1)

        cutscene:text("* H-Huh?[wait:1] Berdly's...[wait:1] alarm...?", "shock_b", "noelle")
        cutscene:text("* A dream...?[wait:1] It was really just a...", "smile_closed", "noelle")

        noelle:setSprite("desk/desk_shocked")
        noelle:shake(4)

        cutscene:wait(1.5)

        cutscene:text("* Susie?!", "shock", "noelle")
        cutscene:text("* Susie![wait:1] What are you doing here?", "blush_question", "noelle")
        cutscene:text("* Uhh...", "nervous", "susie")
        cutscene:text("* You invited us to study,[wait:1] remember?", "smirk", "susie")
        noelle:setSprite("desk/desk_awake")
        cutscene:text("* Oh,[wait:1] right![wait:1] I did, didn't I?[wait:1] Haha!", "smile_closed", "noelle")
        cutscene:text("* ... uhh,[wait:1] you're in a good mood.", "nervous", "susie")
        cutscene:text("* Did you, uh, have a good dream?", "small_smile", "susie")
        cutscene:text("* It was a nightmare.", "smile_closed", "noelle")
        cutscene:text("* Oh.", "surprise", "susie")
        cutscene:text("* I'm... just happy I woke up.", "sad_smile_b", "noelle")
        cutscene:text("* ...", "annoyed_down", "susie")
        cutscene:text("* ...", "sad_smile", "noelle")
        cutscene:look(susie, "right")
        cutscene:text("* By the way,[wait:1] did you guys turn on the AC or something?", "neutral", "susie")
        cutscene:text("* I feel so cold, like I just came out of a fridge.", "neutral_side", "susie")
        cutscene:text("* What?[wait:1] Cold like you just...", "question", "noelle")
        noelle:setSprite("desk/desk_shocked")
        noelle:shake(4)
        cutscene:wait(0.7)
        cutscene:text("* A-AH, well, umm ---", "shock_b", "noelle")
        noelle:setSprite("desk/desk_awake_left")
        cutscene:look(susie, "up")
        cutscene:text("* HAHA HEY, Berdly time to get up and go!", "surprise_smile_b", "noelle")

        cutscene:wait(1.3)

        noelle:setSprite("desk/desk_awake_left_unhappy")
        cutscene:text("* ...Berdly?", "frown", "noelle")

        cutscene:wait(1.3)

        cutscene:wait(cutscene:slideTo(noelle, noelle.x-40, noelle.y, 0.15))
        cutscene:wait(0.25)
        noelle:setSprite("walk_books")
        noelle:setLayer(0.15)
        Game.world:getEvent(6):remove()
        Game.world:getEvent(7):remove()
        Assets.playSound("wing")
        cutscene:wait(cutscene:slideTo(noelle, noelle.x, noelle.y-40, 0.15))

        cutscene:text("* Go-Gosh,[wait:1] you've been studying too much,[wait:1] Berdly.", "smile_closed", "noelle")
        cutscene:text("* But it's good to just... sleep, sometimes. Yeah...", "smile_side", "noelle")
        cutscene:text("* Sweet dreams!", "smile_closed", "noelle")

        cutscene:wait(cutscene:walkToSpeed(noelle, 550, noelle.y, 8))
        cutscene:look(kris, "right")
        cutscene:look(susie, "right")
        cutscene:wait(cutscene:walkToSpeed(noelle, noelle.x, 380, 8))
        noelle:setLayer(0.2)
        Game.world.timer:after(0.20, function() noelle:setLayer(susie.layer) end)
        cutscene:wait(cutscene:walkToSpeed(noelle, 330, noelle.y, 8, "up"))
        cutscene:look(kris, "down")
        cutscene:look(susie, "down")
        noelle:setAnimation({"head_tilt", 0.35, false})
        cutscene:wait(1.5)

        cutscene:setTextboxTop(true)

        cutscene:text("* Wh... What are you doing?", "nervous_side", "susie")
        cutscene:text("* You don't have a tail, do you, Susie?", "smile", "noelle")
        cutscene:text("* H-Huh!? N-No way, of course not!", "teeth_b", "susie")
        cutscene:text("* Phew, thank you!", "smile_closed", "noelle")
        noelle:setSprite("walk_books")
        cutscene:wait(cutscene:walkToSpeed(noelle, noelle.x, noelle.y+300, 8))
        cutscene:wait(1.5)

        cutscene:look(kris, "left")
        cutscene:look(susie, "right")
        cutscene:text("* That was weird,[wait:1] Kris.", "neutral_side", "susie")
        cutscene:text("* Somehow, it doesn't feel like we just saved the world...", "sus_nervous", "susie")
        cutscene:wait(0.2)
        susie:shake(5)
        susie:setSprite("shocked")
        cutscene:wait(1)
        susie:setSprite("shake")
        susie:play(1/12)
        kris.visible=false
        susie.flip_x=true
        susie.x=susie.x+10
        cutscene:text("* KRIS!! Hey, wait a sec, Kris!!", "shock_down", "susie")
        cutscene:text("* We... We just actually saved the world, didn't we!?", "shy_b", "susie")
        cutscene:text("* Damn, we really are heroes!", "shy_b", "susie")
        cutscene:text("* And no one even knows!", "shy", "susie")
        kris.visible=true
        susie.flip_x=false
        susie.x=susie.x-10
        susie:setSprite("walk")
        cutscene:look(susie, "down")
        cutscene:text("* ... guess it's better that way though, right?", "shy_down", "susie")
        cutscene:look(susie, "right")
        cutscene:text("* People'd freak out if they knew the world's in danger.", "shy_b", "susie")
        susie:setSprite("scratch")
        susie:play(1/6)
        cutscene:text("* It just sucks Noelle has to forget too.", "smirk", "susie")
        cutscene:text("* ...", "neutral", "susie")
        susie:setSprite("walk")
        cutscene:text("* Whatever, let's get out of here.", "neutral_side", "susie")
        cutscene:wait(cutscene:walkToSpeed(susie, 320, susie.y, 8))
        cutscene:wait(0.15)
        Game.world.timer:after(0.20, function() cutscene:look(kris, "down") end)
        cutscene:wait(cutscene:walkToSpeed(susie, susie.x, susie.y+400, 8))

        cutscene:wait(1)

        cutscene:fadeOut(2)
        cutscene:wait(2)

        cutscene:wait(2)

        local CutMusic = Music("flashback_excerpt")
        CutMusic.pitch = 0.3

        cutscene:text("* Brr...[wait:1] Damn, they studied the lifehood of pinguins or what??", "","susie")
        cutscene:text("* ...[wait:1]Unless it was caused in the dark world?", "", "susie")
        cutscene:text("* Hmm...[wait:1] Everything I did before Kris sealed the fountain is blurry...", "", "susie")
        cutscene:text("* Maybe I just took a nap without realizing it?", "", "susie")
        cutscene:text("* ...", "", "susie")
        cutscene:text("* Now that I think about it,[wait:0.5] Kris looked so weird when we reunited.", "", "susie")
        cutscene:text("* Like something terrible just happened.", "", "susie")
        cutscene:text("* Could it be that...?", "", "susie")
        cutscene:text("* ...well I don't know.", "", "susie")
        cutscene:text("* If something happened between me and Noelle, I guess only she knows.", "", "susie")
        CutMusic:stop()
        cutscene:text("* I should probably ask her later.", "", "susie")

        Assets.playSound("snd_dooropen")

        cutscene:wait(1)

        cutscene:text("* ... Man, it got late, didn't it...?", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* ... guess you should go home, huh?", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* Alright, you don't have to say it.", nil, "susie")
        cutscene:text("* Don't wanna walk home by yourself, huh?", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* Well I'm still freezing but if you're going to MAKE me, I guess...", nil, "susie")
        cutscene:wait(0.75)
        cutscene:text("* Let's go.", nil, "susie")

        cutscene:gotoCutscene("CREDITS")
    end,
    snowgrave=function(cutscene)
        local kris   = Game.world:spawnNPC("kris_lw", Game.world.map.markers["kris"].x, Game.world.map.markers["kris"].y, {facing="up"})
        local susie  = Game.world:spawnNPC("susie_lw", Game.world.map.markers["susie"].x, Game.world.map.markers["susie"].y, {facing="up"})
        local noelle = Game.world:spawnNPC("noelle_lw", 417, 226, {facing="down"})
        noelle:setLayer(Game.world:getEvent(3).layer+1)
        susie:setSprite("asleep")
        susie.y=susie.y+30
        noelle:setSprite("desk/desk_sleep")

        cutscene:wait(3)

        Assets.playSound("phone")
        noelle:setSprite("desk/desk_wake_up_left")

        cutscene:wait(1)

        Assets.playSound("phone")

        cutscene:wait(1)

        cutscene:text("* H-Huh?[wait:1] Berdly's...[wait:1] alarm...?", "shock_b", "noelle")
        cutscene:text("* A dream...?[wait:1] It was really just a...", "smile_closed", "noelle")

        noelle:setSprite("desk/desk_shocked")
        noelle:shake(4)

        cutscene:wait(1.5)

        cutscene:text("* Kris?!", "shock", "noelle")
        cutscene:text("* Kris![wait:1] What are you doing here?", "blush_question", "noelle")
        noelle:setSprite("desk/desk_awake")
        cutscene:text("* Oh,[wait:1] right![wait:1] I invited you and Susie here.[wait:1] Haha!", "smile_closed", "noelle")
        noelle:setSprite("desk/desk_shocked")
        noelle:shake(4)
        cutscene:text("* Wait, you actually brought Susie too?!", "blush_big_smile", "noelle")
        cutscene:text("* Tha-Thanks, Kris, I didn't expect you to do it...", "blush_smile", "noelle")
        noelle:setSprite("desk/desk_awake")
        cutscene:text("* But uh... Is she still sleeping?", "smile_closed", "noelle")
        cutscene:text("* We might need to go soon so it might be better to wake her.", "smile", "noelle")
        cutscene:look(kris, "left")
        cutscene:wait(1)
        cutscene:text("* (She doesn't seem to be awake.)")
        cutscene:wait(0.5)
        cutscene:text("* Kris?[wait:1] What's wrong?", "question", "noelle")
        cutscene:text("* Come on, stop doing that face!", "smile_closed_b", "noelle")
        cutscene:text("* You'll almost make me believe something's wrong with Susie.", "smile_closed_b", "noelle")
        cutscene:text("* Haha...[wait:1] Ha...[wait:2] Ha...", "smile_closed", "noelle")
        cutscene:wait(1)
        noelle:setSprite("desk/desk_shocked")
        cutscene:text("* ...", "shock_b", "noelle")
        cutscene:text("* [speed:0.3]Wa...[wait:1] Wait...[wait:1] Do-Don't...", "surprise_frown_b", "noelle")
        cutscene:wait(3)
        noelle:setLayer(0.15)
        noelle:setSprite("walk_terrified")
        noelle:shake(1)
        cutscene:wait(5)
        local traumashaker = Game.world.timer:every(1, function()
            noelle:shake(0.5)
        end)
        cutscene:wait(cutscene:walkToSpeed(noelle, noelle.x, 150, 0.5, nil, true))
        cutscene:wait(0.5)
        noelle:shake(1)
        cutscene:wait(0.35)
        noelle:shake(1)
        cutscene:wait(0.25)
        noelle:shake(1)
        cutscene:wait(0.15)
        noelle:shake(1)
        cutscene:wait(0.10)
        noelle:setSprite("guilt")
        noelle:shake(5)
        Assets.playSound("wing")
        cutscene:wait(2)
        cutscene:look(kris, "down")
        cutscene:wait(5)
        cutscene:wait(cutscene:fadeOut(5))
        cutscene:wait(2)
        Assets.playSound("hurt")
        Assets.playSound("hurt")
        Game:gameOver(kris.x+kris.width/2, kris.y+kris.height/2)
    end
}