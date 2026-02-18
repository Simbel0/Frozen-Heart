local secret_battle, super = Class(Encounter)

function secret_battle:init()
    super:init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* Snow fills your vision."

    -- Battle music ("battle" is rude buster)
    self.music = "frozen_heart_intro"
    -- Enables the purple grid battle background
    self.background = false

    self.intro = true
    self.intro_actions_boxes_depla = false


    self.turns = 0

    self.default_xactions = false

    self.def_boost = false

    self.last_section = false
    self.placed_neo = false

    -- Add the dummy enemy to the encounter
    self.noelle = self:addEnemy("ring_noelle", 505, 227)
    --self.sneo = self:addEnemy("lost_soul_s", 525, 270)
    --self.sneo:registerAct("Charge")
    --self.sneo.charge = 4

    Utils.hook(Bullet, "getDamage", function(orig, og_self, soul)
        local damage = orig(og_self, soul)
        if self.last_section and damage<=0 and og_self.alpha == 1 then
            return love.math.random(26, 28)*1.5
        end
        return damage
    end)

    Utils.hook(Bullet, "onDamage", function(orig, og_self, soul)
        local damage = og_self:getDamage()
        if self.queen and self.queen.shield then
            if damage>0 then
                self.queen.shield:hurt(damage)
            end
        else
            orig(og_self, soul)
        end
    end)
end

function secret_battle:update()
    if self.intro and Game.battle.music.source then
        local progress = Game.battle.music:tell()
        print(progress, math.floor(progress), math.ceil(progress))

        if Game:getFlag("allow_music_skip", false) and self.skip_text then
            if Input.pressed("menu", false) and math.ceil(progress) < 28 then
                self.skip_text:remove()
                self.skip_text = nil
                Game.battle.music:seek(27)
            end
        end

        if math.ceil(progress)==28 and not self.fade_out_intro then
            Game.fader:fadeOut(nil, {color={1, 1, 1}, speed=1})
            self.fade_out_intro = true
        elseif math.ceil(progress)==31 then
            Game.battle.music:play("frozen_heart")

            self.fog:remove()
            self.default_xactions = true
            self.noelle.name = "Noelle"
            self.noelle.text = {
                "* It's so cold.",
                "* The fountain's light is trapped in the cold.",
                "* Everything becomes fantasy.",
                "* Noelle doesn't feel any pain.",
                "* It's cold.",
                "* The flame of Queen's chair warms the party.",
                "* Noelle lost herself.",
                "* The Dark World is losing its shape.",
                "* Feels like dark and light.",
                "* The Prophecy is failing.",
                "* Close to the Angel.",
                "* The air crackles with freedom.",
                "* Frozen statues everywhere.",
                "* Noelle whispers something unintelligible."
            }
            Game.battle.battle_ui.current_encounter_text = "* It's the end."
            if Game.battle.state == "ACTIONSELECT" then
                Game.battle.battle_ui.encounter_text:setText(Game.battle.battle_ui.current_encounter_text)
            end
            self.intro = false
            if not self.intro_actions_boxes_depla then
                Game.battle.battle_ui.action_boxes[1].x = 0 + (1 - 1) * (213 + 0)
                Game.battle.battle_ui.action_boxes[2].x = 0 + (2 - 1) * (213 + 0)
                Game.battle.battle_ui.action_boxes[2]:removeFX(self.alpha_masks[4])
                Game.battle.battle_ui.action_boxes[3].x = 0 + (3 - 1) * (213 + 0)
                Game.battle.battle_ui.action_boxes[3]:removeFX(self.alpha_masks[5])
            end

            for i,v in ipairs(Game.battle.party) do
                v.sprite:removeFX(self.mask)
                v.sprite:removeFX(self.alpha_masks[i])
                v.x, v.y = self:getPartyPosition(i)
            end

            self.noelle.sprite.alpha = 1
            self.noelle:registerAct("Red Buster", "Red\nDamages", {"susie"}, 60)
            self.noelle:registerAct("Dual Heal", "Heals\neveryone", {"ralsei"}, 50)
            self.noelle:registerAct("Shield", "Raise Acid\nShield", {"kris"}, 96, nil, {"queen-icon"})
            self.noelle.waves = {
                "secret/snowfall2",
                "secret/icefall",
                "secret/iceshocks",
                "secret/kinda_touhou_ngl",
                "secret/snowReject",
                "secret/stallattack",
                "secret/fight",
                "secret/shadowSnowBullet",
                "secret/dark_star_attack"
            }
            self.noelle:addChild(self.noelle.snow_effect)

            if self.queen then
                self.queen.alpha = 1
                self.queen:setPosition(40, 145)
            else
                local queen = Game.world:spawnNPC("queen", 40, 145)
                queen:setAnimation({"chair", 1/8, true})
                self.queen = queen
                Game.world:removeChild(queen)
                Game.battle:addChild(self.queen)

                self.gradient = Sprite("effects/icespell/gradient")
                self.gradient:setWrap(true, false)
                self.gradient.layer = WORLD_LAYERS["below_ui"]
                self.gradient:setScale(2)
                self.gradient.alpha = 0.5
                Game.world.timer:tween(3, self.gradient, {alpha=0.5})
                Game.world:addChild(self.gradient)
                self.snow = Sprite("effects/icespell/snowfall")
                self.snow:setWrap(true)
                self.snow:setScale(2)
                self.snow.alpha = 1
                self.snow.layer = self.gradient.layer - 0.6
                self.snow.physics = {
                    speed = 10,
                    direction = math.rad(75)
                }
                Game.world:addChild(self.snow)
            end
            self.queen.air_mouv = true

            Game.battle.tension_bar:setShortVersion(true)

            if self.skip_text then
                self.skip_text:remove()
                self.skip_text = nil
            end

            Game.fader:fadeIn()
        end
    end

    if self.queen and self.queen.air_mouv then
        self.queen.y = 145 + math.sin(Kristal.getTime()*4)*10
    end
    if self.queen and self.queen.shield_broken then
        print(self.queen.x)
        if self.queen.x>40 then
            self.queen:resetPhysics()
            self.queen:setAnimation({"chair", 1/8, true})
            self.queen.x = 40
            self.queen.shield_broken = false
        end
    end

    if self.ice_fountain then
        for i,beam in ipairs(self.ice_fountain.light_beams) do
            beam.color = self.true_fountain.color
            beam.rotation = math.rad(0+math.sin(Kristal.getTime()*2)*10-i*4)
        end
    end
end

function secret_battle:onStateChange(old, new)
    if new=="DEFENDINGBEGIN" then
        if self.berdly then
            self.berdly:setAnimation("idle_surprised")
        end
        if self.def_boost then
            for i,battler in ipairs(Game.battle.party) do
                battler.chara:increaseStat("defense", 5)
            end
        end
        if self.queen and self.queen.shield then
            if not self.queen.shield.ignore_state then
                self.queen.shield.appearcon = 1
            else
                self.queen.shield.ignore_state = false
            end
        end
    elseif new=="ACTIONSELECT" then
        if self.berdly then
            self.berdly:setAnimation("idle")
        end
        if self.def_boost then
            for i,battler in ipairs(Game.battle.party) do
                battler.chara:increaseStat("defense", -5)
            end
            self.def_boost = false
        end
        if self.queen and self.queen.shield then
            if not self.queen.shield.ignore_state then
                if old == "CUTSCENE" or old == "DEFENDINGEND" then
                    self.queen.shield.appearcon = 2
                end
            else
                self.queen.shield.ignore_state = false
            end
        end
        if self.last_section then
            if self.sneo and not self.placed_neo then
                self.placed_neo = true
                self.sneo:setPosition(17, -50)
                self.sneo.flip_x = true
                self.sneo:setLayer(self.queen.layer+10)
                self.ice_fountain:setSprite("ice_fountain_break_1")
                for i,beam in ipairs(self.ice_fountain.light_beams) do
                    beam.alpha = 1
                end
                for i,part in ipairs(self.sneo.sprite.parts) do
                    if part ~= self.sneo.head then
                        part.swing_speed = 1 + (i-1)/5
                    end
                end
                Game.battle.timer:tween(0.5, self.sneo, {y=280}, nil, function() Assets.playSound("impact") end)
            end
        else
            self.noelle.health = self.noelle.max_health
        end
    end
end

function secret_battle:onBattleStart()
    if not self.fog then
        self.fog = Sprite("fog")
        self.fog:setWrap(true)
        self.fog:setScale(2)
        self.fog.layer = BATTLE_LAYERS["below_battlers"]
        self.fog.physics = {
            speed = 2,
            direction = math.rad(75)
        }
        Game.battle:addChild(self.fog)
    end

    self.true_fountain = Game.world:getEvent(2)
    self.fountain_floor = Game.world:getEvent(1)

    self.ice_fountain = Sprite("ice_fountain", self.true_fountain.x, self.true_fountain.y-11)
    self.ice_fountain:setScale(2)
    self.ice_fountain:setOrigin(0.5, 1)
    self.ice_fountain.state = 1
    self.ice_fountain.light_beams = {
        Triangle(28, 130, {0, 0, -200, -10, -200, 10}),
        Triangle(114, 69, {0, 0, 200, -10, 200, 10})
    }
    Game.world:addChild(self.ice_fountain)
    for i,beam in ipairs(self.ice_fountain.light_beams) do
        self.ice_fountain:addChild(beam)
        beam.alpha = 0
        beam:setLayer(self.ice_fountain.layer-5)
    end
    self.ice_floor = Rectangle(self.fountain_floor.x, self.fountain_floor.y, self.fountain_floor.width, self.fountain_floor.height)
    self.ice_floor:setColor(143/255, 192/255, 251/255, 0.4)
    Game.world:addChild(self.ice_floor)

    self.true_fountain.visible = false
    self.fountain_floor.visible = false


    self.mask = ColorMaskFX({0, 0, 0})
    self.alpha_masks = {AlphaFX(0), AlphaFX(0), AlphaFX(0), AlphaFX(0), AlphaFX(0)}
    for i,v in ipairs(Game.battle.party) do
        v.sprite:addFX(self.mask)
        v.sprite:addFX(self.alpha_masks[i])
    end

    Game.battle.timer:tween(1.2, self.alpha_masks[1], {alpha=1})

    Game.battle.battle_ui.action_boxes[2]:addFX(self.alpha_masks[4])
    Game.battle.battle_ui.action_boxes[2].x = 640
    Game.battle.battle_ui.action_boxes[3]:addFX(self.alpha_masks[5])
    Game.battle.battle_ui.action_boxes[3].x = 640

    self.noelle.sprite.alpha = 0

    Game.battle.battle_ui.action_boxes[1].x = 213

    self.old_health_amount = {}
    local presence = Kristal.getPresence()
    presence.details = "In the alternative fight"

    local message = "Doing well!"
    local downed = 0
    local max_hp = true
    for i,member in ipairs(Game.battle.party) do
        if member.is_down then
            downed = downed + 1
        end
        if member.chara:getHealth() < member.chara:getStat("health") then
            max_hp = false
        end

        table.insert(self.old_health_amount, member.chara:getHealth())
    end

    if max_hp then
        message = "Doing perfect!"
    elseif downed > 0 then
        message = downed.." down."
        if downed == 2 then
            for i,member in ipairs(Game.battle.party) do
                if not member.is_down then
                    if member.chara:getHealth() < member.chara:getStat("health")/4 then
                        message = message.." Almost dead!"
                    end
                    break
                end
            end
        end
    end

    presence.state = message

    Kristal.setPresence(presence)
    Game.battle.timer:every(1, function()
        local change = false
        for i,member in ipairs(Game.battle.party) do
            if member.chara:getHealth() ~= self.old_health_amount[i] then
                change = true
                break
            end
        end
        if change then
            local presence = Kristal.getPresence()
            local message = "Doing well!"
            local downed = 0
            local max_hp = true
            for i,member in ipairs(Game.battle.party) do
                if member.is_down then
                    downed = downed + 1
                end
                if member.chara:getHealth() < member.chara:getStat("health") then
                    max_hp = false
                end
            end

            if max_hp then
                message = "Doing perfect!"
            elseif downed > 0 then
                message = downed.." down."
                if downed == 2 then
                    for i,member in ipairs(Game.battle.party) do
                        if not member.is_down then
                            if member.chara:getHealth() <= Game.battle.party[1].chara:getStat("health")/4 then
                                message = message.." Almost dead!"
                            end
                            break
                        end
                    end
                end
            end

            presence.state = message

            Kristal.setPresence(presence)
        end
    end)

    if Game:getFlag("allow_music_skip", false) then
        self.skip_text = DialogueText("Press "..Input.getText("menu").." to skip.", 10, 5)
        self.skip_text:setColor(0, 0, 0, 1)
        self.skip_text:setLayer(BATTLE_LAYERS["top"])
        self.skip_text.state["typing_sound"] = nil
        Game.battle:addChild(self.skip_text)
    end
end

function secret_battle:getNextWaves()
    if self.final and not self.final_passed then
        self.noelle.selected_wave = "secret/final"
        return {"secret/final"}
    end
    if self.force_waves then
        local waves = {}

        for enemy,wave in pairs(self.force_waves) do
            for i,active_enemy in ipairs(Game.battle:getActiveEnemies()) do
                print(active_enemy, enemy)
                if Utils.contains(active_enemy.id, enemy) then
                    active_enemy.selected_wave = wave
                    break
                end
            end
            table.insert(waves, "secret/"..wave)
        end
        self.force_waves = nil

        return waves
    end
    print(not self.berdly, not self.last_section, (not self.berdly) and (not self.last_section))
    if (not self.berdly) and (not self.last_section) then
        print("duo attack not available")
        return super:getNextWaves(self)
    end
    print("duo attack available")

    local duo = Utils.random()>(self.last_section and 0.2 or 0.3)
    local waves = {}
    if not duo then
        if not self.last_section then
            local enemy = Utils.pick(Game.battle:getActiveEnemies())
            local wave = enemy:selectWave()
            if wave then
                table.insert(waves, wave)
            end
        else
            return super:getNextWaves(self)
        end
    else
        local no_no_waves = {
            "dark_star_attack",
            "shadowSnowBullet",
            "snowReject",
            "use_berdly"
        }

        if not self.last_section then
            for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
                local wave = enemy:selectWave()
                while Utils.containsValue(no_no_waves, wave:sub(8)) do
                    wave = enemy:selectWave()
                end
                if wave then
                    table.insert(waves, wave)
                end
            end
        else
            while #waves<2 do
                local wave = self.noelle:selectWave()
                while Utils.containsValue(no_no_waves, wave:sub(8)) do
                    wave = self.noelle:selectWave()
                end
                if wave then
                    table.insert(waves, wave)
                end
            end
        end
    end
    return waves
end

--Debug functions
--[[
function secret_battle:forceDoubleWaves(waves)
    self.force_waves = waves
    Game.battle:setState("DEFENDINGBEGIN")
end
]]

function secret_battle:skipPhase()
    local Console = Kristal.Console
    if not self.berdly and not self.sneo then
        self.turns = 6
        Console:log("Advancing the fight to Berdly's section.")
    elseif self.berdly and self.berdly.mercy < 90 then
        self.turns = 10
        self.berdly.mercy = 99
        Console:log("Advancing the fight to Spamton NEO's section.")
    elseif self.sneo and not self.last_section then
        self.sneo.deal = 4
        self.sneo.charge = 4
        Console:log("Advancing the fight to the final section.")
    else
        self.noelle.health = 800
        self.final = true
        Console:log("Advancing the fight to the final wave.")
    end
end


function secret_battle:getEncounterText()
    if self.final and not self.final_passed then
        Assets.playSound("break2", 2)
        return "* The biggest snowstorm is coming!"
    end
    return super.getEncounterText(self)
end

function secret_battle:onTurnEnd()
    if not self.intro then
        self.turns = self.turns + 1
    end

    if self.last_section and self.noelle.health < (25*self.noelle.max_health)/100 then
        self.final = true
    end
    
    if (self.queen and self.queen.shield) and self.queen.shield.health<=0 then
        self.break_shield_cutscene = true
    end
    local FH_cutscene
    if self.turns==3 then
        FH_cutscene = function(cutscene)
            cutscene:after(function() Game.battle:setState("ACTIONSELECT") end)
            cutscene:wait(1/4)
            cutscene:text("* Kris, why do you persist?", "crazy-scared", "noelle")
            cutscene:text("* I became so strong, isn't it what you wanted?", "crazy-neutral", "noelle")
            cutscene:text("* ...", "nervous", "susie")
            cutscene:text("* ...", "surprise_confused", "ralsei")
            cutscene:text("* What The Heck (Hell)", "bro", "queen")
        end
    elseif self.turns==7 then
        FH_cutscene = function(cutscene)
            cutscene:after(function()
                Game.battle:setState("ACTIONSELECT")
                Game.battle.battle_ui.current_encounter_text = "* The lost soul barges in!"
                Game.battle.battle_ui.encounter_text:setText(Game.battle.battle_ui.current_encounter_text)
            end)
            cutscene:wait(1/4)
            cutscene:text("* Damn it, it's no use, we aren't making progress!!", "angry_b", "susie")
            cutscene:text("* Can't we just smash the fountain wide open and seal it or something??", "angry", "susie")
            cutscene:text("* This may not be a good idea, Susie.", "pensive", "ralsei")
            cutscene:text("* We just have to keep going, and then maybe the solution will arrive!", "pleased", "ralsei")
            cutscene:text("* By magic?", "neutral", "susie")
            cutscene:text("* Sort of..", "pleased", "ralsei")
            cutscene:text("* Yeah,[wait:2] no...[wait:5] I ain't convinced.", "annoyed", "susie")
            cutscene:text("* Sorry To Interrupt But I Think You Guys Missed Something", "smile_side_l", "queen")
            cutscene:text("* Like what?", "neutral_side", "susie")
            cutscene:text("* My Super Cool Eyes Can See That Noelle Wears Something Really Weird On Her Finger", "true", "queen")
            cutscene:text("* And That Thing Seems To Be Filled With Some Negative Energy", "surprise", "queen")
            cutscene:text("* ...", "surprise_confused", "ralsei")
            cutscene:text("* Oh! I see it now,[wait:2] you're right!", "shock", "ralsei")
            cutscene:text("* What the hell is that...?", "surprise_frown", "susie")
            cutscene:text("* It looks like...[wait:5] thorns...", "sus_nervous", "susie")
            cutscene:text("* Well whatever it is, if we break that thing, we save her,[wait:2] that's your point?", "neutral_side", "susie")
            cutscene:text("* Correct", "smirk", "queen")
            cutscene:text("* Then let's do so.", "bangs_teeth", "susie")
            cutscene:text("* Oh no, no, no, no, no.", "crazy-insane", "noelle")
            cutscene:text("* I won't let you do that!", "crazy-insane", "noelle")
            cutscene:text("* It makes me stronger... So much stronger..", "crazy-neutral", "noelle")
            cutscene:text("* Kris, aren't you against that idea too?", "crazy-side", "noelle")
            cutscene:text("* ...", "crazy-side", "noelle")
            cutscene:text("* Kris...[wait:5] Why??", "crazy-scared", "noelle")
            cutscene:text("* Have you forgotten everything we did together??", "crazy-scared", "noelle")
            cutscene:text("* Shut up.", "bangs_neutral", "susie")
            cutscene:text("* I don't know what possessed you[wait:1] but I'll kick it out right now!", "angry_c", "susie")
            cutscene:text("* Oh Susie... You don't need to do so..", "crazy-side", "noelle")
            cutscene:text("* Perhaps Kris needs a reminder of my full power?", "crazy-side", "noelle")
            cutscene:text("* ..?", "bangs_neutral", "susie")
            cutscene:text("* I know...", "crazy-side", "noelle")

            local ice = Sprite("berdly_ice")
            ice:setPosition(SCREEN_WIDTH+100, 35)
            ice:setScale(2)
            ice:setLayer(BATTLE_LAYERS["below_battlers"])
            Game.battle:addChild(ice)

            Game.battle.party[2]:setSprite("shock")
            Game.battle.party[2]:shake(5)

            Game.battle.party[3]:setSprite("battle/hurt")
            Game.battle.party[3]:shake(5)

            Game.battle.timer:tween(3, ice, {x=self.noelle.x-50, y=self.noelle.y-180, rotation=math.rad(45)}, "out-back")
            cutscene:wait(3)

            cutscene:text("* Let's go back a little, shall we?", "crazy-snow", "noelle")

            Game.battle.timer:tween(0.5, ice, {y=self.noelle.y+40}, "in-elastic")
            cutscene:wait(0.4)

            cutscene:wait(cutscene:fadeOut(0, {color={1, 1, 1}}))
            cutscene:fadeIn(4)
            self.berdly = self:addEnemy("lost_soul_b", 475, 230)
            table.remove(Game.battle.enemies, 1)
            self.noelle.visible = false
            self.noelle.sprite.alpha = 0
            for i,v in ipairs(Game.stage:getObjects(AfterImage)) do
                v:remove()
            end
            ice:remove()
            Game.battle.party[2]:resetSprite()
            Game.battle.party[3]:resetSprite()
        end
    elseif self.turns == 11 then
        if self.berdly_awoken then
            FH_cutscene = function(cutscene)
                cutscene:after(function()
                    Game.battle:setState("ACTIONSELECT")
                end)
                table.insert(Game.battle.enemies, 1, self.noelle)
                self.noelle.visible = true
                self.noelle.intend_x = 500
                self.noelle.intend_y = 140
                self.noelle.sprite.alpha = 1
                self.berdly:setAnimation("idle_surprised")
                cutscene:wait(cutscene:fadeOut(0, {color={1, 1, 1}}))
                cutscene:fadeIn(0.5)
                cutscene:wait(0.4)
                cutscene:text("* So Kris,[wait:2] what do you think?", "crazy-side", "noelle")
                cutscene:text("* ...", "crazy-scared", "noelle")
                cutscene:text("* No-[wait:2]Noelle!", "shock", "berdly")
                cutscene:text("* Noelle![wait:2] Come on![wait:2] It's me,[wait:1] Berdly!", "slight_smile", "berdly")
                cutscene:text("* You've...[wait:3] Freed him..?", "crazy-scared", "noelle")
                cutscene:text("* No[wait:1] no[wait:1] nO NO!!", "crazy-insane", "noelle")
                cutscene:text("* WHY??[wait:5] WHY did you CHANGE?!", "crazy-insane", "noelle")
                cutscene:text("* Why do you want to SAVE him NOW???", "crazy-insane", "noelle")
                cutscene:text("* No-[wait:2]Noelle...", "shock", "berdly")
                cutscene:text("* Don't listen to her,[wait:5] she lost it.", "nervous_side", "susie")
                cutscene:text("* Like..[wait:3] really...", "shy_down", "susie")
                cutscene:text("* Fine Kris.[wait:3] I understand.", "crazy-neutral", "noelle")
                cutscene:text("* Maybe it wasn't enough to remind you of what we did.", "crazy-side", "noelle")
                cutscene:text("* Then watch me follow in your tracks[func:kris_shake]!", "crazy-snow", "noelle", {functions={
                    kris_shake=function()
                        cutscene:getCharacter("kris"):shake(2)
                    end
                }})
                cutscene:text("* I-..[wait:3] I didn't sign up for this...![react:1]", "sweat", "berdly", {reactions={
                    {"You think any of\nus did??", "right", "bottommid", "teeth_b", "susie"}
                }})
            end
        else
            FH_cutscene = function(cutscene)
                cutscene:after(function()
                    Game.battle:setState("ACTIONSELECT")
                end)
                table.insert(Game.battle.enemies, 1, self.noelle)
                self.noelle.visible = true
                self.noelle.intend_x = 500
                self.noelle.intend_y = 140
                self.noelle.sprite.alpha = 1
                self.berdly:setAnimation("idle_surprised")
                cutscene:wait(cutscene:fadeOut(0, {color={1, 1, 1}}))
                cutscene:fadeIn(1)
                cutscene:wait(1)
                cutscene:text("* So Kris,[wait:2] what do you think?", "crazy-side", "noelle")
                cutscene:text("* ...", "crazy-side", "noelle")
                cutscene:text("* So you continue to ignore me.", "crazy-side", "noelle")
                cutscene:text("* But that's fine.", "crazy-neutral", "noelle")
                cutscene:text("* Soon,[wait:2] we will continue what we started.", "crazy-neutral", "noelle")
                cutscene:text("* Together![wait:3] Again!", "crazy-snow", "noelle")
                cutscene:text("* Don't listen to her Kris,[wait:5] she lost it.", "nervous_side", "susie")
                cutscene:text("* Like..[wait:3] really...", "shy_down", "susie")
            end
        end
    end

    if self.break_shield_cutscene then
        Game.battle:startCutscene(function(cutscene)
            cutscene:wait(1)
            self.queen.shield:remove()
            cutscene:wait(function()
                return not self.queen.shield_broken
            end)
            if FH_cutscene then
                cutscene:gotoCutscene(FH_cutscene)
            else
                cutscene:after(function()
                    Game.battle:setState("ACTIONSELECT")
                end, true)
            end
        end)
        self.break_shield_cutscene = false
        return true
    elseif FH_cutscene then
        Game.battle:startCutscene(FH_cutscene)
        return true
    end

    if self.sneo then
        if self.sneo.advance then
            self.sneo.advance = false
            table.insert(self.sneo.text, "* It's the end.")
            self.sneo.deal = self.sneo.deal + 1
            if self.sneo.deal==1 then
                Game.battle:startCutscene(function(cutscene)
                    cutscene:after(function()
                        Game.battle:setState("ACTIONSELECT")
                    end)
                    cutscene:text("* Damn, that ice is really solid...", "sus_nervous", "susie")
                    cutscene:text("* ...", "sus_nervous", "susie")
                    cutscene:text("* Whatever![wait:5] We ain't gonna get stopped by THAT of all things!!", "teeth", "susie")
                end)
                return true
            elseif self.sneo.deal==3 then
                Game.battle:startCutscene(function(cutscene)
                    cutscene:after(function()
                        Game.battle:setState("ACTIONSELECT")
                    end)
                    cutscene:text("* Uhm...[wait:3] Susie,[wait:2] are you sure we can...", "pleased", "ralsei")
                    cutscene:text("* Do you see another way??", "teeth_b", "susie")
                    cutscene:text("* No,[wait:2] but..", "frown", "ralsei")
                    cutscene:text("* ...[wait:3]Maybe you're right.", "disappointed", "ralsei")
                    cutscene:text("* What do you think, Kris?", "small_smile_side", "ralsei")
                    cutscene:text("* Come on![wait:3] If we want to go back to saving Noelle, we have to save that guy first.", "angry_c", "susie")
                    cutscene:text("* That's how it went with Berdly, right?", "angry", "susie")
                    cutscene:text("* But then he was..[wait:3] You know..", "pensive", "ralsei")
                    cutscene:text("* ...[wait:4]Yeah.", "annoyed_down", "susie")
                end)
                return true
            elseif self.sneo.deal==5 then
                self.sneo:registerAct("Charge")
                Game.battle:startCutscene(function(cutscene)
                    cutscene:after(function()
                        Game.battle:setState("ACTIONSELECT")
                    end)
                    cutscene:text("* Susie I Think It Is Completely: Useless", "pout", "queen")
                    cutscene:text("* This Ice Can Not Break", "down_a", "queen")
                    cutscene:text("* ...", "annoyed_down", "susie")
                    cutscene:text("* Then how about you use your chair on FIRE?", "annoyed", "susie")
                    cutscene:text("* I Cannot Melt The Ice Without Burning Him To A Crisp", "true", "queen")
                    cutscene:text("* Right..", "annoyed_down", "susie")
                    cutscene:text("* ...", "neutral_side", "susie")
                    cutscene:text("* Come on just a little more!!", "teeth", "susie")
                    cutscene:text("* Susie...", "frown_b", "ralsei")
                    cutscene:text("* Kris,[wait:2] maybe we should think of another way before Susie hurts herself...", "smile", "ralsei")
                    cutscene:text("* Or someone else...", "small_smile_side", "ralsei")
                end)
                return true
            end
        end
    end
end

function secret_battle:onCharacterTurn(battler, undo)
    print(battler.chara.name)
    if self.intro and not self.intro_actions_boxes_depla and not undo then
        if battler.chara.name == "Susie" then
            Game.battle.timer:tween(0.5, self.alpha_masks[2], {alpha=1})
            Game.battle.timer:tween(0.5, self.alpha_masks[4], {alpha=1})
            Game.battle.timer:tween(0.5, Game.battle.battle_ui.action_boxes[1], {x = 108 + (1 - 1) * (213 + 1)}, nil, function()
                Game.battle.battle_ui.action_boxes[1].x = 108 + (1 - 1) * (213 + 1)
            end)
            Game.battle.timer:tween(0.5, Game.battle.battle_ui.action_boxes[2], {x = 108 + (2 - 1) * (213 + 1)}, nil, function()
                Game.battle.battle_ui.action_boxes[2].x = 108 + (2 - 1) * (213 + 1)
            end)
        elseif battler.chara.name == "Ralsei" then
            Game.battle.timer:tween(0.5, self.alpha_masks[3], {alpha=1})
            Game.battle.timer:tween(0.5, self.alpha_masks[5], {alpha=1})
            Game.battle.timer:tween(0.5, Game.battle.battle_ui.action_boxes[1], {x = 0 + (1 - 1) * (213 + 0)}, nil, function()
                Game.battle.battle_ui.action_boxes[1].x = 0 + (1 - 1) * (213 + 0)
            end)
            Game.battle.timer:tween(0.5, Game.battle.battle_ui.action_boxes[2], {x = 0 + (2 - 1) * (213 + 0)}, nil, function()
                Game.battle.battle_ui.action_boxes[2].x = 0 + (2 - 1) * (213 + 0)
            end)
            Game.battle.timer:tween(0.5, Game.battle.battle_ui.action_boxes[3], {x = 0 + (3 - 1) * (213 + 0)}, nil, function()
                Game.battle.battle_ui.action_boxes[3].x = 0 + (3 - 1) * (213 + 0)
            end)
            self.intro_actions_boxes_depla = true
        end
    end
    super:onCharacterTurn(self, battler, undo)
end

function secret_battle:getPartyPosition(index)
    local x, y = 0, 0
    if index == 1 then
        x, y = 170, 150
    elseif index == 2 then
        x, y = 160, 230
    elseif index == 3 then
        x, y = 155, 300
    end

    return x, y
end

function secret_battle:getDialogueCutscene()
    if self.noelle.health<=0 then
        return function(cutscene)
            cutscene:wait(0.75)
            self.noelle.fly_anim = false
            self.noelle:flash()
            Assets.playSound("bump")
            Assets.playSound("break2")
            self.noelle:shake(2, 0, 0)
            Game.battle.timer:tween(1, self.noelle, {x=self.noelle.x+20}, "out-cubic")
            local wait_value = 1
            Game.battle.music:fade(0, 1)
            while wait_value>=0.1 do
                cutscene:wait(wait_value)
                self.noelle:shake(10-wait_value*5)
                self.noelle:flash()
                Assets.playSound("bump")
                Assets.playSound("break2")
                wait_value = wait_value - 0.1
            end
            Assets.playSound("break2")
            Assets.playSound("break2", 1, 1.5)
            Assets.playSound("mus_sfx_abreak")
            self.noelle:setSprite("magical_collapse")
            local wind = Assets.playSound("wind_blow", 1, 1.1)
            Game.fader:fadeIn(nil, {speed=3, alpha=1, color={1, 1, 1}})
            local gradient = Sprite("effects/icespell/gradient")
            gradient:setWrap(true, false)
            gradient.layer = BATTLE_LAYERS["top"]
            gradient:setScale(2)
            gradient.alpha = 0.5
            Game.battle:addChild(gradient)
            local snow_effect = ParticleEmitter(self.noelle.sprite.width/2, self.noelle.sprite.height/2, 0, 0, {
                layer = self.noelle.layer-1,
                every = 1/60,
                amount = 8,
                texture = "lonelysnow",
                scale = 1,
                remove_after = 5,

                physics = {
                    speed = 24
                },
                angle = {math.rad(0), math.rad(380)}
            })
            self.noelle:addChild(snow_effect)
            for i,battler in ipairs(Game.battle.party) do
                battler:setAnimation("battle/defend_ready")
                Game.battle.timer:tween(1, battler, {x=battler.x-Utils.random(30, 50)}, "out-cubic")
            end
            Game.battle.timer:tween(1, self.queen, {x=-680}, "out-cubic")
            Game.battle.timer:tween(1, self.sneo, {x=-680, rotation=math.rad(-45)}, "out-cubic")
            Game.stage:shake(4, 0, 0)
            cutscene:wait(7.5)
            Game.stage:stopShake()
            Game.fader:fadeIn(nil, {alpha=1, color={1, 1, 1}})
            Assets.playSound("mus_sfx_abreak")
            snow_effect:remove()
            gradient:remove()
            self.ice_fountain:remove()
            self.ice_floor:remove()
            self.true_fountain.visible = true
            self.fountain_floor.visible = true
            Game.battle.timer:everyInstant(0.2, function()
                local vol = wind:getVolume()-0.1*DTMULT
                print(vol)
                wind:setVolume(vol < 0 and 0 or vol)
                if vol<=0 then return false end
            end)
            cutscene:wait(2)
            Game.battle.timer:tween(1, self.noelle, {y=300}, "in-quint", function()
                Assets.playSound("noise")
                self.noelle:setSprite("collapsed")
            end)
            cutscene:wait(2.5)
            cutscene:after(function()
                Game.battle:setState("VICTORY")
            end, true)
        end
    end
    if not self.intro and not self.dialogue_cutscene then
        self.dialogue_cutscene = true
        return function(cutscene)
            cutscene:text("* T-[wait:2]The fountain!", "concern", "ralsei")
            cutscene:text("* Damn, she really transformed it into an ice pillar.", "nervous", "susie")
            cutscene:text("* What will that do?", "nervous_side", "susie")
            cutscene:text("* With the fountain like that, I suspect it's like it doesn't exist anymore.", "small_smile_side", "ralsei")
            cutscene:text("* So this world will lose its shape[wait:5] and every Darkner will turn to statues...", "frown", "ralsei")
            cutscene:text("* Alright,[wait:3] that gives us more reason to save Noelle then..", "nervous_side", "susie")
        end
    elseif self.berdly and not self.berdly_awoken and (self.berdly.mercy>=50 or self.berdly.fake_health<=self.berdly.max_health/2) then
        self.berdly_current_hp = self.berdly.fake_health
        self.berdly_awoken = true
        self.berdly.dialogue = {}
        self.berdly.check = "AT 1 DEF 1\n* Finally breaking the ice!"
        self.berdly.text = {
            "* Smells like frozen chicken.",
            "* Berdly tries to break the ice by gyrating his hips, but they are frozen.",
            "* Berdly tells the chimical composition of ice.",
            "* Berdly tries to t-bag his way out of the ice.",
            "* Berdly tries to convince Queen to use her chair's fire on him.\n* Queen wasn't listening.",
            "* Noelle looks fustrated."
        }
        self.berdly.health = Game.battle.party[3].chara:getStat("magic") * 5.5
        self.berdly.name = "Berdly"
        return function(cutscene)
            cutscene:wait(1)
            self.berdly:shake(4)
            cutscene:wait(0.5)
            cutscene:text("* m-...", nil, "berdly")
            cutscene:text("* Did he..[wait:3] try to talk?", "nervous_side", "susie")
            cutscene:text("* Life Force Detected", "surprise", "queen")
            cutscene:text("* Do Any Of You Have Something That Helps With Life Support", "analyze", "queen")
            cutscene:text("* Uh??[wait:3] Wait..", "shy_b", "susie")
            cutscene:text("* I mean,[wait:2] I have healing magic, but..", "shy", "susie")
            cutscene:text("* That's okay, Susie, I'll do it.", "wink", "ralsei")
            local ralsei = cutscene:getCharacter("ralsei")
            ralsei:setAnimation("battle/spell")
            Assets.playSound("snd_spellcast")
            cutscene:wait(cutscene:fadeOut(0.35, {color={1, 1, 1}}))
            cutscene:wait(0.5)
            self.berdly.actor.path = "enemies/berdly/awoken"
            self.berdly:setSprite("idle_surprised")
            Assets.playSound("power")
            cutscene:wait(cutscene:fadeIn(1))
            cutscene:wait(0.5)
            cutscene:text("* ...", "retribution_2", "berdly")
            cutscene:text("* What... What the...", "shock", "berdly")
            cutscene:text("* Wow...[wait:3] he's actually...[wait:3] alive.", "nervous_side", "susie")
            cutscene:text("* Su-Susan?![wait:3] Kris?!", "shock", "berdly")
            cutscene:text("* Wh-What is going on?[wait:2] Is it one of your idiotic pranks?", "sweat", "berdly")
            cutscene:text("* Uhh...[wait:3] We're fighting you.", "neutral", "susie")
            cutscene:text("* Because Noelle brought you here.", "neutral_side", "susie")
            if self.noelle.visible then
                cutscene:text("* No-Noelle! What happened to her??", "shock", "berdly")
            else
                cutscene:text("* Noelle! Where is she??", "shock", "berdly")
            end
            cutscene:text("* Kris![wait:2] What have you done to her??", "angry_2", "berdly")
            cutscene:text("* Back off, bucko.[wait:5] Kris is probably as shocked as you.", "annoyed", "susie")
            cutscene:text("* What are you saying..?", "shock", "berdly")
            cutscene:text("* Look, Noelle got something on her finger that may be what makes her all weird.", "neutral", "susie")
            cutscene:text("* So we break it and everyone's happy,[wait:2] got it?", "neutral_side", "susie")
            cutscene:text("* ...[wait:5]And why should I believe you out of all people?", "hmm", "berdly")
            cutscene:text("* Because I'm on the good guys team?", "nervous_side", "susie")
            cutscene:text("* Yes Burghley Join The Good Side", "neutral", "queen")
            cutscene:text("* It Is Way Hotter Here Thanks To: My Floating Chair", "true", "queen")
            cutscene:text("* M-My queen, I-..", "surprised", "berdly")
            cutscene:text("* Well..[wait:3] If even Queen is by your side, Kris..", "sweat", "berdly")
            cutscene:text("* Maybe..[wait:2] I judged you too fast.", "retribution_2", "berdly")
            cutscene:text("* So uh..[wait:3] Free me and I'll use my genius for a common cause, alright?", "surprised_smile", "berdly")
            cutscene:text("* Kris, you know what to do.", "smile", "susie")
            self.berdly:setAnimation("idle")
        end
    elseif self.berdly_awoken and self.berdly.fake_health<self.berdly_current_hp then
        self.berdly_current_hp = -999
        return function(cutscene)
            cutscene:wait(0.25)
            cutscene:text("* Ow![wait:2] What are you doing??", "sweat", "berdly")
            cutscene:text("* I don't know,[wait:2] I'm just following Kris.", "neutral_side", "susie")
            cutscene:text("* Well.. Could you please stop smashing your weapons on my weak body?", "sweat", "berdly")
            cutscene:text("* I mean,[wait:1] sure.", "neutral", "susie")
            cutscene:text("* Finally,[wait:1] an intelligent response from you,[wait:1] Susan.", "slight_smile", "berdly")
            cutscene:text("* But only if Kris says so.", "closed_grin", "susie")
            cutscene:text("* ...", "shock", "berdly")
            cutscene:text("* C-[wait:1]Come on, Kris,[wait:2] we're pretty good pals, right?", "sweat", "berdly")
        end
    elseif self.berdly_awoken and (self.berdly.mercy>=90 or self.berdly.fake_health<=self.berdly.max_health/9) then
        return function(cutscene)
            cutscene:wait(1)
            self.berdly:shake(4)
            cutscene:wait(0.5)
            cutscene:text("* Ah finally!", "pleased", "berdly")
            cutscene:text("* I can slowly feel this cold prison breaking.", "pleased", "berdly")
            cutscene:text("* Soon, my genius will serve an exquisite cause!", "pretencious", "berdly")
            cutscene:text("* Yeah,[wait:2] uh,[wait:2] whatever you say dude.[wait:4] Just let us end the job.", "annoyed", "susie")
            cutscene:text("* Of course, Susan![wait:2] Do not mind my rambling.[react:1]", "question", "berdly", {reactions={
                    {"He's actually\nbeing nice??", "right", "bottommid", "nervous_side", "susie"}
                }})
            cutscene:text("* [speed:0.5]...", "crazy-snow", "noelle")
            cutscene:text("* ...[wait:4]I don't like Noelle's silence...", "sus_nervous", "susie")
            cutscene:text("* I Estimate A 99.9% Chance That Something Bad Will Happen", "down_a", "queen")
            cutscene:text("* Well it's still not a 100% chance at least...", "pleased", "ralsei")
            cutscene:text("* Can you simpletons tell me what you're talking about over there?", "hmm", "berdly")
            cutscene:text("* [speed:0.2]...Snowgrave", "crazy-snow", "noelle", {advance=false, skip=false, auto=true})
            cutscene:wait(0.75)
            local object = SnowGraveSpell(self.noelle, self.berdly, false)
            object.damage = math.ceil(((13 * 40) + 600))
            object.layer = BATTLE_LAYERS["above_ui"]
            Game.battle:addChild(object)

            Game.battle.party[1]:shake(1)

            Game.battle.party[2]:setSprite("shock_right")
            Game.battle.party[2]:shake(5)

            Game.battle.party[3]:setSprite("battle/hurt")
            Game.battle.party[3]:shake(5)

            self.berdly:setSprite("idle_surprised")
            self.berdly:shake(5)

            cutscene:wait(function()
                return object.timer>75
            end)
            local ice = Sprite("berdly_ice", 450, 100)
            ice:setScale(2)
            Game.battle:addChild(ice)
            self.berdly:remove()
            table.remove(Game.battle.enemies, 2)
            self.berdly = nil
            cutscene:wait(function()
                return object.parent==nil
            end)
            cutscene:wait(1)
            cutscene:text("* [speed:0.3]...", "concern", "ralsei")
            cutscene:text("* [speed:0.3]That's...", "concern_smile", "ralsei")
            cutscene:text("* Error No Way To Explain That", "@@", "queen")
            cutscene:text("* [speed:0.5]What...[wait:5] The...", "sad_frown", "susie")
            cutscene:wait(1)
            Game.battle.party[2]:setSprite("point_right")
            Game.battle.party[3]:setAnimation("battle/idle")
            cutscene:text("* What the HELL[wait:3], Noelle?!", "angry_b", "susie")
            cutscene:text("* How could you do THAT to HIM??", "angry_b", "susie")
            cutscene:text("* Not even HE deserves that!", "angry_c", "susie")
            Game.battle.timer:tween(3, ice, {x=700, y=560, rotation=math.rad(90)}, "in-quad")
            cutscene:text("* Ha ha ha...[wait:3] You can yell, Susie. I don't care.", "crazy-side", "noelle")
            Game.battle.party[2]:setSprite("walk/right")
            cutscene:text("* Sure[wait:2], but do you think you're reaching out to Kris by killing their friends?", "annoyed", "susie")
            cutscene:text("* [shake:1]...", "crazy-snow_surprised", "noelle")
            cutscene:text("* [shake:1]If one was not enough..[wait:3] it's fine.", "crazy-snow_surprised", "noelle")
            cutscene:text("* [shake:1]..Then I'll continue with you two.", "crazy-snow", "noelle")
            Game.battle.party[2]:setSprite("shock_right")
            cutscene:text("* Uh??[wait:2] Wait, that's not--", "surprise_frown", "susie")
            Game.battle.party[2]:setSprite("walk/right")
            cutscene:text("* Does she still even care about Kris at this point..?", "sus_nervous", "susie")
            cutscene:text("* Noelle Honey", "down_b", "queen")
            cutscene:text("* [shake:1]And I have the PERFECT person to accomplish this.", "crazy-snow", "noelle")
            self.berdly_awoken = false
            self.noelle.fly_anim = false
            cutscene:wait(cutscene:slideTo(self.noelle, self.noelle.x, -20))
            table.remove(Game.battle.enemies, 1)
            self.noelle.visible = false
            self.noelle.sprite.alpha = 0
            self.sneo = self:addEnemy("lost_soul_s", 700, 270)
            cutscene:wait(cutscene:slideTo(self.sneo, 525, self.sneo.y, nil, "out-quad"))
            cutscene:after(function()
                Game.battle:setState("ACTIONSELECT")
                Game.battle.battle_ui.current_encounter_text = "* The lost soul takes a ride!"
                Game.battle.battle_ui.encounter_text:setText(Game.battle.battle_ui.current_encounter_text)
                Game.battle.party[2]:resetSprite()
                Game.battle.party[3]:resetSprite()
            end, true)
        end
    end
    if self.last_section and self.noelle.health<self.noelle.max_health/2 and not self.noelle_final_dialogue then
        self.noelle_final_dialogue = true
        return function(cutscene)
            cutscene:wait(0.5)
            Assets.playSound("break2")
            self.noelle:setAnimation({"battle/idle_conflict", 0.2, true})
            self.noelle:shake(1, 0, 0)
            Game.battle.timer:tween(0.5, self.noelle, {intend_x=self.noelle.intend_x+20}, "out-quint")
            cutscene:wait(0.6)
            cutscene:text("* ...", "crazy-snow_surprised", "noelle")
            cutscene:text("* Wh-[wait:2]What's going on??", "trance-scared","noelle")
            cutscene:text("* Where am I??", "trance-scared", "noelle")
            cutscene:text("* I-[wait:2]It's so cold!", "trance_scared2", "noelle")
            cutscene:text("* Noelle!!", "sad_frown", "susie")
            cutscene:text("* Su-[wait:2]Susie?! Where are you??", "trance-scared", "noelle")
            cutscene:text("* I-[wait:2]I can't see!", "trance_scared2", "noelle")
        end
    end
end

function secret_battle:getVictoryMoney(money) return 0 end
function secret_battle:getVictoryXP(xp) return 1 end

return secret_battle