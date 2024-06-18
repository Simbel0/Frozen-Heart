local Noelle_Battle, super = Class(Encounter)

function Noelle_Battle:init()
    super:init(self)

    self.battleMod=true

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* It will be your fault."

    self.turns = -1

    -- Battle music ("battle" is rude buster)
    self.music = nil
    -- Enables the purple grid battle background
    self.background = false

    self.default_xactions = false

    self.spell_countdown = 0

    self.mercy_states={
        false, --50%
        false, --75%
        false  --90%
    }

    self.spell_cast = ""
    self.susie_dead = false

    -- Add the dummy enemy to the encounter
    self.noelle=self:addEnemy("noelle", 550, 228)

    Game.battle:registerXAction("susie", "Pirouette-X", "CONFUSE\nenemies", 30)
    Game.battle:registerXAction("susie", "Wake Up", "Un-proceed", 15)

    Utils.hook(Game.battle.party[1], "down", function(orig)
        print(self.spell_cast, self.spell_cast=="")
        Game.battle.party[1].is_down = true
        Game.battle.party[1].sleeping = false
        Game.battle.party[1]:toggleOverlay(true)
        if self.spell_cast=="Snowgrave" then
            Game.battle.party[1].overlay_sprite:setAnimation("ice")
        elseif self.spell_cast=="Ice Shock" then
            Game.battle.party[1].overlay_sprite:setSprite("battle/hurt")
        else
            Game.battle.party[1].overlay_sprite:setAnimation("battle/defeat")
        end
        if self.spell_cast=="Ice Shock" then
            print("Chillin")
            Assets.playSound("petrify")
            Game.battle.party[1].overlay_sprite.frozen=true
            Game.battle.party[1].overlay_sprite.freeze_progress=0
            Game.battle.timer:tween(20/30, Game.battle.party[1].overlay_sprite, {freeze_progress=1})
        end
        if Game.battle.party[1].action then
            Game.battle:removeAction(Game.battle:getPartyIndex(Game.battle.party[1].chara.id))
        end
        Game.battle:checkGameOver()
    end)
end

--[[function Noelle_Battle:draw(fade)
    super:draw(self)

    local font = Assets.getFont("main", 16)
    love.graphics.setFont(font)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Nb of turns: ".. self.turns, 4, (DEBUG_RENDER and 16 or -16)+16)
    love.graphics.print("No heal: "    .. tostring(Game:getFlag("no_heal", "undefined")), 4, (DEBUG_RENDER and 16 or -16)+(16*2))
    love.graphics.print("No hit: "      .. tostring(Game:getFlag("no_hit", "undefined")), 4, (DEBUG_RENDER and 16 or -16)+(16*3))
end]]

function Noelle_Battle:onBattleStart()
    if Game:getFlag("plot", 0)==2 then
        self.text = self:getEncounterText()
        self:quickBattle(false)
    end

    self.old_health_amount = Game.battle.party[1].chara.health
    local presence = Kristal.getPresence()
    presence.details = "Fighting against Noelle"
    presence.state = Game.battle.party[1].chara.health.."/"..Game.battle.party[1].chara.stats["health"].." HPs"
    Kristal.setPresence(presence)
    Game.battle.timer:every(1, function()
        if Game.battle.party[1].chara.health ~= self.old_health_amount then
            local presence = Kristal.getPresence()
            presence.state = Game.battle.party[1].chara.health.."/"..Game.battle.party[1].chara.stats["health"].." HPs"
            Kristal.setPresence(presence)
            self.old_health_amount = Game.battle.party[1].chara.health
        end
    end)
end

function Noelle_Battle:onReturnToWorld(events)
    print(Game:getFlag("noelle_battle_status", ""))
    if self.turns<30 and Game:getFlag("noelle_battle_status", "") == "no_trance" then
        Assets.playSound("sparkle_gem")
        Game:setFlag("spamton_boss", true)
    end
end

function Noelle_Battle:beforeStateChange(old, new)
    if new=="DEFENDINGBEGIN" then
        print("Countdown: "..self.spell_countdown)
        if self.spell_countdown<=0 and not self.noelle.killed_once then
            print(self.noelle.health>=22, self.noelle.health)
            if Game.battle.noelle_tension_bar:getTension()>=100 then
                print("Cast SNOWGRAVE")
                self.spell_cast = "SNOWGRAVE"
                Game.battle:startCutscene(function(cutscene)
                    cutscene:text("* Noelle casts SNOWGRAVE!", nil, nil, {wait=false, skip=false})
                    Game.battle.noelle_tension_bar:removeTension(100)
                    self.noelle:castSnowGrave()
                    Game.battle.timer:after(2.75, function()
                        print("KKAKLJ")
                        Game.battle.music:fade(0, 1)
                        Game.battle.party[1]:setAnimation("ice")
                    end)
                    cutscene:after(function() Game.battle:setState(self.susie_dead and "NONE" or "ACTIONSELECT") end, true)
                    cutscene:wait(8)
                    cutscene:endCutscene()
                end)
                return true
            elseif Game.battle.noelle_tension_bar:getTension()>=32 and love.math.random(1,self.noelle.health)<=15 then
                print("Cast HEALTH PRAYER")
                self.spell_countdown=2
                Game.battle:startCutscene(function(cutscene)
                    local wait, text = cutscene:text("* Noelle casts HEALTH PRAYER!", nil, nil, {wait=false})
                    local heal_susie = Utils.random(self.noelle.mercy)>50
                    if heal_susie then
                        print("Heal Susie!")
                        if Game.battle.party[1].chara:getHealth() > Game.battle.party[1].chara:getStat("health")-(Game.battle.party[1].chara:getStat("health")/4) then
                            print("Actually no, her HPs too high")
                            heal_susie = false
                        end
                        if self.noelle.health < math.ceil(55/3) then
                            print("Actually no, my HPs too low")
                            heal_susie = false
                        end
                    end
                    Game.battle.noelle_tension_bar:removeTension(32)
                    self.noelle:castHealthPrayer(heal_susie and Game.battle.party[1] or Game.battle.enemies[1])
                    cutscene:wait(wait)
                    cutscene:after(function() Game.battle:setState("ACTIONSELECT") end, true)
                    cutscene:endCutscene()
                end)
                return true
            elseif self.noelle.health>=22 then
                print("Check here")
                if Game.battle.noelle_tension_bar:getTension()>=32 and love.math.random(1,10)==1 then
                    print("Cast SLEEP MIST")
                    self.spell_countdown=2
                    Game.battle:startCutscene(function(cutscene)
                        cutscene:text("* Noelle casts SLEEP MIST!", nil, nil, {wait=false, skip=false})
                        Game.battle.noelle_tension_bar:removeTension(32)
                        self.noelle:castSleepMist(Game.battle.party[1])
                        cutscene:wait(1.5)
                        cutscene:text("* But Susie was not [color:blue]TIRED[color:reset].")
                        cutscene:after(function() Game.battle:setState("ACTIONSELECT") end, true)
                        cutscene:endCutscene()
                    end)
                    return true
                elseif Game.battle.noelle_tension_bar:getTension()>=8 and love.math.random(1,10)>=7 then
                    print("Cast ICESHOCK")
                    if self.noelle.confused then
                        if love.math.random(1,10)<=7 then
                            print("Or not!")
                            return false
                        end
                    end
                    self.spell_countdown=3
                    self.spell_cast = "Ice Shock"
                    Game.battle:startCutscene(function(cutscene)
                        cutscene:text("* Noelle casts Ice Shock!", nil, nil, {wait=false, skip=false})
                        Game.battle.noelle_tension_bar:removeTension(8)
                        self.noelle:castIceShock(Game.battle.party[1])
                        cutscene:after(function() Game.battle:setState(self.susie_dead and "NONE" or "ACTIONSELECT") end, true)
                        cutscene:wait(1.4)
                        cutscene:endCutscene()
                    end)
                    return true
                end
            end
        end
    end
end

function Noelle_Battle:onStateChange(old, new)
    if new=="DEFENDING" then
        print("---onStateChange---")
        print(old, new)
        print(Game.battle.waves, Game.battle.soul, Game.battle.arena)
        -- Due to a weird softlock possibly caused by Iceshock for some reason, we check if a wave was actually loaded. If not, go back to DEFENDINGBEGIN to retry
        if ((Game.battle.waves and #Game.battle.waves==0) or Game.battle.waves==nil) and Game.battle.soul==nil and Game.battle.arena==nil then
            Game.battle:setState("DEFENDINGBEGIN")
        end
    end
end

function Noelle_Battle:getDialogueCutscene()
    if Game:getFlag("plot", 0)==2 and not self.noelle.killed_once then
        if self.noelle.mercy>=50 and not self.mercy_states[1] then
            Assets.playSound("snd_ominous_cancel")
            self.mercy_states[1]=true
            return function(cutscene)
                cutscene:wait(1)
                cutscene:text("* ...Mmm...", "trance", "noelle")
                cutscene:text("* ...Su...", "sad", "noelle")
                cutscene:text("* ...!", "what", "noelle")
                cutscene:text("* Su-Susie?!", "shock", "noelle")
                cutscene:text("* Noelle! Finally!", "surprise_smile", "susie")
                cutscene:text("* I-I mean, cool, you're back to your sense.", "shy_b", "susie")
                cutscene:text("* Mind stopping trying to kill me now?", "nervous_side", "susie")
                cutscene:text("* Su-Susie, no!", "shock", "noelle")
                cutscene:text("* Run away from-", "dejected", "noelle")
                cutscene:text("* [speed:0.6]...me.....", "down", "noelle")
                cutscene:text("* [speed:0.6]...", "trance", "noelle")
                cutscene:text("* ...Crap.[wait:1] Back to the action I guess.", "sus_nervous", "susie")
            end
        elseif self.noelle.mercy>=75 and not self.mercy_states[2] then
            Assets.playSound("snd_ominous_cancel")
            self.mercy_states[2]=true
            return function(cutscene)
                cutscene:wait(1)
                cutscene:text("* ...Mmm...", "trance", "noelle")
                cutscene:text("* ...Ah!", "shock", "noelle")
                cutscene:text("* Su-Susie?!", "shock", "noelle")
                cutscene:text("* Noelle!!", "angry_b", "susie")
                cutscene:text("* Stay with me this time!", "angry_b", "susie")
                cutscene:text("* We'll get you out of this mess!", "angry_c", "susie")
                cutscene:text("* Su-Susie...[wait:1] You would...", "blush_surprise", "noelle")
                cutscene:text("* ...", "dejected", "noelle")
                cutscene:text("* [speed:0.6]...[wait:1]I believe in...", "down", "noelle")
                cutscene:text("* [speed:0.6]...", "trance", "noelle")
                cutscene:text("* ...[wait:1]Damn it.", "bangs_neutral", "susie")
                cutscene:text("* Just a little more...!", "angry", "susie")
            end
        elseif self.noelle.mercy>=90 and not self.mercy_states[3] then
            Assets.playSound("snd_ominous_cancel")
            self.mercy_states[3]=true
            self.noelle.confused=true
            self.noelle.confusedTimer=4
            return function(cutscene)
                cutscene:wait(1)
                cutscene:text("* ...", "trance", "noelle")
                cutscene:text("* ...!", "shock", "noelle")
                cutscene:text("* Susie!", "shock", "noelle")
                cutscene:text("* Come on, Noelle![wait:1] We're so close!", "teeth_b", "susie")
                cutscene:text("* S-Susie...", "down", "noelle")
                cutscene:text("* You're... Right...", "upset_down", "noelle")
                cutscene:text("* You're right!", "upset", "noelle")
                cutscene:text("* I will fight to stay with you!", "upset", "noelle")
                cutscene:text("* Great, that's the spirit!", "smile", "susie")
                cutscene:text("* Noelle doesn't need to be confused anymore!")
            end
        end
    end
end

function Noelle_Battle:onTurnStart()
    if self.noelle.comment~="(Confused)" and self.noelle.confused then
        self.noelle.comment="(Confused)"
    end
end

function Noelle_Battle:onTurnEnd()
    self.spell_cast=""
    self.spell_countdown=self.spell_countdown-1
    if self.noelle.confused then
        self.noelle.confusedTimer=self.noelle.confusedTimer+1
        if self.noelle.confusedTimer==3 then
            self.noelle.confusedTimer=0
            self.noelle.confused=false
            self.noelle.comment="(Tired)"
            Game.battle:startCutscene(function(cutscene)
                cutscene:text("* Noelle snapped out of the confusion!")
                cutscene:after(function() Game.battle:setState("ACTIONSELECT") end)
                cutscene:endCutscene()
            end)
            return true
        end
    end
    if self.noelle.killed_once then
        Game:setTension(0)
    end
    if Game:getFlag("plot", 0)==2 then
        self.turns=self.turns+1
    end
end

function Noelle_Battle:getEncounterText()
    print("called")
    if Game:getFlag("plot", 0)==2 and not self.firstencountertext then
        self.firstencountertext=true
        return "* Noelle attacks...?"
    end
    return super:getEncounterText(self)
end

function Noelle_Battle:onGameOver()
    if Game:getFlag("plot", 0)<2 then
        Game.battle:finishActionBy(Game.battle.party[1])
        Game.battle.cutscene:endCutscene()
        Game.battle.party[1].sprite.frozen=true
        Game.battle.battle_ui.action_boxes[1]:setHeadIcon("head_error")
        Game.battle:startCutscene("introGameOver")
        return true
    end
    print("oof")
    print(self.spell_cast)
    self.susie_dead = true
    if self.spell_cast=="Ice Shock" then
        Game.battle.cutscene:endCutscene()
        Game.battle:startCutscene(function(cutscene)
            --Assets.playSound("petrify")
            --Game.battle.party[1].sprite.frozen=true
            --Game.battle.timer:tween(20/30, Game.battle.party[1].sprite, {freeze_progress=1})
            local noelle = cutscene:getCharacter("noelle")

            Game.battle.music:fade(0, 1)
            cutscene:wait(3)
            cutscene:text("* [speed:0.6]It was...[wait:1] not easy.", "trance", "noelle")
            cutscene:text("* [speed:0.6]But I still did it.[wait:1] I became stronger, after all...", "down_smile", "noelle")
            cutscene:text("* [speed:0.6]...", "trance", "noelle")
            noelle:setSprite("walk_kill/left")
            noelle.sprite:play(1/8)
            cutscene:slideTo(noelle, noelle.x+500, noelle.y, 10)
            cutscene:wait(cutscene:fadeOut(5))
            cutscene:wait(1)
            Game:setFlag("noelle_battle_status", "iceshock")
            Game.battle:returnToWorld()
        end)
        return true
    elseif self.spell_cast=="Snowgrave" then
        print("a")
        Game.battle.cutscene:endCutscene()
        print("b")
        Game.battle:startCutscene(function(cutscene)
            cutscene:wait(3)
            Assets.playSound("noise")
            self.noelle:setSprite("battle/defeat")
            cutscene:wait(5)
            cutscene:wait(cutscene:fadeOut(3))
            cutscene:wait(1)
            Game:setFlag("noelle_battle_status", "snowgrave")
            Game.battle:returnToWorld()
        end)
        return true
    end
    return false
end

function Noelle_Battle:quickBattle(debug)
    if debug then
        if Game:getFlag("plot", 0)~=2 then
            Game:setFlag("plot", 2)
        end
    end
    Game.battle.music:play("SnowGrave")
    Game.battle.noelle_tension_bar:show()
    self.noelle.waves={
        "snowfall",
        "bettersnowfall",
        "snowabsorb",
        "snowstorm",
        "him",
        "him-alter",
        "snowshotter",
        "snowshotter-alter"
    }
    self.noelle:setAnimation({"battle/trancesition", 0.2, false, next="battle/idleTrance"})
    self.noelle.actor.animations["battle/idle"]=self.noelle.actor.animations["battle/idleTrance"]

    Game.battle.party[1].chara.stats["health"]=190*2
    Game.battle.party[1].chara.stats["attack"]=18*2
    Game.battle.party[1].chara.stats["defense"]=2*2
    Game.battle.party[1].chara.stats["magic"]=3*2
    Game.battle.party[1].chara.health=190*2
    Game:saveQuick("spawn")
    print("Battle ready")
end

return Noelle_Battle