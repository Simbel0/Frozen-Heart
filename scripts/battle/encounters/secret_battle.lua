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
            cutscene:text("* T-[wait:1]The fountain!", "concern", "ralsei")
            cutscene:text("* Damn, she really transformed it into an ice pillar.", "nervous", "susie")
            cutscene:text("* What will that do?", "nervous_side", "susie")
            cutscene:text("* With the fountain like that, I suspect it's like it doesn't exist anymore.", "small_smile_side", "ralsei")
            cutscene:text("* So this world will lose its shape and every Darkner will turn to stone...", "frown", "ralsei")
            cutscene:text("* Alright,[wait:3] that gives us more reason to save Noelle then..", "nervous_side", "susie")
        end
    end
end

return secret_battle