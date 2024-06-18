local ring_noelle, super = Class(EnemyBattler)

function ring_noelle:init()
    super:init(self)

    self.intend_x = 505
    self.intend_y = 200

    -- Enemy name
    self.name = "???"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("noelle")
    self.actor.path = "party/noelle/dark_c"
    self:setAnimation({"battle/idle", 0.2, true})

    -- Enemy health
    self.max_health = 3320
    self.health = 3320
    -- Enemy attack (determines bullet damage)
    self.attack = 8
    -- Enemy defense (usually 0)
    self.defense = -10

    self.money = 0
    self.experience = 1

    self.disable_mercy = true

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    self.tired_percentage = -999

    -- Dialogue randomly displayed in the enemy's speech bubble
    --self.dialogue = {
    --    "..."
    --}
    self.dialogue_offset={-70, 0}

    -- Check text (automatically has "ENEMY NAME - " at the start)
    --self.check = "AT 3 DF 1\n* Cotton heart and button eye\n* Looks just like a fluffy guy."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* You can't see anything.",
        "* Snow fills your vision."
    }

    self:registerAct("Call out", "Calls\nNoelle")

    self.first_shield = true

    self.fly_anim = true

    self.af_effect = Game.battle.timer:every(Kristal.Config["simplifyVFX"] and 0.5 or 0.2, function()
        Game.battle:addChild(AfterImage(self.sprite, 1))
    end)

    self.snow_effect = ParticleEmitter(self.sprite.width/2, self.sprite.height/2, 0, 0, {
        layer = self.layer-1,
        every = 0.1,
        amount = Kristal.Config["simplifyVFX"] and 2 or 4,
        texture = "lonelysnow",
        scale = 1,

        fade = 0.2,
        fade_after = 0.3,
        remove_after = 1,

        physics = {
            speed = 4
        },
        angle = {math.rad(0), math.rad(380)}
    })
    print(self.snow_effect)
end

-- Used just to see something. Keeping it here in the cold if I wanna use it again later (if I remember it)
--[[function getAllChildren(obj)
    local count = 0
    if not obj.children then return count end
    for i,child in ipairs(obj.children) do
        count = count + 1
        if child.children then
            count = count + getAllChildren(child)
        end
    end
    return count
end]]

function ring_noelle:update()
    if self.fly_anim then
        if not Game.battle.encounter.final_passed then
            self.x = self.intend_x + math.cos(Kristal.getTime()*2)*6
        end
        self.y = self.intend_y + math.sin(Kristal.getTime()*3)*20
    end
    super:update(self)
end

function ring_noelle:onAct(battler, name)
    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)

    if name == "Check" then
        if self.name == "???" then
            return "* You can't see anyone to check."
        else
            return {"* NOELLE HOLIDAY - 32 ATK 16 DEF\n* A broken mind within a moving corpse.", "* She can't even feel pain anymore."}
        end
    elseif name == "Call out" then
        if self.name == "???" then
            return {"* Kris calls out Noelle's name.","* [wait:1].[wait:1].[wait:1].[wait:5]But nobody came."}
        else
            table.remove(self.acts, 2)
            local act = {
                ["character"] = nil,
                ["name"] = "Courage",
                ["description"] = "Boost\nParty DEF",
                ["party"] = {"kris"},
                ["tp"] = 45,
                ["highlight"] = nil,
                ["short"] = false,
                ["icons"] = nil
            }
            table.insert(self.acts, 2, act)
            Game.battle:startActCutscene(function(cutscene)
                cutscene:text("* Kris calls Noelle's name.")
                cutscene:text("* Kris...?", "crazy-scared", "noelle")
                cutscene:text("* This isn't..[wait:5] Your voice.", "crazy-scared", "noelle")
                cutscene:text("* Why are you doing this..?", "crazy-neutral", "noelle")
                cutscene:text("* Why can't we continue what we started together??", "crazy-insane", "noelle")
                cutscene:text("* Kris's will is changing...[wait:5]\n* [color:yellow]CALL OUT[color:reset] became [color:yellow]COURAGE[color:reset].")
            end)
            return
        end
    elseif name == "Courage" then
        self.encounter.def_boost = true
        return {
            "* Kris motivates the party to not give up!",
            "* Everyone's DEFENSE increases as a result!"
        }
    elseif name == "Red Buster" then
        Game.battle:powerAct("red_buster", battler, "susie", self)
    elseif name == "Dual Heal" then
        Game.battle:powerAct("dual_heal", battler, "ralsei", "party")
    elseif name == "Shield" then
        Game.battle:startActCutscene("shield_act")
        return
    elseif name == "FriedPipis" then
        Game.battle:startActCutscene(function(cutscene)
            Assets.playSound("snd_spell_cure_slight_smaller")
            local up = false
            local wait = cutscene:text("* RECOVERED HP with pipis![func:up_ad]", {wait=false, functions={
                up_ad = function()
                    print("yes")
                    up = true
                end
            }})
            local text = Text("[ "..love.math.random(300, 1997).." ] Liked this!", 420, SCREEN_HEIGHT+20, {font_size=16})
            text.alpha = 0.5
            text.layer = BATTLE_LAYERS["above_ui"]
            Game.battle:addChild(text)
            cutscene:during(function()
                if not text then return false end
                print(up, text.y, text.alpha, wait())
                if up then
                    text.graphics.fade_to = 1
                    text.graphics.fade = 0.05
                    if text.y > 445 then
                        text.y = text.y - 3
                    end
                    if wait() then
                        text.alpha = 0
                        text:resetGraphics()
                        return false
                    end
                end
            end)
            local pipis = Sprite("bullets/neo/pipis_1", battler.width+30, battler.sprite.height/2)
            pipis:setScale(0)
            pipis:setOrigin(0.5)
            battler:addChild(pipis)
            local continue = false
            Game.battle.timer:tween(1, pipis, {scale_x=1, scale_y=1, rotation=math.rad(360*3)}, "out-quad", function()
                continue = true
            end)
            cutscene:wait(function()
                return continue
            end)
            continue = false
            Game.battle.timer:tween(0.35, pipis, {x=battler.width/2}, "out-cubic", function()
                Game.battle.timer:after(1/12, function()
                    Game.battle.timer:tween(0.35, pipis, {alpha=0, scale_x=4, scale_y=4}, nil, function()
                        continue = true
                        pipis:remove()
                    end)
                end)
            end)
            cutscene:wait(function()
                return continue
            end)
            battler:heal(120)
            cutscene:wait(wait)
            text:remove()
            cutscene:endCutscene()
        end)
        return
    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            return "* Susie tries to talk Noelle out of this.\n* Noelle do not listen."
        elseif battler.chara.id == "ralsei" then
            return "* Ralsei tries to calm Noelle down.\n* Noelle do not listen."
        end
    end

    return super:onAct(self, battler, name)
end

function ring_noelle:getAttackDamage(damage, battler, points)
    if self.encounter.last_section then
        return super:getAttackDamage(self, damage, battler, points)
    end
    return self.name == "???" and 0 or math.random(0,1)-- + (battler.chara.name=="Susie" and 3 or 0) --Her affection for Susie is no more
end

function ring_noelle:onDefeat()
    if not Game.battle.encounter.final_passed then
        self.health = 500
    end
end

return ring_noelle