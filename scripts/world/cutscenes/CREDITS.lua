return function(cutscene)
    print("Spamton Fight: "..tostring(Game:getFlag("spamton_boss", false)))
    print("Secret Fight: "..tostring(Game:getFlag("secret_unlocked", false)))

    local Spamton = Game:getFlag("spamton_boss", false)
    local Astrogirl = Utils.random(0, 100)<10

    local yellow_text = "Can someone hear me?"
    if Spamton then
        local data
        if Kristal.hasSaveFile() then
            data = Kristal.getSaveFile()
        else
            data = Game:save()
            data.room_name = "Queen's mansion - Rooftop"
            data.room_id = "mansion_queen_prefountain"
            data.party = {"susie", "noelle"}
            data.party_data = Mod.save_party_data or data.party_data
            data.inventory = Mod.save_inventory or data.inventory
            data.flags["plot"] = 3
            data.flags["#mansion_queen_prefountain#26:used_once"] = nil
            data.playtime = Game.playtime
            data.light = false
        end
        if not Kristal.Config["canAccessSecret"] then
            Kristal.Config["canAccessSecret"] = true
            Kristal.Config["secret_unlocked"] = true
            data["is_secret_file"] = true
            --Mod.registerSecret = true
            data.room_name = ""
            Kristal.Config["secret_file_data"] = data
            Kristal.Config["secret_file_data"].id = Game.save_id
            yellow_text = "You have unlocked\nan alternative fight!"
        else
            yellow_text = "An alternative awaits you!"
        end
        Kristal.saveGame(Game.save_id, data)
    else
        if Game:getFlag("noelle_battle_status") ~= "no_trance" then
            yellow_text = "But can you save Noelle\nas fast as possible?"
        else
            yellow_text = "But can you win by doing\nas few turns as possible??"
        end
    end
    if Kristal.Config["allclear_scene"] then
        yellow_text = "Thank you for playing!"
    end
    Kristal.Config["beat_once"] = true

    Kristal.saveConfig()

    cutscene:fadeOut(0)
    cutscene:wait(2)

    Kristal.hideBorder(1)
    local theme = Music(Astrogirl and "Beeg" or "ch2_credits")
    theme.source:setLooping(false)

    local text=Text("a", 0, (SCREEN_HEIGHT/2)-100, nil, nil, {style="none", skip=false, spacing=500})
    text.align="center"
    text:setText("\n[color:yellow]FROZEN HEART[color:reset]\n\nBy\nSimbel"..(Kristal.Config["beat_once"] and "\n\n[color:#999999]Press "..Input.getText("menu").." to speed up" or ""))
    text.layer=WORLD_LAYERS["top"]
    Game.world:addChild(text)

    local wait_times={
        3.3,
        3,
        5,
        5.5,
        3.5,
        4
    }

    print("BBB")
    print(wait_times[1])
    
    for i=1,#wait_times do
        if not Spamton then
            wait_times[i]=wait_times[i]+1
        end
        if Astrogirl then
            wait_times[i]=wait_times[i]+1
        end
    end

    local speed_up = false
    local stop_speed = false
    local can_speed = true
    cutscene:during(function()
        if not speed_up then
            if not stop_speed and can_speed and Input.pressed("menu") then
                speed_up = true
            elseif stop_speed then
                theme:setPitch(Utils.approach(theme:getPitch(), 1, 1.2*DT))
            end
        else
            theme:setPitch(Utils.approach(theme:getPitch(), 6, DT))
            cutscene.wait_timer = Utils.approach(cutscene.wait_timer, 0, 5*DT)
        end
    end)

    print("AAA")
    print(wait_times[1])

    cutscene:wait(wait_times[1])

    text:setText("A fangame for\nDELTARUNE\n\nBy\nToby Fox")

    cutscene:wait(wait_times[1])

    text:setText("[color:555555]Game Engine[color:reset]\nKristal\n\nThe Kristal Team")

    cutscene:wait(wait_times[2])

    text:setText("[color:555555]Music[color:reset]\nUntil Next Time\nFlasback Excerpt\nLost Girl\nmus_mysteriousroom2\n\nToby Fox")

    cutscene:wait(wait_times[3])

    text:setText("[color:555555]Music[color:reset]\nSnowgrave\n\nNick Nitro")

    if Spamton then

        cutscene:wait(wait_times[3])

        text:setText("[color:555555]Music[color:reset]\nSnowgrave NEO\n\nShinkoNet")

        cutscene:wait(wait_times[3])

        text:setText("[color:555555]Music[color:reset]\nDeal gone wrong (Orchestral)\n\nFAYNALY\nOriginal by Toby Fox")
    end

    if Astrogirl then
        cutscene:wait(wait_times[3])

        text:setText("[color:555555]Music[color:reset]\nAstrogirl (Music Box)\n\nR3 Music Box\nOriginal by Tsukumo Sana")
    end

    cutscene:wait(wait_times[4])

    text:setText("[color:555555]Sprites[color:reset]\n\nRipped from\nDELTARUNE")

    cutscene:wait(wait_times[3])

    local lib_credits = "Queen actor, Hangplugs - Sylvi\n"
    if Spamton then
        lib_credits = lib_credits.."Yellow Soul, Spamton NEO actor, Particle System - vitellary"
    end

    text:setText("[color:555555]Librairies[color:reset]\n\n"..lib_credits)

    cutscene:wait(wait_times[3])

    text:setText("[color:555555]Betatesters[color:reset]\n\nRacckoon\nOctoBox\nGlavvrach")

    cutscene:wait(wait_times[5])

    text:setText("[color:555555]Special Thanks[color:reset]\nThe Kristal Discord server\nfor their help and feedbacks\n\nZemete and Reaper\nfor fixing many typos")

    cutscene:wait(wait_times[3])

    text:setText("[color:555555]Playing this game[color:reset]\n\n"..(Game.save_name~="PLAYER" and Game.save_name or "You"))

    can_speed = false
    if speed_up then
        speed_up = false
        stop_speed = true
    end

    cutscene:wait(wait_times[6])

    local fx = AlphaFX(0)

    text.color={1, 1, 0}
    text:addFX(fx)
    text.y=(SCREEN_HEIGHT/2)-50
    text:setText(yellow_text)
    Game.world.timer:tween(3, fx, {alpha=1})
    cutscene:wait(6)

    Game.world.timer:tween(3, fx, {alpha=0})
    cutscene:wait(5)

    --Should be useless, but...
    cutscene:wait(function()
        return not theme:isPlaying()
    end)
    
    -- Why the fuck do I need to use cutscene:after() now??
    cutscene:after(function()
        Kristal.returnToMenu()
    end, true)
end

--FROZEN HEART by Simbel
--Deltarune by Toby Fox
--Kristal Engine
--Sprites by Toby Fox
--Music by Toby Fox, ...
--Betatester, uh...
--Thanks to the helper
--The secret...?