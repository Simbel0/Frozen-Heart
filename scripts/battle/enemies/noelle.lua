local Noelle, super = Class(EnemyBattler)

function Noelle:init()
    super:init(self)

    -- Enemy name
    self.name = "Noelle"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("noelle")

    -- Enemy health
    self.max_health = 166
    self.health = 166
    -- Enemy attack (determines bullet damage)
    self.attack = 8
    -- Enemy defense (usually 0)
    self.defense = 1
    -- Enemy reward
    self.money = 1

    self.thorn_ring_timer = 0

    self.confused = false
    self.confusedTimer = 0

    self.exit_on_defeat = false

    self.killed_once = false

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    -- Dialogue randomly displayed in the enemy's speech bubble
    --self.dialogue = {
    --    "..."
    --}
    self.dialogue_offset={-70, 0}

    -- Check text (automatically has "ENEMY NAME - " at the start)
    --self.check = "AT 3 DF 1\n* Cotton heart and button eye\n* Looks just like a fluffy guy."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Noelle shivers slightly.",
        "* A light shines in the cold.",
        "* It's so cold.",
        "* The room is freezing.",
        --[["[facec:susie/neutral]]"[voice:susie]* (I feel weird... And it's not the coldness of the room...)"
    }
    -- Text displayed at the bottom of the screen when the enemy has low health

    self.talk=0
    self.pirou_first=true
    self.wake_first=true
end

function Noelle:update()
    super:update(self)
    self.thorn_ring_timer = (self.thorn_ring_timer or 0) + DTMULT

    if self.thorn_ring_timer >= 6 then
        self.thorn_ring_timer = self.thorn_ring_timer - 6

        if self.health > Utils.round(self.max_health / 3) then
            self.health = self.health - 1
        end
    end
end

function Noelle:onAct(battler, name)
    if name == "Talk" then --X-Action
        self:addMercy(math.ceil(100/5))

        local text = {"* Are you in the right fight?"}
        if self.talk==0 then
            text = {
                "[facec:susie/sad_frown][voice:susie]* Uh...",
                "[facec:susie/sad][voice:susie]* Noelle[wait:1], are you alright...?"
            }
            self.dialogue_override="[voice:noelle][speed:0.6]Susie..."
        elseif self.talk==1 then
            text = {
                "[facec:susie/nervous_side][voice:susie]* Yeah, uh, it's me.",
                "[facec:susie/neutral_side][voice:susie]* Are you good?"
            }
            self.dialogue_override="[voice:noelle][speed:0.6]I have to\ncontinue..."
        elseif self.talk==2 then
            text = {
                "[facec:susie/bangs_neutral][voice:susie]* ...",
                "[facec:susie/bangs_neutral][voice:susie]* (What am I even supposed to say here?)",
                "[facec:susie/neutral_side][voice:susie]* Uh...",
                "[facec:susie/nervous][voice:susie]* Continue what?"
            }
            self.dialogue_override={"[voice:noelle][speed:0.6]Getting stronger...", "[voice:noelle][speed:0.6]I have to\nget stronger..."}
        elseif self.talk==3 then
            text = {
                "[facec:susie/surprise][voice:susie]* Getting...[wait:2] stronger?",
                "[facec:susie/sus_nervous][voice:susie]* What does that even mean??",
            }
            self.dialogue_override={"[voice:noelle][speed:0.6]Susie...[wait:2]\nThe voices...[wait:2]\nI can't..."}
        elseif self.talk==4 then
            self.waves={
                "snowfall",
                "bettersnowfall",
                "snowabsorb",
                "snowstorm",
                "him",
                "him-alter",
                "snowshotter",
                "snowshotter-alter"
            }
            Game.battle:startActCutscene(function(cutscene)
                local susie=cutscene:getUser()
                local noelle=cutscene:getTarget()
                cutscene:setSpeaker(susie)
                local ori_x, ori_y=susie.x, susie.y
                local cur_x
                local walkSusie=true
                local cutTimer=0
                cutscene:setAnimation(susie, {"walk/right", 0.35*2, true})
                cutscene:during(function()
                    if walkSusie then
                        if susie.x<=noelle.x-40 then
                            susie.x=susie.x+0.35
                        end
                    else
                        if cur_x then
                            cutTimer=cutTimer+1*DTMULT
                            if susie.x>ori_x then
                                susie.x=Utils.ease(cur_x, ori_x, cutTimer/10, "out-cubic")
                                --susie.y=Utils.ease(cur_y, ori_y, cutTimer/10, "out-quint")
                            end
                        end
                    end
                end)
                cutscene:text("* Okay look, Noelle.", "sus_nervous")
                cutscene:text("* You're clearly NOT fine.", "sus_nervous")
                cutscene:text("* So I think it would be better if you just forget all of this.", "nervous")
                cutscene:text("* After all, it's just a dream, you know?", "sincere")
                cutscene:text("* So maybe you should, uh...", "nervous_side")
                cutscene:text("* Start by removing that weird thing on your finger and-", "nervous")
                
                walkSusie=false
                cutscene:setSprite(susie, "shock")
                cur_x, cur_y=susie.x, susie.y
                cutscene:battlerText(self, "NO!!")
                cutscene:battlerText(self, "I CAN'T!!\nTheir voices!")
                cutscene:battlerText(self, "I can hear them...\nI can hear...")
                cutscene:battlerText(self, "I-... I...")
                cutscene:battlerText(self, "...")

                cutscene.textbox_actor=nil
                cutscene:text("* Noelle casts Ice Shock.", nil, nil, {wait=false, skip=false})
                cutscene:wait(0.75)
                self:castIceShock(Game.battle.party[1])
                cutscene:wait(5)
                cutscene:text("...")
            end)
            return
        end
        self.talk=self.talk+1
        return text
    elseif name=="Pirouette-X" then
        Game.battle:startActCutscene(function(cutscene)
            if not self.confused then
                self.encounter.spell_countdown=self.encounter.spell_countdown+1
                if self.pirou_first then
                    cutscene:text("* (Kr-Kris,[wait:1] is that you...?)", "surprise", "susie")
                    cutscene:choicer({"Yes", "Maybe", "No, but yes", "Sure"})
                    cutscene:text("* ...", "suspicious", "susie")
                    cutscene:text("* Whatever.", "neutral_side", "susie")
                    cutscene:text("* I ain't doing that.", "annoyed", "susie")
                    cutscene:text("* [speed:0.6][wait:2]Susie...?[wait:1] Do you...?", "trance-surprise", "noelle")
                    Assets.playSound("snd_pirouette")
                    cutscene:text("* Noelle was CONFUSED by Susie talking to herself!")
                    cutscene:text("* ...", "surprise", "susie")
                    cutscene:text("* Heh.[wait:1] A piece of cake.[react:1]", "closed_grin", "susie", {reactions={
                        {"susie", "nervous_side", "right", "bottom", "Man, I'm hungry now."}
                    }})
                    self.pirou_first=false
                else
                    cutscene:text("* Hey! Can you SHUT UP!?", "angry_c", "susie")
                    cutscene:text("* I can think without a weird voice telling me what to do.", "angry_b", "susie")
                    cutscene:text("* [speed:0.6]What...?", "trance-surprise", "noelle")
                    Assets.playSound("snd_pirouette")
                    cutscene:text("* Noelle was CONFUSED by Susie talking to herself!")
                end
            else
                cutscene:text("* But Noelle is already CONFUSED.")
            end
        end)
        self.comment = "(Confused)"
        self.confused = true
        return
    elseif name=="Wake Up" then
        print(self.wake_first)
        if self.confused then
            Game.battle:startActCutscene("forcePull", self.wake_first)
        else
            Game.battle:startActCutscene(function(cutscene)
                if self.wake_first then
                    if self.pirou_first then
                        cutscene:text("* Huh??[wait:1] \"Wake up\"...?", "surprise", "susie")
                        cutscene:text("* Did I heard that right? What does that mean?", "smirk", "susie")
                    else
                        cutscene:text("* \"Wake up\"...", "neutral", "susie")
                        cutscene:text("* The hell am I supposed to do with that?", "nervous_side", "susie")
                    end
                    cutscene:choicer({"Say something\nromantic", "Cast PACIFY"})
                    cutscene:text("* Well it's not like I can approch her right now.", "annoyed", "susie")
                    cutscene:text("* She'll freeze me to death again if I do so.", "annoyed_down", "susie")
                    cutscene:text("* Maybe if I find a way to make her lose her focus...", "neutral_side", "susie")
                else
                    cutscene:text("* I ain't approching her in those condition.", "annoyed", "susie")
                    cutscene:text("* I can kick ass but I know when it's not worth it.", "nervous", "susie")
                end
            end)
        end
        self.wake_first=false
        return
    else
        Game.battle:startActCutscene(function(cutscene)
            cutscene:text("* ...")
            cutscene:text("* ...")
            cutscene:text("* What... Am I supposed to do exactly?")
            cutscene:text("* Wait, am I supposed to act but I don't have any act to do?")
            cutscene:text("* Oh fuck no-")

            Game.battle.timer:everyInstant(1/2, function()
                local ex=Explosion(Utils.random(0, SCREEN_WIDTH), Utils.random(0, SCREEN_HEIGHT))
                ex:setLayer(Utils.random(1000, 0))
                Game.stage:addChild(ex)
            end)
            cutscene:wait(5)
            Game.battle.timer:every(1/8, function()
                local ex=Explosion(Utils.random(0, SCREEN_WIDTH), Utils.random(0, SCREEN_HEIGHT))
                ex:setLayer(Utils.random(1000, 0))
                Game.stage:addChild(ex)
            end)
            cutscene:wait(4)
            Game.battle.timer:every(1/16, function()
                local ex=Explosion(Utils.random(0, SCREEN_WIDTH), Utils.random(0, SCREEN_HEIGHT))
                ex:setLayer(Utils.random(1000, 0))
                Game.stage:addChild(ex)
            end)
            cutscene:wait(3)
            Game.battle.timer:every(1/32, function()
                local ex=Explosion(Utils.random(0, SCREEN_WIDTH), Utils.random(0, SCREEN_HEIGHT))
                ex:setLayer(Utils.random(1000, 0))
                Game.battle:addChild(ex)
            end)
            cutscene:wait(2)
            local hider=Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
            hider:setColor(1, 1, 1, 0)
            hider:setLayer(100000)
            Game.stage:addChild(hider)
            Game.battle.timer:tween(0.6, hider, {alpha=1})
            cutscene:wait(1)
            Game.battle.timer:clear()
            cutscene:wait(1.5)
            Game.battle.timer:tween(1, hider, {color={0, 0, 0}})
            cutscene:wait(2)
            local dialogue = DialogueText("[noskip][speed:0.5][spacing:8][voice:none] THEN THE WORLD[wait:30] \n WAS COVERED[wait:30] \n IN DARKNESS.", 60*2, 81*2, {style = "GONER", line_offset = 14})
            hider:addChild(dialogue)
            cutscene:wait(function()
                return dialogue.done
            end)
            hider:remove()
            dialogue:remove()
            Game:gameOver(0, 0)
            Game.gameover.soul:remove()
            Game.gameover.soul = nil
            Game.gameover.screenshot = nil
            Game.gameover.timer = 300
            Game.gameover.choicer_done = true
            Game.gameover.fadebuffer = 10
            Game.gameover.music:play("AUDIO_DARKNESS")
            Game.gameover.music.source:setLooping(false)
            Game.gameover.current_stage = 21
        end)
        return
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super:onAct(self, battler, name)
end

function Noelle:castIceShock(target)
    self:setAnimation("battle/spell")
    local function createParticle(x, y)
        local sprite = Sprite("effects/icespell/snowflake", x, y)
        sprite:setOrigin(0.5, 0.5)
        sprite:setScale(1.5)
        sprite.layer = BATTLE_LAYERS["above_battlers"]
        Game.battle:addChild(sprite)
        return sprite
    end

    local x, y = target:getRelativePos(target.width/2, target.height/2, Game.battle)

    local particles = {}
    Game.battle.timer:script(function(wait)
        wait(1/30)
        Assets.playSound("icespell")
        particles[1] = createParticle(x-25, y-20)
        wait(3/30)
        particles[2] = createParticle(x+25, y-20)
        wait(3/30)
        particles[3] = createParticle(x, y+20)
        wait(3/30)
        Game.battle:addChild(IceSpellBurst(x, y))
        for _,particle in ipairs(particles) do
            for i = 0, 5 do
                local effect = IceSpellEffect(particle.x, particle.y)
                effect:setScale(0.75)
                effect.physics.direction = math.rad(60 * i)
                effect.physics.speed = 8
                effect.physics.friction = 0.2
                effect.layer = BATTLE_LAYERS["above_battlers"] - 1
                Game.battle:addChild(effect)
            end
        end
        wait(1/30)
        for _,particle in ipairs(particles) do
            particle:remove()
        end
        wait(4/30)

        local nb=Game:getFlag("plot", 0)==2 and 11 or 22
        local min_magic = Utils.clamp(nb - 10, 1, 999)
        local damage = math.ceil((min_magic * 30) + 90 + Utils.random(10))

        local fatal=false
        target:hurt(damage, false, {1, 1, 0})

        --Game.battle:finishActionBy(user)
        return fatal
    end)

    return false
end

function Noelle:onDefeat()
    if not self.killed_once then
        self:setAnimation("battle/defeat")
        self.health=1
        self.mercy=100
        self.tired=false
        self.comment=""
        self.killed_once=true
        self.waves={}
        self.acts={}
        self.confused=false
        self.confusedTimer=4
        self.encounter.no_end_message = true
        Game.battle.party[1].spells = {}
        self.text={
            "* ...",
            "* ...",
            "* ...",
            "* ...",
            "* ...",
            "* It's getting cold."
        }
        Game:setTension(0)
        Game.battle.noelle_tension_bar:setTension(0)
        Game.battle.timer:tween(2, Game.battle.music, {pitch=0.3})
        Game.battle:startCutscene(function(cutscene)
            Game.battle:resetAttackers()
            cutscene:after(function() Game.battle:setState("ACTIONSELECT") end)
            cutscene:text("* [speed:0.2]......!", nil, "noelle")
            cutscene:text("* [speed:0.4]Su-[wait:2]Susie...?", nil, "noelle")
            cutscene:text("* [speed:0.4]What are you...", nil, "noelle")
            cutscene:text("* [speed:0.4]...H-[wait:1]Hey...", nil, "noelle")
            cutscene:text("* [speed:0.4]Y-[wait:1]You aren't thinking o-[wait:2]of...", nil, "noelle")
            cutscene:text("* [speed:0.4]ki-[wait:3]killing me...", nil, "noelle")
            cutscene:text("* [speed:0.4]Ri-[wait:1]Ri-[wait:1]Right...?", nil, "noelle")
            cutscene:text("* [speed:0.4]I-[wait:2]I-[wait:1]...[wait:2] Pl-", nil, "noelle")
            cutscene:text("* [speed:0.4]Please...[wait:1] Do-[wait:2.5]Don't kill me...", nil, "noelle")
            cutscene:text("* [speed:0.4]I beg...[wait:2] of y-[wait:2]you...", nil, "noelle")
            cutscene:endCutscene()
        end)
    else
        Game:setFlag("noelle_battle_status", "killkill")
        Game.battle:returnToWorld()
    end
end

function Noelle:spare(pacify)
    Game:setFlag("noelle_battle_status", "killspare")
    return super:spare(self, pacify)
end

function Noelle:castSnowGrave(user)
    self:setAnimation("battle/spell")
    local object = SnowGraveSpell(user, target)
    object.damage = math.ceil(((13 * 40) + 600))
    object.layer = BATTLE_LAYERS["above_ui"]
    Game.battle:addChild(object)
    self.encounter.snowgrave = object --Gives the encounter the object so it can deletes on Game over it to prevent a crash

    return false
end

function Noelle:castHealthPrayer(target)
    self:setAnimation("battle/spell")
    target:heal(13 * 5)
end

function Noelle:castSleepMist(target)
    self:setAnimation("battle/spell")
    Game.battle.timer:after(10/30, function()
        Assets.playSound("ghostappear")

        local x, y = target:getRelativePos(target.width/2, target.height/2)

        local effect = SleepMistEffect(x, y, false)
        effect.layer = target.layer + 0.1
        target:addChild(effect)
    end)
end

function Noelle:onDefeatThorn()
    Game.battle.timer:after(1, function()
        Game.battle:startCutscene(function(cutscene)
            self:setAnimation("battle/defeat")
            Assets.playSound("noise")
            cutscene:wait(0.75)
            Game.battle.music:fade(0, 1/3)
            Game.battle.tension_bar.animating_in = false
            Game.battle.tension_bar.shown = false
            Game.battle.tension_bar.physics.speed_x = -10
            Game.battle.tension_bar.physics.friction = -0.4
            Game.battle.battle_ui:transitionOut()
            local map={Game.world.map:getImageLayer("room"), Game.world.map:getImageLayer("moon"), Game.world.map:getImageLayer("ferris_wheel")}
            for _,layer in ipairs(map) do
                Game.battle.timer:tween(0.5, layer, {y=0})
            end
            Game.battle.timer:tween(0.5, Game.battle.party[1], {x=Game.battle.party_beginning_positions[1][1], y=Game.battle.party_beginning_positions[1][2]})
            Game.battle.timer:tween(0.5, Game.battle.enemies[1], {x=Game.battle.enemy_beginning_positions[Game.battle.enemies[1]][1], y=Game.battle.enemy_beginning_positions[Game.battle.enemies[1]][2]})
            Game:setFlag("noelle_battle_status", "thorn_kill")
            cutscene:wait(0.75)
            Game.battle:returnToWorld()
        end)
    end)
end

return Noelle