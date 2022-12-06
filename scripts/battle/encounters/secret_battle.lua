local secret_battle, super = Class(Encounter)

function secret_battle:init()
    super:init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* Snow fills your vision."

    -- Battle music ("battle" is rude buster)
    self.music = "full_circle"
    -- Enables the purple grid battle background
    self.background = false

    self.intro = true
    self.intro_actions_boxes_depla = false

    self.turns = 0

    self.default_xactions = false

    -- Add the dummy enemy to the encounter
    self.noelle = self:addEnemy("ring_noelle", 505, 227)
end

function secret_battle:update()
    if self.intro and Game.battle.music.source then
        local progress = Game.battle.music:tell()
        print(progress, Utils.round(progress))
        if Utils.round(progress)==39 and not self.fade_out_intro then
            Game.fader:fadeOut(nil, {color={1, 1, 1}, speed=1})
            self.fade_out_intro = true
        elseif Utils.round(progress)==41 then
            self.fog:remove()
            self.default_xactions = true
            self.noelle.name = "Noelle"
            self.noelle.text = {
                "* It's so cold.",
                "* The fountain's light is trapped in the cold.",
                "* Everything becomes fantasy.",
                "* Noelle doesn't feel any pain.",
                "* It's cold.",
                "* The flame of Queen's chair warns the party.",
                "* She lost herself.",
                "* The Dark World is losing its shape.",
                "* Light and Dark has succombed.",
                "* The Prophecy is failing.",
                "* The ANGEL'S HEAVEN is taking form.",
                "* You are in danger.",
                "* The air crackles with freedom.",
                "* Frozen statues everywhere."
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
            self.noelle:registerAct("Shield", "Raise Acid\nShield", {"kris"}, 32, nil, {"queen-icon"})
            self.noelle.waves = {
                "secret/aim_snow",
                "secret/icefall",
                "secret/iceshocks",
                "secret/kinda_touhou_ngl",
                "secret/snowReject"
            }
            self.noelle:addChild(self.noelle.snow_effect)

            if self.queen then
                self.queen.alpha = 1
                self.queen:setPosition(40, 145)
            end

            Game.battle.tension_bar:setShortVersion(true)

            Game.fader:fadeIn()
        end
    end

    if self.queen then
        self.queen.y = 145 + math.sin(Kristal.getTime()*4)*10
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
    Game.world:addChild(self.ice_fountain)
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
end

function secret_battle:onTurnEnd()
    if not self.intro then
        self.turns = self.turns + 1
    end
    if self.turns==3 then
        Game.battle:startCutscene(function(cutscene)
            cutscene:after(function() Game.battle:setState("ACTIONSELECT") end)
            cutscene:wait(1/4)
            cutscene:text("* Kris, why do you persist?", "crazy-scared", "noelle")
            cutscene:text("* I became so strong, isn't it what you wanted?", "crazy-neutral", "noelle")
            cutscene:text("* ...", "nervous", "susie")
            cutscene:text("* ...", "surprise_confused", "ralsei")
            cutscene:text("* What The Heck (Hell)", "bro", "queen")
        end)
        return true
    elseif self.turns==7 then
        Game.battle:startCutscene(function(cutscene)
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
            cutscene:text("* My Super Cool Eyes Can See That Noelle Wears Something Really Weird At Her Finger", "true", "queen")
            cutscene:text("* And That Thing Seems Fill With Some Negative Energy", "surprise", "queen")
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
            cutscene:text("* I don't know what possesed you[wait:1] but I'll kick that thing right out of you!", "angry_c", "susie")
            cutscene:text("* Oh Susie... You don't need to do so..", "crazy-side", "noelle")
            cutscene:text("* Perhaps Kris needs a reminder of my full power?", "crazy-side", "noelle")
            cutscene:text("* ..?", "bangs_neutral", "susie")
            cutscene:text("* Don't worry...", "crazy-side", "noelle")

            local ice = Sprite("berdly_ice")
            ice:setPosition(SCREEN_WIDTH+100, 35)
            ice:setScale(2)
            ice:setLayer(BATTLE_LAYERS["below_battlers"])
            Game.battle:addChild(ice)

            Game.battle.party[2]:setSprite("shock")
            Game.battle.party[2].sprite.shake_x=5

            Game.battle.party[3]:setSprite("battle/hurt")
            Game.battle.party[3].sprite.shake_x=5

            Game.battle.timer:tween(3, ice, {x=self.noelle.x-50, y=self.noelle.y-180, rotation=math.rad(45)}, "out-back")
            cutscene:wait(3)

            cutscene:text("* Let's go back a little back then, won't we?", "crazy-snow", "noelle")

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
        end)
        return true
    elseif self.turns == 11 then
        table.insert(Game.battle.enemies, 1, self.noelle)
        self.noelle.visible = true
        self.noelle.intend_x = 500
        self.noelle.intend_y = 140
        self.noelle.sprite.alpha = 1
        self.berdly:setAnimation("idle_surprised")
        if self.berdly_awoken then
            Game.battle:startCutscene(function(cutscene)
                cutscene:after(function()
                    Game.battle:setState("ACTIONSELECT")
                end)
                cutscene:wait(cutscene:fadeOut(0, {color={1, 1, 1}}))
                cutscene:fadeIn(0.5)
                cutscene:wait(0.4)
                cutscene:text("* So Kris, what do you think?", "crazy-side", "noelle")
                cutscene:text("* ...", "crazy-scared", "noelle")
                cutscene:text("* No-Noelle!", "shock", "berdly")
                cutscene:text("* Come on! It's me, Berdly!", "slight_smile", "berdly")
                cutscene:text("* You've... Freed him..?", "crazy-scared", "noelle")
                cutscene:text("* No no nO NO!!", "crazy-insane", "noelle")
                cutscene:text("* WHY?? WHY did you CHANGE?!", "crazy-insane", "noelle")
                cutscene:text("* Why do you want to SAVE him NOW???", "crazy-insane", "noelle")
                cutscene:text("* No-Noelle...", "sad", "berdly")
                cutscene:text("* Don't listen to her, she lost it.", "nervous_side", "susie")
                cutscene:text("* Like.. really...", "shy_down", "susie")
                cutscene:text("* Fine Kris. I understand.", "crazy-neutral", "noelle")
                cutscene:text("* Maybe it wasn't FAR enough to remind you of what we did.", "crazy-side", "noelle")
                cutscene:text("* Then watch me use HIM as my puppet.", "crazy-snow", "noelle")
                cutscene:text("* I-..[wait:3] I didn't sign up for this..![react:1]", "sweat", "berdly", {reactions={
                    {"You think any of\nus did??", "right", "bottommid", "teeth_b", "susie"}
                }})
            end)
        else
            Game.battle:startCutscene(function(cutscene)
                cutscene:wait(cutscene:fadeOut(0, {color={1, 1, 1}}))
                cutscene:fadeIn(1)
                cutscene:wait(1)
                cutscene:text("* So Kris, what do you think?", "crazy-side", "noelle")
                cutscene:text("* ...", "crazy-side", "noelle")
                cutscene:text("* So you continue to ignore me.", "crazy-side", "noelle")
                cutscene:text("* But that's fine.", "crazy-neutral", "noelle")
                cutscene:text("* Soon, we will continue what we started.", "crazy-neutral", "noelle")
                cutscene:text("* Together! Again!", "crazy-snow", "noelle")
                cutscene:text("* Don't listen to her, she lost it.", "nervous_side", "susie")
                cutscene:text("* Like.. really...", "shy_down", "susie")
            end)
        end
        return true
    end
end

function secret_battle:onCharacterTurn(battler, undo)
    print(battler.chara.name)
    if self.intro and not self.intro_actions_boxes_depla and not undo then
        if battler.chara.name == "Susie" then
            Game.battle.timer:tween(0.5, self.alpha_masks[2], {alpha=1})
            Game.battle.timer:tween(0.5, self.alpha_masks[4], {alpha=1})
            Game.battle.timer:tween(0.5, Game.battle.battle_ui.action_boxes[1], {x = 108 + (1 - 1) * (213 + 1)})
            Game.battle.timer:tween(0.5, Game.battle.battle_ui.action_boxes[2], {x = 108 + (2 - 1) * (213 + 1)})
        elseif battler.chara.name == "Ralsei" then
            Game.battle.timer:tween(0.5, self.alpha_masks[3], {alpha=1})
            Game.battle.timer:tween(0.5, self.alpha_masks[5], {alpha=1})
            Game.battle.timer:tween(0.5, Game.battle.battle_ui.action_boxes[1], {x = 0 + (1 - 1) * (213 + 0)})
            Game.battle.timer:tween(0.5, Game.battle.battle_ui.action_boxes[2], {x = 0 + (2 - 1) * (213 + 0)})
            Game.battle.timer:tween(0.5, Game.battle.battle_ui.action_boxes[3], {x = 0 + (3 - 1) * (213 + 0)})
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
    elseif self.berdly and not self.berdly_awoken and self.berdly.mercy>=50 then
        self.berdly_awoken = true
        self.berdly.dialogue = {}
        self.berdly.check = "AT 1 DEF 1\n* You're finally breaking the ice!"
        self.berdly.text = {
            "* Smells like frozen chicken.",
            "* Berdly tries to break the ice by gyrating his hips!",
            "* Berdly tells the chimical composition of ice.",
            "* Berdly tries to t-bag his way out of the ice.",
            "* Noelle looks fustrated."
        }
        self.berdly.health = Game.battle.party[3].chara:getStat("magic") * 5.5
        self.berdly.name = "Berdly"
        return function(cutscene)
            cutscene:wait(1)
            self.berdly.sprite.shake_x = 4
            cutscene:wait(0.5)
            cutscene:text("* m-...", nil, "berdly")
            cutscene:text("* Did he..[wait:3] tried to talk?", "nervous_side", "susie")
            cutscene:text("* Life Force Detected", "surprise", "queen")
            cutscene:text("* Does One Of You Have Something That Helps With Life Support", "analyze", "queen")
            cutscene:text("* Uh??[wait:3] Wait..", "shy_b", "susie")
            cutscene:text("* I mean,[wait:2] I have healing magic, but..", "shy", "susie")
            cutscene:text("* That's okay, Susie, I'll do it.", "wink", "ralsei")
            local ralsei = cutscene:getCharacter("ralsei")
            ralsei:setAnimation("battle/spell")
            cutscene:wait(cutscene:fadeOut(0.35, {color={1, 1, 1}}))
            cutscene:wait(0.5)
            self.berdly.actor.path = "enemies/berdly/awoken"
            self.berdly:setSprite("idle_surprised")
            cutscene:wait(cutscene:fadeIn(1))
            cutscene:wait(0.5)
            cutscene:text("* ...", "retribution_2", "berdly")
            cutscene:text("* What... What the...", "shock", "berdly")
            cutscene:text("* Wow...[wait:3] he's actually...[wait:3] alive.", "nervous_side", "susie")
            cutscene:text("* Su-Susan?![wait:3] Kris?!", "shock", "berdly")
            cutscene:text("* Wh-What is going on?[wait:2] Is it one of your idiotic prank?", "sweat", "berdly")
            cutscene:text("* Uhh...[wait:3] We're fighting you.", "neutral", "susie")
            cutscene:text("* Because Noelle brought you here.", "neutral_side", "susie")
            cutscene:text("* Noelle! Where is she?", "shock", "berdly")
            cutscene:text("* Kris![wait:2] What have you done to her??", "angry_2", "berdly")
            cutscene:text("* Back off, bucko.[wait:5] Kris is probably as shocked as you.", "annoyed", "susie")
            cutscene:text("* What is the meaning of your claims..?", "shock", "berdly")
            cutscene:text("* Look, Noelle got something on her finger that may be what makes her all weird.", "neutral", "susie")
            cutscene:text("* So we break it and everyone's happy,[wait:2] got it?", "neutral_side", "susie")
            cutscene:text("* ...[wait:5]And why should I believe you out of all people?", "hmm", "berdly")
            cutscene:text("* Because I'm on the good guys team?", "nervous_side", "susie")
            cutscene:text("* Yes Burghley Join The Good Side", "neutral", "queen")
            cutscene:text("* It Is Way Hotter Here Thanks To: My Floating Chair", "true", "queen")
            cutscene:text("* M-My queen, I-..", "surprised", "berdly")
            cutscene:text("* Well..[wait:3] If even Queen is by your side, Kris..", "sweat", "berdly")
            cutscene:text("* Maybe..[wait:2] I judged you too fast.", "retribution_2", "berdly")
            cutscene:text("* So uh..[wait:3] Free me and I'll put my genius to a common cause, alright?", "surprised_smile", "berdly")
            cutscene:text("* Kris, you know what to do.", "smile", "susie")
            self.berdly:setAnimation("idle")
        end
    end
end

return secret_battle