local Memories, super = Class(EnemyBattler)

function Memories:init()
    super:init(self)

    self.music = Music()

    -- Enemy name
    self.name = ""
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("dummy")
    self.actor.path = "enemies/memories"
    self.alpha = 0

    self.actor.offsets["spamton"] = {0, 10}
    self.actor.offsets["kris"]    = {-8, 6}
    self.actor.offsets["berdly"]  = {-26, 3}
    self.actor.offsets["queen"]   = {-21, -41}
    self.actor.offsets["rudy"]    = {3, -19}
    self.actor.offsets["susie"]   = {-4, 0}
    self.actor.offsets["dess"]    = {2, 2}

    self.rect_x, self.rect_y = 0, 0
    self.rect_offsets = {
        {-5+Utils.random(0, 2)*Utils.randomSign(), 2},
        {5+Utils.random(0, 2)*Utils.randomSign(), -2},
        {2, 5+Utils.random(0, 2)*Utils.randomSign()}
    }
    Game.battle.timer:every(0.35, function()
        self.rect_offsets = {
            {-5+Utils.random(0, 2)*Utils.randomSign(), 2},
            {5+Utils.random(0, 2)*Utils.randomSign(), -2},
            {2, 5+Utils.random(0, 2)*Utils.randomSign()}
        }
    end)
    self.rect_pos = {
        spamton = {6, 14},
        kris = {8, 12},
        berdly = {0, 9},
        queen = {13, -24},
        rudy = {5, -7},
        susie = {2, 7},
        dess = {6, 6}
    }

    -- Enemy health
    self.max_health = 1
    self.health = 1
    -- Enemy attack (determines bullet damage)
    self.attack = 6
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 0

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    self.disable_mercy = true

    -- List of possible wave ids, randomly picked each turn
    self.waves = {}

    -- Dialogue randomly displayed in the enemy's speech bubble
    --self.dialogue = {
    --    "..."
    --}

    -- Check text (automatically has "ENEMY NAME - " at the start)
    --self.check = "AT 4 DF 0\n* Cotton heart and button eye\n* Looks just like a fluffy guy."

    table.remove(self.acts, 1)

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "",
    }

    self.shader = love.graphics.newShader([[
        vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
        {
            vec4 pixel = Texel(tex, texture_coords);

            float gray = dot(pixel.rgb, vec3(0.299, 0.587, 0.114));

            return vec4(gray, gray, gray, color.a*pixel.a);
        }
    ]])

    self.remember = 0
    self:registerAct("Remember")

    self:setSprite("dummy")
end

function Memories:onAct(battler, name)
    if name == "Remember" then
        self.remember = self.remember + 1
        if Game.party[1].health < Game.party[1].stats.health then
            local amount = math.ceil(166/3)
            if self.remember == 25 then
                amount = 999
            end
            Game.party[1]:heal(amount)
        end

        local path = "secret/memories/"

        --Spamton
        if self.remember == 1 then
            self.wave_override = path.."spamton_1"
            Game.battle:startActCutscene(function(cutscene)
                cutscene:text("* Noelle closes her eyes,[wait:5] and start to think of something among her memories.")
                cutscene:text("* [speed:0.1]...")
                self:setSprite("spamton")
                cutscene:text("* Suddenly,[wait:5] she remembers a scammer willing to help her.")
            end)
            return
        elseif self.remember == 2 then
            self.wave_override = path.."spamton_2"
            return {
                "* Noelle asks the man about something she's searching for.",
                "* An ad for a spyware pops up."
            }
        elseif self.remember == 3 then
            self.wave_override = path.."spamton_3"
            return {
                "* Noelle asks the man about his pet.",
                "* Upon seeing it, Noelle is amused and thanks the man."
            }
        elseif self.remember == 4 then
            self:setSprite("dummy")
            return {
                "* The memories are complete.",
                "* She may not cherish them,[wait:2] but she is grateful to Spamton for his \"help\"."
            }
        end
        --Kris
        if self.remember == 5 then
            self.wave_override = path.."kris_1"
            Game.battle:startActCutscene(function(cutscene)
                cutscene:text("* Noelle closes her eyes,[wait:5] and start to think of something among her memories.")
                cutscene:text("* [speed:0.1]...")
                self:setSprite("kris")
                cutscene:text("* Suddenly,[wait:5] she remembers her childhood friend.")
            end)
            return
        elseif self.remember == 6 then
            self.wave_override = path.."kris_2"
            return {
                "* Noelle asks her friend about their pranks.",
                "* The friend laughs,[wait:2] and Noelle can't help but laugh too,[wait:2] now."
            }
        elseif self.remember == 7 then
            self.wave_override = path.."kris_3"
            return {
                "* Noelle ask her friend about everything they've done.",
                "* The friend wished it didn't happen.[wait:3] Noelle understands and forgives them."
            }
        elseif self.remember == 8 then
            self:setSprite("dummy")
            return {
                "* The memories are complete.",
                "* Even though their relationship has degraded,[wait:2] she will always consider Kris a great friend."
            }
        end
        --Berdly
        if self.remember == 9 then
            self.wave_override = path.."berdly_1"
            Game.battle:startActCutscene(function(cutscene)
                cutscene:text("* Noelle closes her eyes,[wait:5] and start to think of something among her memories.")
                cutscene:text("* [speed:0.1]...")
                self:setSprite("berdly")
                cutscene:text("* Suddenly,[wait:5] she remembers her school partner.")
            end)
            return
        elseif self.remember == 10 then
            self.wave_override = path.."berdly_2"
            return {
                "* Noelle asks her partner about his hobbies.",
                "* She starts to regret it as he just doesn't stop talking."
            }
        elseif self.remember == 11 then
            self.wave_override = path.."berdly_3"
            return {
                "* Noelle asks her partner about why he's obsessed with being smart.",
                "* Upon hearing his answer,[wait:2] Noelle remembers this day."
            }
        elseif self.remember == 12 then
            self:setSprite("dummy")
            return {
                "* The memories are complete.",
                "* He messed up sometimes,[wait:2] but Berdly will always be a great friend to her."
            }
        end
        --Queen
        if self.remember == 13 then
            self.wave_override = path.."queen_1"
            Game.battle:startActCutscene(function(cutscene)
                cutscene:text("* Noelle closes her eyes,[wait:5] and start to think of something among her memories.")
                cutscene:text("* [speed:0.1]...")
                self:setSprite("queen")
                cutscene:text("* Suddenly,[wait:5] she remembers the ruler that kidnapped her.")
            end)
            return
        elseif self.remember == 14 then
            self.wave_override = path.."queen_2"
            return {
                "* Noelle asks the ruler for why she did all of that.",
                "* Her respose is unclear,[wait:2] but Noelle feels that she had good intentions."
            }
        elseif self.remember == 15 then
            self.wave_override = path.."queen_3"
            return {
                "* Noelle asks the ruler what she knows about her.",
                "* The ruler goes into deep details about Noelle's troubles."
            }
        elseif self.remember == 16 then
            self:setSprite("dummy")
            return {
                "* The memories are complete.",
                "* Despite being scared of her,[wait:2] she feels like Queen was willing to help her somehow."
            }
        end
        --Rudy
        if self.remember == 17 then
            self.wave_override = path.."rudy_1"
            Game.battle:startActCutscene(function(cutscene)
                cutscene:text("* Noelle closes her eyes,[wait:5] and start to think of something among her memories.")
                cutscene:text("* [speed:0.1]...")
                self:setSprite("rudy")
                cutscene:text("* Suddenly,[wait:5] she remembers her ill father.")
            end)
            return
        elseif self.remember == 18 then
            self.wave_override = path.."rudy_2"
            return {
                "* Noelle asks her father about a life without him.",
                "* He only smiles and laughs,[wait:2] claiming it's not gonna be his time anytime soon."
            }
        elseif self.remember == 19 then
            self.wave_override = path.."rudy_3"
            return {
                "* Noelle asks her father about a life without her.",
                "* His tone becomes more grim and sad."
            }
        elseif self.remember == 20 then
            self:setSprite("dummy")
            return {
                "* The memories are complete.",
                "* She will always be thankful to Rudy for being a great and optimistic father."
            }
        end
        --Susie
        if self.remember == 21 then
            self.wave_override = path.."susie_1"
            Game.battle:startActCutscene(function(cutscene)
                cutscene:text("* Noelle closes her eyes,[wait:5] and start to think of something among her memories.")
                cutscene:text("* [speed:0.1]...")
                self:setSprite("susie")
                cutscene:text("* Suddenly,[wait:5] she remembers the bully she admires from afar.")
            end)
            return
        elseif self.remember == 22 then
            self.wave_override = path.."susie_2"
            return {
                "* Noelle asks the bully why she ignores her despite her attempts.",
                "* The answer is muffled and feels fake."
            }
        elseif self.remember == 23 then
            self.wave_override = path.."susie_3"
            return {
                "* Noelle asks the bully if she want to go on the ferris wheel with her.",
                "* To Noelle's joy,[wait:2] the bully answers positively."
            }
        elseif self.remember == 24 then
            self:setSprite("dummy")
            return {
                "* The memories are complete.",
                "* She regrets not being able to be closer to Susie,[wait:2] but she is glad to have met her."
            }
        end
        --Dess
        if self.remember == 25 then
            Game.battle:startActCutscene(function(cutscene)
                Game.battle.music:stop()
                self.music:play("memories_dess", 1, 1)
                self.music.source:setLooping(false)

                self.encounter.ending = true
                local wait, text = cutscene:text("[noskip]* [speed:0.1]...............", {wait=false})
                cutscene:wait(function()
                    if Game.battle.party[1].chara:getHealth() <= 100 then
                        return true
                    end
                    return wait()
                end)
                self:setSprite("dess")
                cutscene:text("* [speed:0.1]Maybe...[wait:5]\n* Maybe everything is going to be okay.", {advance=false, wait=false, skip=false})
                cutscene:wait(function()
                    return self.encounter.alpha_fx.alpha <= 0.1
                end)
                cutscene:wait(2)
                Game.battle.battle_ui.encounter_text.text:setText("")
                self:setSprite("dummy")
                cutscene:wait(cutscene:fadeOut(5, {color={0, 0, 0}}))
                cutscene:wait(3)
                Assets.playSound("monsterdust", 0.1)
                cutscene:wait(3)
                Game.battle:returnToWorld()
            end)
            return
        end

    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super:onAct(self, battler, name)
end

function Memories:setSprite(sprite, speed, loop, after)
    if sprite == "dummy" then
        self:fadeTo(0, 3, function() super:setSprite(self, sprite, speed, loop, after) end)
        if self.remember < 25 then
            self.music:fade(0, 3)
        end
    else
        super:setSprite(self, sprite, speed, loop, after)
        self:fadeTo(1, 3)
        if self.remember < 25 then
            self.music:play("memories_"..sprite, 0)
            self.music:seek(Game.battle.music:tell())
            self.music:fade(0.85, 3)
        end
    end

    self.rect_x = (self.rect_pos and self.rect_pos[sprite]) and self.rect_pos[sprite][1] or self.rect_x
    self.rect_y = (self.rect_pos and self.rect_pos[sprite]) and self.rect_pos[sprite][2] or self.rect_y
end

function Memories:draw()
    local last_shader = love.graphics.getShader()
    love.graphics.setShader(self.shader)
    super:draw(self)
    love.graphics.setShader(last_shader)

    love.graphics.setColor(1, 1, 1, self.alpha)
    for i=1,3 do
        love.graphics.rectangle("fill", self.rect_x+self.rect_offsets[i][1], self.rect_y+self.rect_offsets[i][2], 10, 10)
    end
end

return Memories