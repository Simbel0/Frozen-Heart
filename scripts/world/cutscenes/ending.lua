return {
    closing_fountain=function(cutscene)
        cutscene:fadeOut(0)
        Kristal.hideBorder(1)
        cutscene:wait(1)

        local soul = Sprite("player/heart", SCREEN_WIDTH/2, SCREEN_HEIGHT-100)
        soul.color={1, 0, 0}
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
    end,
    killkill=function(cutscene)
        local kris   = Game.world:spawnNPC("kris_lw", Game.world.map.markers["kris"].x, Game.world.map.markers["kris"].y, {facing="up"})
        local susie  = Game.world:spawnNPC("susie_lw", Game.world.map.markers["susie"].x, Game.world.map.markers["susie"].y, {facing="up"})
        local noelle = Game.world:spawnNPC("noelle_lw", 417, 226, {facing="down"})
        Game.world.player.visible=false
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
        cutscene:text("* What...[wait:1] happenned?", "neutral_side", "susie")
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
        cutscene:look(kris, "down")
        cutscene:look(susie, "down")
        Game.world.timer:after(0.20, function() noelle:setLayer(susie.layer) end)
        cutscene:wait(cutscene:walkToSpeed(noelle, 330, noelle.y, 8, "up"))

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
        cutscene:text("* Like something terrible just happenned.", "", "susie")
        cutscene:text("* Could it be that...?", "", "susie")
        cutscene:text("* ...Well I sure hope not.", "", "susie")
        cutscene:text("* It's fucking terrifying...", "", "susie")
        CutMusic:stop()
        cutscene:text("[speed:0.75]* When your choices don't matter anymore.", "", "susie")

        Assets.playSound("snd_dooropen")

        cutscene:wait(0.5)

        cutscene:text("* Ah Kris. Got everything we need?", "", "susie")
        cutscene:text("* Let's go.", "", "susie")

        cutscene:gotoCutscene("CREDITS")
    end
}