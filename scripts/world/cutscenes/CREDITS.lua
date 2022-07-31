return function(cutscene)
    print("Spamton Fight: "..tostring(Game:getFlag("spamton_fight", false)))
    print("Secret Fight: "..tostring(Game:getFlag("secret_unlocked", false)))
    print("No heal Fight: "..tostring(Game:getFlag("no_heal", true)))
    cutscene:fadeOut(0)
    cutscene:wait(2)

    local theme = Music("ch2_credits")
    theme.source:setLooping(false)

    local text=Text("a", 0, (SCREEN_HEIGHT/2)-100, nil, nil, {style="none", skip=false, spacing=500})
    text.align="center"
    text:setText("\n[color:yellow]FROZEN HEART[color:reset]\n\nBy\nSimbel")
    text.layer=WORLD_LAYERS["top"]
    Game.world:addChild(text)

    cutscene:wait(3.3)

    text:setText("A fangame for\nDELTARUNE\n\nBy\nToby Fox")

    cutscene:wait(3.3)

    text:setText("[color:555555]Game Engine[color:reset]\nKristal\n\nThe Kristal Team")

    cutscene:wait(3)

    text:setText("[color:555555]Music[color:reset]\nUntil Next Time\nFlasback Excerpt\nLost Girl\n\nToby Fox")

    cutscene:wait(5)

    text:setText("[color:555555]Music[color:reset]\nSnowgrave\n\nNick Nitro")

    cutscene:wait(5)

    text:setText("[color:555555]Music[color:reset]\nSnowgrave NEO\n\nNetcavy")

    cutscene:wait(5)

    text:setText("[color:555555]Music[color:reset]\nDeal gone wrong Orchestral\n\nFAYNALY\nOriginal by Toby Fox")

    cutscene:wait(5.5)

    text:setText("[color:555555]Sprites[color:reset]\n\nRipped from\nDELTARUNE")

    cutscene:wait(5)

    text:setText("[color:555555]Procrastination[color:reset]\n\nMyself")

    cutscene:wait(5)

    text:setText("[color:555555]Betatesters[color:reset]\n\nNo one :')")

    cutscene:wait(3.5)

    text:setText("[color:555555]Special Thanks[color:reset]\nThe Kristal Discord server for their help")

    cutscene:wait(5)

    text:setText("[color:555555]Playing this game[color:reset]\n\n"..(Game.save_name~="PLAYER" and Game.save_name or "You"))

    cutscene:wait(4)

    local fx = AlphaFX(0)

    text.color={1, 1, 0}
    text:addFX(fx)
    text.y=(SCREEN_HEIGHT/2)-50
    local yellow_text = "Can someone hear me?"
    if Game:getFlag("no_heal", true) then
        if not Game:getFlag("secret_unlocked", false) then
            Game:setFlag("secret_unlocked", true)
            yellow_text = "You have unlocked\na secret fight!"
        else
            yellow_text = "A secret awaits you!"
        end
    else
        yellow_text = "But can you win without healing?"
    end
    text:setText(yellow_text)
    Game.world.timer:tween(3, fx, {alpha=1})
    cutscene:wait(6)

    Game.world.timer:tween(3, fx, {alpha=0})
    cutscene:wait(5)

    Kristal:returnToMenu()
end

--FROZEN HEART by Simbel
--Deltarune by Toby Fox
--Kristal Engine
--Sprites by Toby Fox
--Music by Toby Fox, ...
--Betatester, uh...
--Thanks to the helper
--The secret...?