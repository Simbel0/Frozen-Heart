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
    self.waves = {
        "secret/neo_emptymail",
        "secret/neo_pick-a-hole",
        "secret/neo_pipis"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        ""
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = {"Controlled by ice, this lost soul reminds you of someone...", "Without their strings,[wait:3] only ice prevents them to fall."}

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

    self.advance = false

    self:registerAct("X-Slash", "Physical\nDamage", nil, 15)
end

function Lost_Soul_S:onAct(battler, name)
    if name ~= "Check" then
        self.advance = true
    end
    if name == "X-Slash" then
        Game.battle:startActCutscene(function(cutscene)
            print("A")
            local wait, _ = cutscene:text("* Kris uses X-Slash!", {wait=false})
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
            cutscene:wait(1.5)
            cutscene:wait(wait)
            print("D")
            cutscene:text("* But you notice it doesn't even scratch the ice.")
            print("E")
        end)
        return
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
                        friend:heal(friend.chara:getStat("health")/4)
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
                hider:setColor(0, 0, 0, 1)
                hider:setLayer(BATTLE_LAYERS["top"])
                Game.battle:addChild(hider)
                Assets.playSound("noise")
                local kris = cutscene:getCharacter("kris")
                local fx = ColorMaskFX({0, 0, 0})
                kris:addFX(fx)
                local og_layer = kris.layer
                kris:setLayer(hider.layer+10)
                Game.battle.music:pause()
                cutscene:wait(1.5)
                cutscene:textSpecial("[voice:none][speed:0.7]* ...")
                cutscene:textSpecial("[voice:none][speed:0.7]* If we really share the same goal...")
                cutscene:wait(1)
                Game.battle.timer:tween(1, fx, {color={1, 1, 1}})
                cutscene:textSpecial("[voice:none][speed:0.7]* ...")
                cutscene:textSpecial("[voice:none][speed:0.7]* Can I trust you?")
                local c = -1
                while c~=1 do
                    c=cutscene:choicerSpecial({"Yes", "No"})
                end
                kris:setLayer(og_layer)
                cutscene:wait(1.5)
                cutscene:textSpecial("[voice:none][speed:0.7]* ..[speed:1][wait:4]Thanks.")


                Assets.playSound("break2")
                hider:setColor(1, 1, 1)
                kris:removeFX(fx)
                Game.battle.timer:tween(0.5, hider, {alpha=0})
                cutscene:wait(0.5)
                local queen = self.encounter.queen
                Game.battle.timer:after(7/30, function()
                    Assets.playSound("boost", 0.8, 1.2)
                    Assets.playSound("boost", 0.8, 0.9)

                    Game.battle.timer:tween(0.5, kris, {y=80}, "in-out-cubic")
                    kris:setSprite("fall")
                    kris.sprite:play(1/10)
                    kris.sprite.flip_x = true

                    battler:flash()
                    local bx, by = Game.battle:getSoulLocation()
                    local soul = Sprite("effects/soulshine", bx, by)
                    soul:play(1/15, false, function()
                        soul:remove()
                        for i,friend in ipairs(Game.battle.party) do
                            friend:heal(friend.chara:getStat("health"))
                        end
                    end)
                    soul:setOrigin(0.25, 0.25)
                    soul:setScale(2, 2)
                    Game.battle:addChild(soul)
                    Game.battle.timer:tween(0.5, soul, {y=45}, "in-out-cubic")

                    Game.battle.timer:every(0.2, function()
                        local k = AfterImage(kris.sprite, 1)
                        k:setScaleOrigin(0.5, 0.5)
                        k.graphics["grow"] = 0.005
                        k.color = {1, 0, 0}
                        Game.battle:addChild(k)
                    end)

                    Game.battle.party[2]:setSprite("shock_behind")
                    Game.battle.party[2]:shake(5)
                    Game.battle.party[3]:setSprite("shocked_behind")
                    Game.battle.party[3]:shake(5)

                    queen:setAnimation({"chair_shocked", 1/8, true})
                    queen:shake(5)
                    queen.air_mouv = false

                    Game.battle.music:resume()
                    Game.battle.music.pitch = 1.1

                    --[[local box = self.battle_ui.action_boxes[user_index]
                    box:setHeadIcon("spell")]]

                end)

                cutscene:text("* Kris unleaches the power of your SOUL!", {skip=false})
                Assets.playSound("noise")
                Game.battle.party[2].should_darken = true
                Game.battle.party[2].darken_timer = 15
                Game.battle.party[3].should_darken = true
                Game.battle.party[3].darken_timer = 15
                queen.darken_fx = queen:addFX(RecolorFX(0.5, 0.5, 0.5))
                queen.sprite:pause()
                Game.battle.background_fade_alpha=0.75
                
                local bx, by = Game.battle:getSoulLocation()
                local soul = SoulCutscene(bx, by)
                local soul_outer = Sprite("player/heart_outline_outer", bx, by)
                soul_outer:setColor(1, 0, 0)
                soul_outer.alpha = 0.5
                Game.battle:addChild(soul)
                Game.battle:addChild(soul_outer)
                cutscene:wait(1)
                Assets.playSound("transform1")
                Game.battle.timer:tween(1, soul_outer, {alpha=1, x=self.x+self.width/2, y=self.y+25})
                cutscene:wait(1.5)
                Game.battle.timer:tween(1, soul, {rotation=math.rad(-90)}, "in-out-back", function()
                    soul:setColor(1, 1, 0)
                    Game.world.timer:everyInstant(0.1, function()
                        local image=AfterImage(soul, 0.5)
                        image:setScaleOrigin(0.5)
                        image.graphics.grow=0.3
                        Game.battle:addChild(image)
                    end, 3)
                end)
                cutscene:wait(1.5)
                Game.battle.timer:tween(0.35, soul, {x=210, y=30})
                cutscene:wait(0.75)
                local x = (self.x+self.width/2)-20
                local strings = {}
                local obstacles = {}
                local spawn_timer = 29
                local allow_string_shoot = true
                local health_limit = 1
                local continue_cutscene = false
                local has_fps = Kristal.Config["showFPS"]
                cutscene:during(function()
                    if has_fps then
                        Kristal.Config["showFPS"] = continue_cutscene
                    end

                    if not continue_cutscene then
                        soul_outer.x = x+math.cos(Kristal.getTime()*10)*70
                        if soul_outer.color[2] > 0 then
                            soul_outer.color[2] = soul_outer.color[2] - 0.1*DTMULT
                            soul_outer.color[3] = soul_outer.color[3] - 0.1*DTMULT
                        end
                        if Input.pressed("cancel") and allow_string_shoot then
                            soul_outer:setColor(1, 1, 1)
                            local x, y = soul_outer:getPosition()
                            Game.battle:addChild(playerString(x, 0, self.body))
                        end

                        local string_state = false
                        for i,v in ipairs(Game.stage:getObjects(playerString)) do
                            if v.is_extending and v.extend then
                                string_state = true
                            end
                            if not v.is_extending and v.extend and not v.counted then
                                v.counted = true
                                table.insert(strings, v)
                                Assets.playSound("noise")
                                for i,v in ipairs(self.sprite.parts) do
                                    v.shake = 1
                                    v.friction = 0.1
                                end
                            end
                        end

                        allow_string_shoot = not string_state

                        spawn_timer = spawn_timer + DTMULT
                        if spawn_timer >= 30 then
                            spawn_timer = 0
                            if #obstacles < 5 then
                                local limit = 5 - #obstacles
                                for i = #obstacles, limit+#obstacles do
                                    local y = soul.y + Utils.random(-15, -2)
                                    obstacles[i+1] = Obstacle(SCREEN_WIDTH+20, y, Utils.random(self.x-120, (self.x+self.width)+10), y, Utils.pick({"bullets/snowflakeBullet", "bullets/neo/crew"}), love.math.random(1, health_limit))
                                    obstacles[i+1].table = obstacles
                                    Game.battle:addChild(obstacles[i+1])
                                end
                            end
                        end
                    end
                end)
                soul.start_shoot = true
                Game.battle:infoText("* Shoot with "..Input.getText("confirm").."![wait:2]\n* Send strings with "..Input.getText("cancel").."!")
                cutscene:wait(function()
                    return #strings==3
                end)
                health_limit = 3
                soul.start_shoot = false
                continue_cutscene = true
                spawn_timer = 29
                for i=#obstacles, 1, -1 do
                    obstacles[i]:destroy()
                end
                Game.battle.timer:tween(1, soul_outer, {alpha=0})
                Game.battle.timer:tween(1, soul, {alpha=0.5})
                queen.sprite:resume()
                cutscene:wait(1.5)

                self.sprite:setAllPartsShaking(1)
                for i,v in ipairs(strings) do
                    v:shake(1, 1, 0)
                end
                Game.battle.party[2]:setSprite("shock")
                Game.battle.party[2].sprite:setFacing("right")
                Game.battle.party[3]:setSprite("battle/hurt")
                Game.battle.party[3].sprite:setFacing("right")

                Game.battle.party[2].darken_timer = 0
                Game.battle.party[3].darken_timer = 0
                Game.battle.party[2].should_darken = false
                Game.battle.party[3].should_darken = false
                queen.darken_fx.amount = 0
                Game.battle.background_fade_alpha=0
                Assets.playSound("noise")
                cutscene:wait(2.5)
                Game.fader:fadeIn({speed=0.5, alpha=1})
                self.sprite:setAllPartsShaking(0)
                for i,v in ipairs(strings) do
                    v:shake(1, 1, 0.1)
                end
                self.wing_l:setSprite(self.actor.path.."/wingl_break")
                self.wing_r:setSprite(self.actor.path.."/wingr_break")
                Assets.playSound("grab")
                local ice_shards = {}
                local shards_pos = {
                    {483, 176},
                    {487, 216},
                    {511, 212},
                    {511, 194},
                    {583, 194},
                    {585, 218},
                    {553, 246},
                    {555, 178}
                }
                for i=1,8 do
                    local s = Sprite("enemies/spamton_neo/ice_shards/wing_"..(i<=4 and "l" or "r").."_"..i-(i<=4 and 0 or 4))
                    s:setScale(2)
                    s:setLayer(self.layer+(i<=4 and -10 or 10))
                    Game.battle:addChild(s)
                    s:setPosition(shards_pos[i][1], shards_pos[i][2])
                    s.physics.direction = math.rad(Utils.random(360))
                    s.physics.speed = 3
                    s.physics.gravity = 0.4
                    s:setRotationOrigin(0.5)
                    s.graphics.spin = math.rad(10)
                    ice_shards[i] = s
                end
                Game.battle.timer:tween(0.5, self, {y=240}, "in-out-cubic")
                for i,v in ipairs(strings) do
                    Game.battle.timer:tween(0.5, v, {y=v.y-30}, "in-out-cubic")
                end
                cutscene:wait(2)
                Game.battle.timer:tween(1, soul_outer, {alpha=1})
                Game.battle.timer:tween(1, soul, {alpha=1})
                queen.sprite:pause()
                Game.battle.party[2].darken_timer = 15
                Game.battle.party[3].darken_timer = 15
                Game.battle.party[2].should_darken = true
                Game.battle.party[3].should_darken = true
                Game.battle.timer:tween(1, queen.darken_fx, {amount=1})
                Game.battle.timer:tween(1, Game.battle, {background_fade_alpha=0.75})
                cutscene:wait(2)
                continue_cutscene = false
                soul.start_shoot = true
                cutscene:wait(function()
                    return #strings==6
                end)
                soul.start_shoot = false
                continue_cutscene = true
                for i=#obstacles, 1, -1 do
                    obstacles[i]:destroy()
                end
                Game.battle.timer:tween(1, soul_outer, {alpha=0})
                Game.battle.timer:tween(1, soul, {alpha=0})
                Game.battle.background_fade_alpha = 0
                Game.battle.party[2].should_darken = false
                Game.battle.party[3].should_darken = false
                queen.sprite:resume()
                queen.darken_fx.amount = 0
                cutscene:wait(1.5)
                Assets.playSound("ding")
                local flash = Sprite("enemies/spamton_neo/flash", 500, 300)
                flash:setScale(2)
                flash:setLayer(self.layer+10)
                Game.battle:addChild(flash)
                flash:setGraphics({
                    grow = 0.2,
                    fade_to = 0,
                    fade = 0.2,
                    fade_callback = function() flash:remove() end
                })
                self.head:setSprite(self.actor.path.."/head_break")
                cutscene:wait(1.5)
                cutscene:text("* ...", "nervous", "susie")
                cutscene:text("* Kris, I dunno how you're doing that...", "nervous", "susie")
                cutscene:text("* But damn that's cool.", "smile", "susie")
                cutscene:text("* But don't you think I'm gonna let you do the whole job yourself!!", "closed_grin", "susie")
                cutscene:text("[noskip]* The TENSION is at its fullest![func:tp_up]", nil, nil, {functions={
                    tp_up = function()
                        Game.tension = 200
                        Assets.playSound("boost")
                    end
                }})
                local rude_buster = Registry.getSpell("rude_buster")
                Game:removeTension(50)
                local wait, text = cutscene:text("* Susie cast RUDE BUSTER!", {wait=false})
                rude_buster:onCast(Game.battle.party[2], Game.battle.enemies[2])
                cutscene:wait(2)
                cutscene:wait(wait)

                local src = Assets.stopAndPlaySound(Game.battle.party[3].chara:getAttackSound() or "laz_c")
                src:setPitch(Game.battle.party[3].chara:getAttackPitch() or 1)

                Assets.stopAndPlaySound("criticalswing")

                for i = 1, 3 do
                    local sx, sy = Game.battle.party[3]:getRelativePos(Game.battle.party[3].width, 0)
                    local sparkle = Sprite("effects/criticalswing/sparkle", sx + Utils.random(50), sy + 30 + Utils.random(30))
                    sparkle:play(4/30, true)
                    sparkle:setScale(2)
                    sparkle.layer = BATTLE_LAYERS["above_battlers"]
                    sparkle.physics.speed_x = Utils.random(2, 6)
                    sparkle.physics.friction = -0.25
                    sparkle:fadeOutSpeedAndRemove()
                    self:addChild(sparkle)
                end

                Game.battle.party[3]:setAnimation("battle/attack", function()
                    local damage = 99

                    Game:giveTension(Utils.round(150/25))

                    local dmg_sprite = Sprite(Game.battle.party[3].chara:getAttackSprite() or "effects/attack/cut")
                    dmg_sprite:setOrigin(0.5, 0.5)
                    if crit then
                        dmg_sprite:setScale(2.5, 2.5)
                    else
                        dmg_sprite:setScale(2, 2)
                    end
                    dmg_sprite:setPosition(Game.battle.enemies[2]:getRelativePos(Game.battle.enemies[2].width/2, Game.battle.enemies[2].height/2))
                    dmg_sprite.layer = Game.battle.enemies[2].layer + 0.01
                    dmg_sprite:play(1/15, false, function(s) s:remove() end)
                    Game.battle.enemies[2].parent:addChild(dmg_sprite)

                    local sound = Game.battle.enemies[2]:getDamageSound() or "damage"
                    if sound and type(sound) == "string" then
                        Assets.stopAndPlaySound(sound)
                    end
                    Game.battle.enemies[2]:hurt(damage, Game.battle.party[3])
                    Game.battle.party[3].chara:onAttackHit(Game.battle.enemies[2], damage)
                end)

                cutscene:wait(2)

                Game.battle.party[2]:flash()
                local bx, by = Game.battle:getSoulLocation()
                local soul = Sprite("effects/soulshine", bx, by)
                soul:play(1/15, false, function()
                    soul:remove()
                    for i,friend in ipairs(Game.battle.party) do
                        friend:heal(friend.chara:getStat("health"))
                    end
                end)
                soul:setOrigin(0.25, 0.25)
                soul:setScale(2, 2)
                Game.battle:addChild(soul)

                local red_buster = Registry.getSpell("red_buster")
                Game:removeTension(60)
                local wait, text = cutscene:text("* Susie cast RED BUSTER!", {wait=false})
                cutscene:wait((1/15)+0.5)
                red_buster:onCast(Game.battle.party[2], Game.battle.enemies[2])
                cutscene:wait(0.25)
                Game.fader:fadeOut({speed=0.5, color={1, 1, 1}})
                self.wing_l:setSprite(self.actor.path.."/wingl_f")
                self.wing_r:setSprite(self.actor.path.."/wingr_f")
                self.arm_l:setSprite(self.actor.path.."/arml_f")
                self.arm_r:setSprite(self.actor.path.."/armr_f")
                self.leg_l:setSprite(self.actor.path.."/legl_f")
                self.leg_r:setSprite(self.actor.path.."/legr_f")
                self.head:setSprite(self.actor.path.."/head_f")
                self.body:setSprite(self.actor.path.."/body_f")
                cutscene:wait(1)
                cutscene:wait(cutscene:fadeIn(1, {global=true}))
                cutscene:wait(1)
                cutscene:text("* ...", nil, "spamtonneo")
                cutscene:text("* [[Audible Confusion]]", nil, "spamtonneo")
                Game.battle.party[2]:setSprite("walk")
                Game.battle.party[3]:setSprite("walk")
                cutscene:text("* That guy looks even weirder without the ice.", "neutral_side", "susie")
                cutscene:text("* What the hell is he?", "nervous", "susie")
                cutscene:text("* KRIS.\nKRIS.\nKRIS!", nil, "spamtonneo")
                cutscene:text("* I CAN [Hear] YOU AND [Smell] YOU!", nil, "spamtonneo")
                cutscene:text("* I AM NO MORE AN [[Ice Scream]]. I AM", nil, "spamtonneo")
                cutscene:text("* SPAMTON G. SPAMTON!![react:1]", nil, "spamtonneo", {reactions={
                    {"You know him, Kris?", "right", "bottom", "nervous", "susie"}
                }})
                cutscene:text("* Bro That's The Guy I Threw Into The Acid Once", "smile", "queen")
                cutscene:text("* But He's Taller Now", "smile_side_r", "queen")
                cutscene:text("* YOU! YOU [Hoochi Mama]!! WHAT ARE YOU DOING HERE??", nil, "spamtonneo")
                cutscene:text("* Well It's My Mansion", "true", "queen")
                cutscene:text("* ...RIGHT.", nil, "spamtonneo")
                cutscene:text("* You explain the situation to Spamton.")
                cutscene:text("* [Alone In The Dark]? [Corrupted By The Shiny Ring]? [Christmas Is Coming Sooner This Year]?", nil, "spamtonneo")
                cutscene:text("* KRIS THAT'S A STEAL! I WOULD NEVER PUT MY [Esteem Customer] INTO SUCH DANGER!!", nil, "spamtonneo")
                cutscene:text("* Actually I DID. I SOLD YOU MY [Commemorative Ring], HAVEN'T I?", nil, "spamtonneo")
                cutscene:text("* Wait, you're the one behind this thing?!", "angry_c", "susie")
                cutscene:text("* AND NOW YOU WANT A [Immediate Refund]??", nil, "spamtonneo")
                cutscene:text("* TELL YOU WHAT KID.", nil, "spamtonneo")
                cutscene:text("* THAT [Angel] IS A DANGER OF BOTH OF US. TO BOTH OF OUR [Hyperlink Blocked].", nil, "spamtonneo")
                cutscene:text("* SO I'LL HELP. IT'S A [One Time Only Deal]!!", nil, "spamtonneo")
                cutscene:text("* THE ONLY WAY. TO FREE YOUR FRIEND. IS SIMPLY BY. DESTROYING. THE RING.", nil, "spamtonneo")
                cutscene:text("* AIM ONLY AT IT AND THEN [Hope For The Best]", nil, "spamtonneo")
                cutscene:text("* Wait, why should we-", "angry", "susie")
                cutscene:text("* THE DEAL IS [Sign Right Here]!!", nil, "spamtonneo")
                cutscene:text("* LET'S GO KRIS!! LET'S [Finish The Job].", nil, "spamtonneo")

                cutscene:wait(999)
            end)
            return
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super:onAct(self, battler, name)
end

function Lost_Soul_S:getAttackDamage(damage, battler)
    self.advance = true
    return Utils.clamp(damage, 0, 1)
end

function Lost_Soul_S:hurt(amount, battler, on_defeat, color)
    self:statusMessage("damage", amount, color or (battler and {battler.chara:getDamageColor()}))

    print("hurt")

    self.advance = true

    self.hurt_timer = 1
    self:onHurt(amount, battler)

    --No need to check if Spamton is dead or not. He is.
    --self:checkHealth(on_defeat, amount, battler)
end

return Lost_Soul_S