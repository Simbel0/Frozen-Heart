local Spamton_NEO, super = Class(EnemyBattler)

function Spamton_NEO:init()
    super:init(self)

    -- Enemy name
    self.name = "Spamton NEO"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("spamtonneo")

    -- Enemy health
    self.max_health = 4809*50
    self.health = 256*50
    -- Enemy attack (determines bullet damage)
    self.attack = 4
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 0

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    self.tired_percentage = 0

    self.disable_mercy = true

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "ENL4RGE\nYOURSELF",
        "help",
        "GO [die]",
        "BUY YOUR [Ice Scream] SOMEWHERE ELSE!!"
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "TASTE THE [color:red]PAIN[color:reset] OF NEO!!!"

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Spamton noticed there is no audience.",
        "* Spamton laughs in a broken way.",
        "* It's cold.",
        "* Spamton's armor is freezing.",
        "* Spamton is freezing.",
        "* Proceed.",
        "* The air crackles with freedom.",
        "* The stage lights are frozen.",
        "* It pulls the strings and makes them ring.",
        "* Raise your hands and make them shut up.",
        "* Spamton feels the cold breeze as he takes a ride around town.[wait:10]\nHe hates it.",
        "* Spamton believes in you.[wait:10]\n* Probably not.",
    }

    self:registerAct("X-Slash", "Physical\nDamage", nil, 15)
    self:registerAct("Red Buster", "Red\nDamages", {"susie"}, 60)
    self:registerAct("Dual Heal", "", {"noelle"}, 50)
end

function Spamton_NEO:onAct(battler, name)
    if name == "X-Slash" then
        Game.battle.timer:everyInstant(0.5, function()
            battler:setAnimation("battle/attack")
            Assets.playSound("scytheburst")
            self:hurt(10, battler)
            local afIm = AfterImage(battler.sprite, 0.4)
            afIm.physics = {
                speed_x = 2,
                direction = 2*math.pi
            }
            battler:addChild(afIm)
        end, 1)
        return "* Kris uses X-Slash!"
    elseif name == "Red Buster" then
        Game.battle:powerAct("red_buster", battler, "susie", self)
    elseif name == "Dual Heal" then
        Game.battle:powerAct("dual_heal", battler, "noelle", self)
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super:onAct(self, battler, name)
end

function Spamton_NEO:getAttackDamage(damage, battler)
    if damage<=0 then
        return 10
    end
end

return Spamton_NEO