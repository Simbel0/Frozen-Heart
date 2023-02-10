local Lost_Soul_S, super = Class(EnemyBattler)

function Lost_Soul_S:init()
    super:init(self)

    -- Enemy name
    self.name = "Lost Soul"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("spamtonneo")
    self.actor.path = "enemies/spamton_neo/lost_soul"
    self.sprite:setStringCount(0)

    self.wing_l = self.sprite:getPart("wing_l")
    self.wing_r = self.sprite:getPart("wing_r")
    self.arm_l = self.sprite:getPart("arm_l")
    self.arm_r = self.sprite:getPart("arm_r")
    self.leg_l = self.sprite:getPart("leg_l")
    self.leg_r = self.sprite:getPart("leg_r")
    self.head = self.sprite:getPart("head")
    self.body = self.sprite:getPart("body")

    self.wing_l.swing_speed = 0
    self.wing_r.swing_speed = 0
    self.arm_l.swing_speed = 0.5
    self.arm_r.swing_speed = 0
    self.leg_l.swing_speed = 1
    self.leg_r.swing_speed = 1.5
    self.head.swing_speed = 0
    self.body.swing_speed = 0

    self.wing_l:setSprite(self.actor.path.."/wingl")
    self.wing_r:setSprite(self.actor.path.."/wingr")
    self.arm_l:setSprite(self.actor.path.."/arml")
    self.arm_r:setSprite(self.actor.path.."/armr")
    self.leg_l:setSprite(self.actor.path.."/legl")
    self.leg_r:setSprite(self.actor.path.."/legr")
    self.head:setSprite(self.actor.path.."/head")
    self.body:setSprite(self.actor.path.."/body")

    -- Enemy health
    self.max_health = 4809
    self.health = 0
    -- Enemy attack (determines bullet damage)
    self.attack = 8
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 0

    self.dialogue_advance = 0

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    self.tired_percentage = -1

    -- List of possible wave ids, randomly picked each turn
    --self.waves = {
    --}

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        ""
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = {"Controlled by ice, this lost soul reminds you of someone...", "Without their strings, only ice prevents them to fall."}

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* The lost soul has no audience.",
        "* The lost soul lost everything.",
        "* The air crackles with coldness.",
        "* It's cold.",
        "* It's freezing.",
        "* Noelle laughs from afar.",
        "* Noelle notices your despair.",
        "* It's the end.",
        "* The ice is as fresh as it is solid."
    }

    self.deal = 0
    self.charge = 0

    self:registerAct("X-Slash", "Physical\nDamage", nil, 15)
end

function Lost_Soul_S:onAct(battler, name)
    if name ~= "Check" then
        self.advance = true
    end
    if name == "X-Slash" then
        Game.battle:startActCutscene(function(cutscene)
            print("A")
            cutscene:text("* Kris uses X-Slash!", {wait=false})
            print("B")
            Game.battle.timer:everyInstant(0.5, function()
                print("B2")
                battler:setAnimation("battle/attack")
                Assets.playSound("scytheburst")
                self:hurt(1, battler)
                local afIm = AfterImage(battler.sprite, 1)
                afIm.physics = {
                    speed_x = 3,
                    direction = 2*math.pi
                }
                battler:addChild(afIm)
            end, 2)
            print("C")
            cutscene:wait(2.5)
            print("D")
            cutscene:text("* But you notice it doesn't even scratch the ice.")
            print("E")
        end)
        return true
    elseif name == "Standard" then
        if battler.chara.id == "ralsei" then
            self:addMercy(0)
            return {"* Ralsei tried to talk to the Lost Soul!", "* It doesn't seem to work."}
        elseif battler.chara.id == "susie" then
            self:addMercy(0)
            return {"* Susie tried to break the ice on the Lost Soul!", "* It doesn't seem to work."}
        else
            -- Text for any other character (like Noelle)
            return "* "..battler.chara:getName().." don't know what to do!"
        end
    elseif name == "Charge" then
        self.charge = self.charge + 1
        self.waves = {
            "secret/sneo_end"
        }
        if self.charge<5 then
            Game.battle.timer:after(7/30, function()
                Assets.playSound("boost")
                battler:flash()
                local bx, by = Game.battle:getSoulLocation()
                local soul = Sprite("effects/soulshine", bx, by)
                soul:play(1/15, false, function()
                    soul:remove()
                    for i,friend in ipairs(Game.battle.party) do
                        friend:heal(friend.chara:getStat("max_health")/4)
                    end
                end)
                soul:setOrigin(0.25, 0.25)
                soul:setScale(2, 2)
                Game.battle:addChild(soul)

                --[[local box = self.battle_ui.action_boxes[user_index]
                box:setHeadIcon("spell")]]

            end)
            return "* Kris charges the power of your SOUL!"
        else
            Game.battle:startActCutscene(function(cutscene)
                local hider = Rectangle(-20, 0, SCREEN_WIDTH+40, SCREEN_HEIGHT)
                hider:setColor(0, 0, 0, 0)
                hider:setLayer(BATTLE_LAYERS["top"])
                Game.battle:addChild(hider)
                local kris = cutscene:getCharacter("kris")
                local og_layer = kris.layer
                kris:setLayer(hider.layer+10)
                Game.battle.music:pause()
                Game.battle.timer:tween(1, hider, {alpha=1})
                cutscene:text("* ...")
                cutscene:text("* A lot has happened lately.")
                cutscene:text("* Too much for me to understand.")
                cutscene:text("* ...")
                cutscene:text("* YOU...")
                cutscene:text("* If we really share the same goal...")
                cutscene:text("* Do you trust me?")
                cutscene:choicer({"Yes", "No"})
                kris:setLayer(og_layer)
                cutscene:wait(1.5)
                cutscene:text("* ..[wait:4]Thank you.")
                Assets.playSound("break2")
                hider:setColor(1, 1, 1)
                Game.battle.timer:tween(0.5, hider, {alpha=0})
                cutscene:wait(0.5)
                Game.battle.timer:after(7/30, function()
                    Assets.playSound("boost")
                    battler:flash()
                    local bx, by = Game.battle:getSoulLocation()
                    local soul = Sprite("effects/soulshine", bx, by)
                    soul:play(1/15, false, function()
                        soul:remove()
                        for i,friend in ipairs(Game.battle.party) do
                            friend:heal(friend.chara:getStat("max_health"))
                        end
                    end)
                    soul:setOrigin(0.25, 0.25)
                    soul:setScale(2, 2)
                    Game.battle:addChild(soul)

                    --[[local box = self.battle_ui.action_boxes[user_index]
                    box:setHeadIcon("spell")]]

                end)
                Game.battle.party[2]:setSprite("shock_behind")
                Game.battle.party[2]:shake(5)
                Game.battle.party[3]:setSprite("shock_behind")
                Game.battle.party[3]:shake(5)
                Game.battle.timer:every(0.1, function()
                    local k = AfterImage(kris.sprite, 1)
                    k:setScaleOrigin(0.5, 1)
                    k.graphics = {
                        grow = 0.1
                    }
                    k.color = {1, 0, 0}
                    Game.battle:addChild(k)
                end)
                cutscene:text("* Kris charges the power of your SOUL!")
                Assets.playSound("noise")
                Game.battle.background_fade_alpha=0.75
                
                local bx, by = Game.battle:getSoulLocation()
                local soul = Sprite("player/heart_dodge", bx, by)
                local soul_outer = Sprite("player/heart_outline_outer", bx, by)
                soul_outer.alpha = 0
                cutscene:wait(0.2)
                Assets.playSound("transform1")
                Game.battle.timer:tween(1, soul_outer, {alpha=1, x=self.x+self.width/2, y=self.y+50})
                cutscene:wait(0.2)
                Game.battle.music:resume()
                Game.battle.music.pitch = 1.1
                local x = self.x+self.width/2
                local strings = 0
                cutscene:during(function()
                    soul_outer.x = x+math.cos(Kristal.getTime())*20
                end)
                cutscene:wait(function()
                    return strings==3
                end)
            end)
            return true
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super:onAct(self, battler, name)
end

function Lost_Soul_S:getAttackDamage(damage, battler)
    return Utils.clamp(damage, 0, 1)
end

function Lost_Soul_S:hurt(amount, battler, on_defeat, color)
    self:statusMessage("damage", amount, color or (battler and {battler.chara:getDamageColor()}))

    self.advance = true

    self.hurt_timer = 1
    self:onHurt(amount, battler)

    --No need to check if Spamton is dead or not. He is.
    --self:checkHealth(on_defeat, amount, battler)
end

return Lost_Soul_S