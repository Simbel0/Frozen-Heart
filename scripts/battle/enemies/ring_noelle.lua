local ring_noelle, super = Class(EnemyBattler)

function ring_noelle:init()
    super:init(self)

    -- Enemy name
    self.name = "???"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("noelle")

    -- Enemy health
    self.max_health = 332*1997
    self.health = 332*1997
    print(self.health)
    -- Enemy attack (determines bullet damage)
    self.attack = 8
    -- Enemy defense (usually 0)
    self.defense = 2

    self.disable_mercy = true

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

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
    self:registerAct("Red Buster", "Red\nDamages", {"susie"}, 60)
    self:registerAct("Dual Heal", "Heals\neveryone", {"ralsei"}, 50)

    Game.battle.timer:every(0.1, function()
        Game.battle:addChild(AfterImage(self.sprite, 1))
    end)

    self.snow_effect = ParticleEmitter(self.sprite.width/2, self.sprite.height/2, 0, 0, {
        layer = self.layer-1,
        every = 0.1,
        amount = 4,
        texture = "lonelysnow",
        scale = 1,

        fade = 0.2,
        fade_after = 0.3,
        remove_after = 3,

        physics = {
            speed = 4
        },
        angle = {math.rad(0), math.rad(380)}
    })
    print(self.snow_effect)
end

function ring_noelle:update()
    self.x = 505 + math.cos(Kristal.getTime()*2)*6
    self.y = 200 + math.sin(Kristal.getTime()*3)*20
end

function ring_noelle:onAct(battler, name)
    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)

    if name == "Check" then
        if self.name == "???" then
            return "* You can't see anyone to check."
        else
            return {"* NOELLE HOLIDAY - 16 ATK 8 DEF\n* A damaged mind within a moving corpse.", "* She can't even feel pain anymore."}
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
                ["tp"] = 30,
                ["highlight"] = nil,
                ["short"] = false,
                ["icons"] = nil
            }
            table.insert(self.acts, 2, act)
            Game.battle:startActCutscene(function(cutscene)
                cutscene:text("* Kris calls Noelle's name.")
                cutscene:text("* Kris...?", "crazy-scared", "noelle")
                cutscene:text("* This isn't..[wait:5] Your voice.", "crazy-scared", "noelle")
                cutscene:text("* Why are you doing this..?", "crazy-neutral")
                cutscene:text("* Why can't we continue what we started together??", "crazy-insane", "noelle")
                cutscene:text("* Kris's will is changing...\n[color:yellow]CALL OUT[color:reset] became [color:yellow]COURAGE[color:reset].")
            end)
            return
        end
    elseif name == "Red Buster" then
        Game.battle:powerAct("red_buster", battler, "susie", self)
    elseif name == "Dual Heal" then
        Game.battle:powerAct("dual_heal", battler, "ralsei", self)
    end

    return super:onAct(self, battler, name)
end

function ring_noelle:getAttackDamage(damage, battler)
    return self.name == "???" and 0 or love.math.random(0,1)-- + (battler.chara.name=="Susie" and 3 or 0) --Her affection for Susie is no more
end

return ring_noelle