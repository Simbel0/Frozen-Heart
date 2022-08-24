local Noelle_Battle, super = Class(Encounter)

function Noelle_Battle:init()
    super:init(self)

    self.battleMod=true

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* It will be your fault."

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

    -- Add the dummy enemy to the encounter
    self.noelle=self:addEnemy("noelle", 550, 228)

    Game.battle:registerXAction("susie", "Pirouette-X", "CONFUSE\nenemies", 30)
    Game.battle:registerXAction("susie", "Wake Up", "Un-proceed", 15)
end

function Noelle_Battle:beforeStateChange(old, new)
    if new=="DEFENDINGBEGIN" then
        if self.spell_countdown<=0 and not self.noelle.killed_once then
            if Game.battle.noelle_tension_bar:getTension()>=100 then
                print("Cast SNOWGRAVE")
                Game.battle:startCutscene(function(cutscene)
                    cutscene:text("* Noelle casts SNOWGRAVE!", nil, nil, {wait=false, skip=false})
                    Game.battle.noelle_tension_bar:removeTension(100)
                    self.noelle:castSnowGrave(Game.battle.party[1])
                    cutscene:wait(8)
                    cutscene:after(function() Game.battle:setState("ACTIONSELECT") end)
                    cutscene:endCutscene()
                end)
                return true
            elseif Game.battle.noelle_tension_bar:getTension()>=32 and math.random(1,self.noelle.health)<=10 then
                print("Cast HEALTH PRAYER")
                self.spell_countdown=2
                Game.battle:startCutscene(function(cutscene)
                    local wait, text = cutscene:text("* Noelle casts HEALTH PRAYER!", nil, nil, {wait=false})
                    local heal_susie = Utils.random(self.noelle.mercy)>50
                    Game.battle.noelle_tension_bar:removeTension(32)
                    self.noelle:castHealthPrayer(heal_susie and Game.battle.party[1] or Game.battle.enemies[1])
                    cutscene:wait(wait)
                    cutscene:after(function() Game.battle:setState("ACTIONSELECT") end)
                    cutscene:endCutscene()
                end)
                return true
            elseif Game.battle.noelle_tension_bar:getTension()>=32 and math.random(1,10)==1 then
                print("Cast SLEEP MIST")
                self.spell_countdown=2
                Game.battle:startCutscene(function(cutscene)
                    cutscene:text("* Noelle casts SLEEP MIST!", nil, nil, {wait=false, skip=false})
                    Game.battle.noelle_tension_bar:removeTension(32)
                    self.noelle:castSleepMist(Game.battle.party[1])
                    cutscene:wait(1.5)
                    cutscene:text("* But Susie was not [color:blue]TIRED[color:reset].")
                    cutscene:after(function() Game.battle:setState("ACTIONSELECT") end)
                    cutscene:endCutscene()
                end)
                return true
                
            elseif Game.battle.noelle_tension_bar:getTension()>=8 and math.random(1,10)>=7 then
                print("Cast ICESHOCK")
                self.spell_countdown=2
                if self.noelle.confused then
                    if math.random(1,10)>=7 then
                        return true
                    end
                end
                Game.battle:startCutscene(function(cutscene)
                    cutscene:text("* Noelle casts Ice Shock!", nil, nil, {wait=false, skip=false})
                    Game.battle.noelle_tension_bar:removeTension(8)
                    self.noelle:castIceShock(Game.battle.party[1])
                    cutscene:wait(1.4)
                    cutscene:after(function() Game.battle:setState("ACTIONSELECT") end)
                    cutscene:endCutscene()
                end)
                return true
            end
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

function Noelle_Battle:onTurnEnd()
    self.spell_countdown=self.spell_countdown-1
    if self.noelle.confused then
        self.noelle.confusedTimer=self.noelle.confusedTimer+1
        if self.noelle.confusedTimer==3 then
            self.noelle.confusedTimer=0
            self.noelle.confused=false
            self.noelle.comment=""
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
end

function Noelle_Battle:dSB()
    if Game:getFlag("plot", 0)~=2 then
        Game:setFlag("plot", 2)
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
    print("Battle ready")
end

return Noelle_Battle