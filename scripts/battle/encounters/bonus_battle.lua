local Bonus_Battle, super = Class(Encounter)

function Bonus_Battle:init()
    super:init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* ..."

    self.mode = Game:getFlag("noelle_battle_status")
    Game:setFlag("first_pipis", true)

    -- Battle music ("battle" is rude buster)
    self.music = nil
    -- Enables the purple grid battle background
    self.background = false

    self.default_xactions = false

    self.no_end_message = false

    --Game.battle.use_textbox_timer = false
    self.phase = 1  -- 1:Normal Battle
                    -- 2:Aftermatch

    self.item_used = false

    self.sneo=self:addEnemy("Spamton_NEO", 525, 240)

    Game.battle:registerXAction("susie", "Snap", nil)
    Game.battle:registerXAction("noelle", "Snap", nil)
end

function Bonus_Battle:update()
    if self.funnycheat and self.funnycheat>=5 and not self.cheater then
        self.cheater = true
        self.sneo.wave_loop = 2
        local head = self.sneo.sprite:getPart("head")
        self.sneo.smoke_emitter = ParticleEmitter(head.sprite.width/2, head.sprite.height/2, 0, 0, {
            layer = -101,
            every = 0.1,
            amount = 4,
            texture = "cakesmoke",
            scale = 4,

            fade = 0.4,
            fade_after = 0.3,
            remove_after = 1,

            physics = {
                speed = 10
            },
            angle = {math.rad(285), math.rad(350)}
        })
        head:addChild(self.sneo.smoke_emitter)
        Game.battle.timer:tween(0.2, head.sprite, {color={1, 0, 0}})
        Assets.playSound("snd_carhonk")
        Game.battle.timer:everyInstant(0.6, function()
            Game.battle.timer:tween(0.25, head.sprite, {scale_x=2, scale_y=2}, "linear", function()
                Game.battle.timer:tween(0.25, head.sprite, {scale_x=1, scale_y=1})
            end)
        end, 2)
    end

    self.sneo.attack = Utils.clamp(13 + 0.25*self.funnycheat, 13, 26)
end

function Bonus_Battle:onBattleStart()
    if spamtonMusic and spamtonMusic:isPlaying() then
        Game.battle.music=spamtonMusic
    else
        Game.battle.music:play("SnowGrave NEO", 0.5, 1)
    end
    Game.world:getEvent(2).adjust=3

    Game.battle.party[2].chara.stats["health"]=190
    Game.battle.party[2].chara.health=190
    Game.battle.party[2].chara.stats["attack"]=18
    Game.battle.party[2].chara.stats["defense"]=2
    Game.battle.party[2].chara.stats["magic"]=3
    self.old_health_amount = {}
    local presence = Kristal.getPresence()
    presence.details = "Fighting against Spamton NEO"

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
end

function Bonus_Battle:onStateChange(old, new)
    if new=="BATTLETEXT" then
        if self.phase==2 and Game.battle.substate == "ITEM" then
            self.item_used = true
        end
    end
end

function Bonus_Battle:onTurnEnd()
    if self.phase==2 then
        for _,battler in ipairs(Game.battle.party) do
            battler.hit_count = 0
            if (battler.chara.health <= 0) then
                battler:heal(math.ceil(battler.chara:getStat("health") / 8), nil, true)
            end
            battler.action = nil
        end
        local susie = Game.battle.party[2]
        local noelle = Game.battle.party[3]
        if (not susie.is_down) or (not noelle.is_down) then
            if self.item_used then
                return false
            end
            if noelle.is_down then
                local heal = 0
                while noelle.chara.health+heal<=0 do
                    heal = heal + 1
                end
                noelle:heal(heal)
            end
            if susie.is_down then
                local heal = 0
                while noelle.chara.health+heal<=0 do
                    heal = heal + 1
                end
                susie:heal(heal)
            end
            Game.battle:startCutscene(function(cutscene)

                local function castRudeBuster(user, target)
                    local buster_finished = false
                    local anim_finished = false
                    local function finishAnim()
                        anim_finished = true
                    end
                    if not user:setAnimation("battle/rude_buster", finishAnim) then
                        anim_finished = false
                        user:setAnimation("battle/attack", finishAnim)
                    end
                    Game.battle.timer:after(15/30, function()
                        Assets.playSound("rudebuster_swing")
                        local x, y = user:getRelativePos(user.width, user.height/2 - 10, Game.battle)
                        local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
                        local blast = RudeBusterBeam(false, x, y, tx, ty, function(pressed)
                            local damage = math.ceil((user.chara:getStat("magic") * 5) + (user.chara:getStat("attack") * 11) - (target.defense * 3))
                            if pressed then
                                damage = damage + 30
                                Assets.playSound("scytheburst")
                            end
                            target:flash()
                            target:hurt(target.health-1, user)
                            buster_finished = true
                        end)
                        blast.layer = BATTLE_LAYERS["above_ui"]
                        Game.battle:addChild(blast)
                    end)
                end

                local function castIceShock(user, target, offsets)

                    local function createParticle(x, y)
                        local sprite = Sprite("effects/icespell/snowflake", x, y)
                        sprite:setOrigin(0.5, 0.5)
                        sprite:setScale(1.5)
                        sprite.layer = BATTLE_LAYERS["above_battlers"]
                        Game.battle:addChild(sprite)
                        return sprite
                    end

                    local x, y = target:getRelativePos(target.width/2, target.height/2, Game.battle)

                    x, y = x+offsets[1], y+offsets[2]

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
                    end)
                end

                Game.battle.music:stop()
                cutscene:wait(1)
                cutscene:text("* Oh you're dead to me now!!", "angry_b", "susie")
                castRudeBuster(Game.battle.party[2], Game.battle.enemies[1])
                cutscene:wait(0.7)
                castIceShock(Game.battle.party[2], Game.battle.enemies[1], {0, 0})
                cutscene:wait(0.1)
                castIceShock(Game.battle.party[2], Game.battle.enemies[1], {-20, -20})
                cutscene:wait(0.1)
                castIceShock(Game.battle.party[2], Game.battle.enemies[1], {30, 30})
                cutscene:wait(0.3)
                Game.fader:fadeOut(nil, {speed = 0})
                self.sneo.sprite:snapStrings(6, true)
                Assets.playSound("petrify")
                cutscene:wait(2.5)
                Game:setFlag("spamton_conclusion", "killed")
                Game.battle:setState("VICTORY")
                Game.battle:returnToWorld()
                --[[self.sneo.sprite:setHeadAnimating(false)
                self.sneo.sprite:getPart("head"):setSprite("npcs/spamton/head_death")
                cutscene:battlerText(self.sneo, "...")
                cutscene:text("* Ah! Look at you! You can't even move a limb!")
                cutscene:text("* Come on, Kris. Let's go seal the fountain!")
                cutscene:battlerText(self.sneo, "KRIS... WAIT...")
                cutscene:text("* What do you want, weirdo?")
                cutscene:wait(1)
                Game.battle.music:play("spamton_neo_after", 1, 1)
                cutscene:battlerText(self.sneo, "IT...[wait:1] IT SEems that\neven after all this...")
                cutscene:battlerText(self.sneo, "Even after reaching the top,\nI always seems to be doomed\nto fall back down.")
                cutscene:battlerText(self.sneo, "I can't be anything more\nthan a simple puppet...")
                cutscene:battlerText(self.sneo, "But you three, it may\nnot look like it..")
                cutscene:battlerText(self.sneo, "But you could actually be\nable to free yourself\nof your strings.")
                cutscene:battlerText(self.sneo, "Kris...")
                cutscene:fadeOut(0)
                cutscene:wait(1)
                cutscene:battlerText(self.sneo, "Good luck. You'll\nneed it.")]]
            end)
        return true
        end
    end
    return false
end

function Bonus_Battle:getDialogueCutscene()
    if self.sneo.health<=2400 and self.phase==1 then
        self.phase=2
        self.sneo.dialogue_advance = 999
        self.sneo.text={
            "* Spamton NEO smiles victoriously.",
            "* Spamton waits for you to take the deal.",
            "* Susie tries to tell you something, but Spamton threaten to fire a pipis at her."
        }
        self.sneo.acts={}
        self.sneo.waves={
            "bonus/deal"
        }
        self.sneo.dialogue={
            "T4KE THE DEAL KRIS!!",
            "WHAT ARE YOU WAITING FOR??",
            "[Please Press][De4l][To Continue]"
        }
        self.sneo:registerAct("Deal", "Negociate\nthe deal")
        self.sneo:registerAct("HealDeal", "Negociate\nand heal", nil, 10)
        Game.battle.music:fade(0, 1.5)
        return function(c)
            c:wait(2.5)
            c:battlerText(self.sneo, "SO THAT'S HOW\nIT IS")
            c:battlerText(self.sneo, "EVEN AFTER MY [Final\nMessage], YOU STILL\nWON'T [Take The Deal]")
            c:battlerText(self.sneo, "KRIS, I ALWAYS\nTHOUGHT OF YOU AS\nA [Value Customer]")
            c:battlerText(self.sneo, "SO IT REALLY [Burns!!]\nTHAT WE HAVE TO COME\nTO THIS.")
            c:battlerText(self.sneo, "KRIS. LET ME TELL\nYOU A SECRET")
            c:wait(0.75)

            local arm = self.sneo.sprite:getPart("arm_l")
            self.sneo.sprite:setPartSprite("arm_l", "npcs/spamton/arm_cannon")
            self.sneo.sprite:setPartSwingSpeed("arm_l", 0)
            self.sneo.sprite:setHeadFrame(2)

            local susie = c:getCharacter("susie")
            local noelle = c:getCharacter("noelle")
            self.sneo.sprite:tweenPartRotation("arm_l", Utils.angle(self.sneo.x, self.sneo.y, susie.x, susie.y), 0.3, "out-cubic")
            c:wait(0.5)
            self.sneo.sprite:setPartSprite("arm_l", "npcs/spamton/arm_cannon_egg")
            c:wait(0.5)
            self.sneo.sprite:tweenPartRotation("arm_l", Utils.angle(self.sneo.x, self.sneo.y, susie.x, susie.y)+math.rad(10), 0.3, "out-cubic")
            self.sneo.sprite:setPartSprite("arm_l", "npcs/spamton/arm_cannon")
            local pos_x, pos_y = arm:getScreenPos()
            local pipis = Sprite("bullets/neo/pipis_1", pos_x-10, pos_y+10)
            pipis:setScale(2)
            pipis:setRotationOrigin(0.5, 0.5)
            pipis.graphics.spin = 4
            Game.battle.timer:tween(0.25, pipis, {x=Game.battle.party[2].x, y=Game.battle.party[2].y-Game.battle.party[2].height/2}, "linear", function()
                pipis:explode()
                Game.battle.party[2]:hurt(999)
                Game.battle.party[2].chara.health = -242
            end)
            Game.battle:addChild(pipis)

            c:wait(1.5)

            self.sneo.sprite:tweenPartRotation("arm_l", Utils.angle(self.sneo.x, self.sneo.y, noelle.x, noelle.y), 0.3, "out-cubic")
            c:wait(0.5)
            self.sneo.sprite:setPartSprite("arm_l", "npcs/spamton/arm_cannon_egg")
            c:wait(0.5)
            self.sneo.sprite:tweenPartRotation("arm_l", Utils.angle(self.sneo.x, self.sneo.y, noelle.x, noelle.y)+math.rad(10), 0.3, "out-cubic")
            self.sneo.sprite:setPartSprite("arm_l", "npcs/spamton/arm_cannon")
            local pipis = Sprite("bullets/neo/pipis_1", pos_x-10, pos_y+10)
            pipis:setScale(2)
            pipis:setRotationOrigin(0.5, 0.5)
            pipis.graphics.spin = 4
            Game.battle.timer:tween(0.25, pipis, {x=Game.battle.party[3].x, y=Game.battle.party[3].y-Game.battle.party[3].height/2}, "linear", function()
                pipis:explode()
                Game.battle.party[3]:hurt(999)
                Game.battle.party[3].chara.health = -229
            end)
            Game.battle:addChild(pipis)

            c:wait(1)
            self.sneo.sprite:setHeadAnimating(true)
            self.sneo.sprite:resetPart("arm_l", true)
            Game.battle.music:play("Deal Gone Wrong", 1, 1)
            c:battlerText(self.sneo, "YOU SHOULD HAVE\nGONE FOR THE [Pipis]!!")
            c:battlerText(self.sneo, "AND NOW KRIS")
            c:battlerText(self.sneo, "NO MORE [Deal] NOR [Harem]\nTO COME TO SAVE YOU")
            c:battlerText(self.sneo, "GIVE ME YOUR\n[HeartShapedObject]")
            c:battlerText(self.sneo, "IT'LL BENEFIT [You&me]\nIN THE END")
            --c:text("* (You think it would be wise not to use your [color:yellow]ITEM[color:reset]s. Spamton would notice it immedialtely.)")
        end
    end
end

function Bonus_Battle:createSoul(x, y)
    return YellowSoul(x, y)
end

return Bonus_Battle