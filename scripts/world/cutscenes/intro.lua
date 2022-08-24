return {
    goner=function(cutscene)
        love.window.setTitle("RECONTACT")
        cutscene:fadeOut(0)

        --[[local skipDialogue --NEVER try to run this code
        if canSkip then
            print("hello")
            skipDialogue = DialogueText("Press "..Input.getText("cancel").." to skip", 10, 10, {skip=false, auto_size=true})
            skipDialogue:setLayer(WORLD_LAYERS["top"] + 100)
            Game.world:addChild(skipDialogue)

            cutscene:during(function()
                if canSkip then
                    if Input.pressed("cancel") then
                        if beforeSkiptext then
                            beforeSkiptext:remove()
                        end
                        gonerMusic:remove()
                        skipDialogue:remove()
                        canSkip=nil
                        cutscene:gotoCutscene("intro.gonerSkip")
                    end
                end
            end)
        end]]

        gonerMusic=Music("AUDIO_DRONE")
        cutscene:wait(1.5)

        local function file_exists(name)
           local f = io.open(name, "r")
           return f ~= nil and io.close(f)
        end

        local function getFileLines(fileName)
            local f = io.open(fileName, "r")

            tab={}
            for l in f:lines() do
                table.insert(tab, l)
            end

            f:close()
            return tab
        end

        local function gonerText(str)
            local text = DialogueText("[speed:0.3][spacing:6][style:GONER][voice:none]" .. str, 80 * 2, 50 * 2, 640, 480, {auto_size = true})
            text.layer = WORLD_LAYERS["top"] + 100
            text.skip_speed = true
            text.parallax_x = 0
            text.parallax_y = 0
            Game.world:addChild(text)

            cutscene:wait(function() return text.done end)
            Game.world.timer:tween(1, text, {alpha = 0})
            cutscene:wait(1)
            text:remove()
        end

        local function gonerSetText(str, text)
            text.alpha=1
            text:setText("[speed:0.3][spacing:6][style:GONER][voice:none]" .. str)

            cutscene:wait(function() return text.done end)
            Game.world.timer:tween(1, text, {alpha = 0})
            cutscene:wait(1)
        end

        local function gonerChoicer(choices)
            local maxIndex=#choices
            local selected=1
            local texts={}
            for i=1,maxIndex do
                local text = Text("[style:GONER]"..choices[i], 90 * 2, (100 * 2)+35*i, 640, 480, {auto_size = true})
                text.layer = WORLD_LAYERS["top"] + 100
                text.parallax_x = 0
                text.parallax_y = 0
                text.alpha = 0
                table.insert(texts, text)
                Game.world.timer:tween(1, text, {alpha=1})
                Game.world:addChild(text)
            end

            cutscene:wait(0.5)

            local heart = Sprite("player/heart_blur")
            heart:setColor(Game:getSoulColor())
            heart.x=texts[1].x-80
            heart.alpha=0
            heart:setScale(2)
            heart:setLayer(WORLD_LAYERS["top"] + 110)
            Game.world.timer:tween(1, heart, {alpha=1})
            Game.world:addChild(heart)

            local choice=0
            local new_x, new_y=texts[selected].x-50, texts[selected].y
            local heart_x, heart_y=new_x, new_y
            local gonerMenu=true
            cutscene:during(function(cutscene)
                if gonerMenu then
                    if Input.pressed("up") then
                        selected = selected-1
                        if selected<1 then
                            selected=#choices
                        end
                        new_x, new_y=texts[selected].x-50, texts[selected].y
                    end
                    if Input.pressed("down") then
                        selected = selected+1
                        if selected>#choices then
                            selected=1
                        end
                        new_x, new_y=texts[selected].x-50, texts[selected].y
                    end

                    if Input.pressed("confirm") then
                        choice=selected
                    end

                    if (math.abs(heart_x - new_x) <= 2) then
                        heart_x = new_x
                    end
                    if (math.abs(heart_y - new_y) <= 2) then
                        heart_y = new_y
                    end

                    local HEARTDIFF = ((new_x - heart_x) * 0.3)
                    heart_x = heart_x + (HEARTDIFF * DTMULT)

                    HEARTDIFF = ((new_y - heart_y) * 0.3)
                    heart_y = heart_y + (HEARTDIFF * DTMULT)
                    heart.x, heart.y=heart_x, heart_y
                end
            end)
            cutscene:wait(function() return choice~=0 end)
            gonerMenu=false
            for i=#texts, 1, -1 do
                Game.world.timer:tween(0.75, texts[i], {alpha=0}, "linear", function() texts[i]:remove() end)
            end
            Game.world.timer:tween(0.75, heart, {alpha=0}, "linear", function() heart:remove() end)
            return choice
        end

        beforeSkiptext = DialogueText("aaa", 80 * 2, 50 * 2, 640, 480, {auto_size = true})
        beforeSkiptext.layer = WORLD_LAYERS["top"] + 100
        beforeSkiptext.skip_speed = true
        beforeSkiptext.parallax_x = 0
        beforeSkiptext.parallax_y = 0
        Game.world:addChild(beforeSkiptext)

        gonerSetText("WELCOME AGAIN.", beforeSkiptext)
        gonerText("IT SEEMS YOU ARE\nSEEKING FOR...\n[wait:20]MORE SECRETS.", beforeSkiptext)
        gonerText("SECRETS THAT\nSHOULD NOT\nEXIST.", beforeSkiptext)
        gonerText("INTERESTING.[wait:20]\nTRULY[wait:10]\nINTERESTING.", beforeSkiptext)

        beforeSkiptext:remove()
        
        cutscene:wait(0.8)

        local gFx=RecolorFX(1, 1, 1)

        gonerMusic:stop()
        cutscene:fadeOut(0.5, {music = true})
        local background = GonerBackground()
        background:addFX(gFx)
        background.layer = WORLD_LAYERS["top"]
        Game.world:addChild(background)

        if canSkip then
            canSkip=false
            Game.world.timer:tween(0.5, skipDialogue, {alpha=0}, "linear", function() skipDialogue:remove() end)
        end

        local current_os = love.system.getOS()
        oriSaves={{}, {}, {}}
        local fileFound = false
        if current_os == "Windows" then
            for i=0,2 do
                file = string.gsub(os.getenv('UserProfile'), "\\", "/").."/AppData/Local/DELTARUNE/filech2_".. i
                if file_exists(file) then
                    print("Save file "..i.." found!")
                    oriSaves[i+1]=getFileLines(file)
                    fileFound=true
                end
            end
        end

        gonerText("I THINK...[wait:20]\nWE CAN FIND AN\nARRANGEMENT.")
        gonerText("YES...[wait:40]\nI AM SURE WE CAN.")
        if fileFound then
            gonerText("BUT BEFOREHAND,[wait:20]\nI MUST ASK YOU[wait:10]\nSOMETHING IMPORTANT.")
            gonerText("I SEE YOU POSSESS\nA COPY OF DELTARUNE\nON YOUR MACHINE.")
            gonerText("FOR THE SAKE OF\nAMELIORATING YOUR\nEXPERIENCE...")
            gonerText("YOUR NAME[wait:10]\nYOUR CREATION'S NAME[wait:10]\nYOUR INVENTORY[wait:10]\nTHE PATH YOU\nHAVE CHOSEN")
            gonerText("ALL CAN BE USED\nSO YOU SHOULD FEEL...[wait:20]\n\"AT HOME.\"")
            local text = DialogueText("[speed:0.3][spacing:6][style:GONER][voice:none]DO YOU AGREE TO\nTHE USE OF YOUR\nSAVE DATA?", 80 * 2, 50 * 2, 640, 480, {auto_size = true})
            text.layer = WORLD_LAYERS["top"] + 100
            text.skip_speed = true
            text.parallax_x = 0
            text.parallax_y = 0
            Game.world:addChild(text)

            local c=gonerChoicer({"YES", "NO"})
            Game.world.timer:tween(1, text, {alpha = 0})
            cutscene:wait(1)
            text:remove()
            if c==1 then
                gonerText("EXCELLENT.")
                gonerText("NOW...")
                local text = DialogueText("[speed:0.3][spacing:6][style:GONER][voice:none]WHICH SAVE FILE\nSHOULD WE USE?", 80 * 2, 50 * 2, 640, 480, {auto_size = true})
                text.layer = WORLD_LAYERS["top"] + 100
                text.skip_speed = true
                text.parallax_x = 0
                text.parallax_y = 0
                Game.world:addChild(text)

                local t={}
                for i=1,3 do
                    if #oriSaves[i]>0 then
                        if tonumber(oriSaves[i][1468])>=1 then
                            table.insert(t, "[color:red]FILE "..i.." - "..oriSaves[i][1])
                        else
                            table.insert(t, "FILE "..i.." - "..oriSaves[i][1])
                        end
                    end
                end

                local c=gonerChoicer(t)
                Game.world.timer:tween(1, text, {alpha = 0})
                cutscene:wait(1)
                text:remove()
                Game.save_name=oriSaves[c][1]
                Game:setFlag("deltarune_data", {
                    gonername=oriSaves[c][2],
                    krisStats={
                        hp=oriSaves[c][79],
                        maxhp=oriSaves[c][80],
                        atk=oriSaves[c][81],
                        def=oriSaves[c][82],
                        mag=oriSaves[c][83],
                        weapon=oriSaves[c][85],
                        armor1=oriSaves[c][86],
                        armor2=oriSaves[c][87]
                    },
                    susieStats={
                        hp=oriSaves[c][141],
                        maxhp=oriSaves[c][142],
                        atk=oriSaves[c][143],
                        def=oriSaves[c][144],
                        mag=oriSaves[c][145],
                        weapon=oriSaves[c][147],
                        armor1=oriSaves[c][148],
                        armor2=oriSaves[c][149]
                    },
                    ralseiStats={
                        hp=oriSaves[c][203],
                        maxhp=oriSaves[c][204],
                        atk=oriSaves[c][205],
                        def=oriSaves[c][206],
                        mag=oriSaves[c][207],
                        weapon=oriSaves[c][209],
                        armor1=oriSaves[c][210],
                        armor2=oriSaves[c][211],
                    },
                    noelleStats={
                        armor1=oriSaves[c][272],
                        armor2=oriSaves[c][273]
                    },
                    jevil=oriSaves[c][832],
                    vessel={
                        head=oriSaves[c][1453],
                        body=oriSaves[c][1454],
                        legs=oriSaves[c][1455]
                    }
                })
                Game.money=oriSaves[c][11]
                Game.playtimer=oriSaves[c][3055]
                gonerText("THANK YOU.")
                gonerText("YOUR DATA HAS BEEN\nPERFECTLY ENREGISTRED\nINTO THE NEXT\nEXPERIENCE.")
                gonerText("NOW...[wait:20]\nLET'S GET BACK\nTO THE TOPIC,[wait:20]\nSHALL WE?")
            else
                gonerText("OF COURSE, OF COURSE.[wait:20]\nI UNDERSTAND.")
                gonerText("IN THAT CASE,[wait:20]\nLET'S GET TO THE\nPOINT,[wait:20] SHALL WE?")
            end
        end

        gonerText("AS YOU MAY KNOW, OUR EXPERIENCE'S CURRENT\nRESULTS ARE...")
        gonerText("EXCELLENT.[wait:20]\nVERY INTERESTING,[wait:10]\nEVEN.")
        gonerText("USING SOMEONE ELSE'S\nCHOICES TO CHANGE THE\nNATURAL TRACK OF\nTHIS WORLD IS\nFACINATING.")
        gonerText("BUT I HOPE YOU\nACKNOWLEDGE THAT\nBRINGING CHOICES\nALSO BRING\nCONSEQUENCES.")
        gonerText("CONSEQUENCES[wait:20]\nJUST[wait:20]\nFOR[wait:20]\nYOU.[wait:20]")
        gonerText("BUT I ASSUME YOU ARE\nAWARE OF THIS PART.")
        local starShow=math.random()>=0.8
        local fx=ColorMaskFX({0, 0, 0})
        local kris=Sprite("party/kris/dark/walk/down", starShow and 130 or 160, 300)
        kris:setScale(2)
        kris:setLayer(WORLD_LAYERS["top"]+100)
        kris:addFX(fx)
        kris.alpha=0
        Game.world:addChild(kris)
        local susie=Sprite("party/susie/dark/walk/down", kris.x+50, 289)
        susie:setScale(2)
        susie:setLayer(WORLD_LAYERS["top"]+100)
        susie:addFX(fx)
        susie.alpha=0
        Game.world:addChild(susie)
        local ralsei=Sprite("party/ralsei/dark/walk/down", kris.x+110, 294)
        ralsei:setScale(2)
        ralsei:setLayer(WORLD_LAYERS["top"]+100)
        ralsei:addFX(fx)
        ralsei.alpha=0
        Game.world:addChild(ralsei)
        local noelle=Sprite("party/noelle/dark/walk/down", kris.x+160, 282)
        noelle:setScale(2)
        noelle:setLayer(WORLD_LAYERS["top"]+100)
        noelle:addFX(fx)
        noelle.alpha=0
        Game.world:addChild(noelle)
        local berdly=Sprite("berdly", kris.x+210, 293)
        berdly:setScale(2)
        berdly:setLayer(WORLD_LAYERS["top"]+100)
        berdly:addFX(fx)
        berdly.alpha=0
        Game.world:addChild(berdly)
        local lancer=Sprite("lancer", kris.x+250, 302)
        lancer:setScale(2)
        lancer:setLayer(WORLD_LAYERS["top"]+100)
        lancer:addFX(fx)
        lancer.alpha=0
        Game.world:addChild(lancer)
        local starwalker
        if starShow then
            starwalker=Sprite("kristal/starwalker", kris.x+310, 300)
            starwalker:setScale(2)
            starwalker:setLayer(WORLD_LAYERS["top"]+100)
            starwalker:addFX(fx)
            starwalker.alpha=0
            Game.world:addChild(starwalker)
            Game.world.timer:tween(1, starwalker, {alpha = 1})
        end
        Game.world.timer:tween(1, kris, {alpha = 1})
        Game.world.timer:tween(1, susie, {alpha = 1})
        Game.world.timer:tween(1, ralsei, {alpha = 1})
        Game.world.timer:tween(1, noelle, {alpha = 1})
        Game.world.timer:tween(1, berdly, {alpha = 1})
        Game.world.timer:tween(1, lancer, {alpha = 1})
        Game.world.timer:tween(20, gFx, {color = {1, 0.5, 0.5}})
        gonerText("YOUR CHOICES WILL\nAFFECT EVERYONE\nAROUND YOU.")
        Game.world.timer:tween(2, lancer, {alpha = 0})
        gonerText("SOME WILL STAY IN\nBLISSFUL IGNORANCE.")
        Game.world.timer:tween(2, ralsei, {alpha = 0})
        gonerText("SOME MAY KNOW MORE\nTHAN THEY LET IT BE.")
        Game.world.timer:tween(2, berdly, {alpha = 0})
        gonerText("SOME WILL PAY THE\nPRICE FOR FACING\nAN UNKNOWN FORCE.")
        Game.world.timer:tween(2, kris, {alpha = 0})
        gonerText("SOME ARE THE DIRECT\nVICTIM OF THIS\nFORCE.")
        if starShow then
            Game.world.timer:tween(2, starwalker, {alpha = 0})
            gonerText("SOME...[wait:10]\nARE JUST THERE.")
        end
        Game.world.timer:tween(4, susie, {x = 240}, "out-cubic")
        Game.world.timer:tween(4, noelle, {x = 370}, "out-cubic")
        gonerText("AND THE LAST TWO...")
        gonerText("ONE IS A VICTIM,[wait:20]\nONE IS IGNORANT.")
        gonerText("ONE IS OBEDIANT,[wait:20]\nONE IS REBELLIOUS.")
        gonerText("SO DIFFERENT\nAND YET...[wait:20]\nSO CLOSE.")
        gonerText("HOW MUCH CAN\nTHOSE TWO INFLUENCE[wait:10]\nFATE?")
        gonerText("DOESN'T IT SOUND[wait:20]\nINTRIGING?")
        gonerText("DOESN'T IT SOUND[wait:20]\nFACINATING?")
        Game.world.timer:tween(2, gFx, {color = {1, 1, 1}})
        gonerText("...")
        gonerText("\""..string.upper(Game.save_name)..",\"")
        susie:remove()
        noelle:remove()
        background.music:stop()
        background:remove()
        love.window.setTitle("")
        cutscene:wait(1.5)

        local text = DialogueText("[speed:0.6]I hope you'll enjoy Frozen Heart.", 70, 170, 640, 480, {auto_size = true})
        text.layer = WORLD_LAYERS["top"] + 100
        text.skip_speed = false
        text.state["typing_sound"]=nil
        text.state["noskip"]=true
        text.parallax_x = 0
        text.parallax_y = 0
        Game.world:addChild(text)

        cutscene:wait(function() return text.done end)
        text:setText("[speed:0.1]Because\nsomeone\nsure\nwon't.", 250, 150)
        text.state["typing_sound"]=nil
        text.state["noskip"]=true
        local hider=Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        hider:setColor(1, 1, 1, 0)
        hider:setLayer(100000)
        Game.world:addChild(hider)
        Game.world.timer:tween(7, hider, {alpha = 1})
        cutscene:wait(8.5)
        text:remove()
        hider:remove()
        love.window.setTitle("Frozen Heart")
        love.filesystem.write("saves/frozen_heart/checkpass0", "0")
        cutscene:gotoCutscene("intro.intro")
    end,
    gonerSkip=function(cutscene)
        local function gonerText(str)
            local text = DialogueText("[speed:0.6][spacing:6][style:GONER][voice:none]" .. str, 80 * 2, 50 * 2, 640, 480, {auto_size = true})
            text.layer = WORLD_LAYERS["top"] + 100
            text.skip_speed = true
            text.parallax_x = 0
            text.parallax_y = 0
            Game.world:addChild(text)

            cutscene:wait(function() return text.done end)
            Game.world.timer:tween(1, text, {alpha = 0})
            cutscene:wait(1)
            text:remove()
        end

        cutscene:wait(1)
        gonerText("AH OF COURSE.")
        gonerText("YOU HAVE SEEN\nTHIS ALREADY,\nHAVEN'T YOU?")
        gonerText("WELL THEN.\nI SHALL BID YOU\nFAREWELL.")
        local text = DialogueText("[speed:0.1][spacing:6][style:GONER][voice:none]\""..string.upper(Game.save_name)..",\"", 80 * 2, 50 * 2, 640, 480, {auto_size = true})
        text.layer = WORLD_LAYERS["top"] + 100
        text.skip_speed = true
        text.parallax_x = 0
        text.parallax_y = 0
        Game.world:addChild(text)

        local hider=Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        hider:setColor(1, 1, 1, 0)
        hider:setLayer(100000)
        Game.world:addChild(hider)
        Game.world.timer:tween(7, hider, {alpha = 1})
        cutscene:wait(8.5)
        text:remove()
        hider:remove()
        love.window.setTitle("Frozen Heart")
        cutscene:gotoCutscene("intro.intro")
    end,
    intro=function(cutscene)
        cutscene:fadeOut(0)

        cutscene:wait(3)

        Kristal.showBorder(1)
        cutsceneMusic=Music("flashback_excerpt")
        cutscene:setSpeaker("noelle")
        cutscene:text("* The moon is so weird tonight...")
        cutscene:text("* Is there anything...[wait:1] Not weird today?")
        cutscene:text("* This place...[wait:4]\n* This Queen...[wait:8]\n* [speed:0.6]Kris...")
        cutscene:text("* Dess...")
        cutscene:text("* Would you be happy to see me stronger?")

        local susie=cutscene:getCharacter("susie")
        local noelle=cutscene:getCharacter("noelle")

        susie.y=560

        cutscene:fadeIn(0)
        Assets.playSound("snd_dooropen")
        cutscene:wait(cutscene:walkTo(susie, susie.x, 320, 1, "right"))
        cutscene:setSpeaker("susie")
        cutscene:text("* Noelle?[wait:1] I'm back!", "sincere_smile")
        cutscene:text("* Everything will soon be over.", "small_smile")
        cutscene:walkTo(susie, 540, susie.y, 1.5)
        cutscene:walkTo(noelle, noelle.x+20, noelle.y, 1.4)
        cutscene:text("* Kris will seal the fountain and then everthing-", "small_smile", nil, {auto=true, skip=false})
        noelle.actor.flip="right"
        Assets.stopAndPlaySound("alert")
        noelle.alert_icon = Sprite("effects/alert", noelle.sprite.width/2)
        noelle.alert_icon:setOrigin(0.5, 1)
        noelle.alert_icon.layer = 100
        noelle:addChild(noelle.alert_icon)
        noelle:setAnimation("cutscene_shock")
        Game.world.timer:after(0.8, function()
            noelle.alert_icon:remove()
        end)
        cutscene:panTo(635, susie.y, 0.5)
        cutscene:text("* Noelle?", "nervous")
        cutscene:text("* What are you doing?[wait:1] Weren't you sleepy or something?", "nervous_side")
        cutscene:text("* ...", "down", "noelle")
        cutscene:text("* They need me...", "sad", "noelle")
        cutscene:text("* ...Who?[wait:1] Kris?", "neutral_side")
        cutscene:text("* Kris doesn't need help.", "nervous")
        cutscene:text("* I MEAN,[wait:1] they don't need help to SEAL a fountain!", "shy_b")
        cutscene:text("* (Does Kris even do something to seal one?)", "shy")
        cutscene:text("* ...", "down", "noelle")
        cutscene:text("* ...", "nervous_side")
        cutscene:look(susie, "up")
        cutscene:text("* Noelle, look.[wait:1] It's cool that you worry about a buddy and all but...", "nervous_side")
        cutscene:look(susie, "right")
        cutscene:text("* You need to wake up.", "sincere")
        local power=0
        shakeNoelle=Game.world.timer:every(1, function()
            noelle:shake(2+power)
            if power<2 then
                power=power+0.2
            end
        end)
        cutscene:text("* Susie...", "sad_side", "noelle")
        cutscene:look(susie, "up")
        cutscene:text("* So how about we both just...[wait:1] Wait for Kris to do their thing and...", "smirk")
        cutscene:text("* Susie...", "surprise_frown_b", "noelle")
        susie:setAnimation({"away_scratch", 0.25, true})
        cutscene:text("* If you WANT me to,[wait:1] I guess I'll be okay to stay with yo-", "closed_grin")
        cutscene:look(susie, "right")
        cutscene:setSprite(susie, "shock")
        susie:shake(2)
        Game.world.timer:cancel(shakeNoelle)
        noelle:shake(4)
        cutscene:text("* Susie!", "afraid", "noelle")
        cutscene:text("* They will call!", "afraid_b", "noelle")
        cutscene:text("* MOVE OUT OF MY WAY!!", "afraid_c", "noelle")
        Game:setFlag("plot", 1)

        cutscene:startEncounter("noelle_battle", true, {{"noelle", noelle}})
        cutscene:gotoCutscene("outro."..Game:getFlag("noelle_battle_status"))
    end
}