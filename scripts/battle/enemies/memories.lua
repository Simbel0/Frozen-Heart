local Memories, super = Class(EnemyBattler)

function Memories:init()
    super:init(self)

    -- Enemy name
    self.name = ""
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("dummy")
    self.actor.path = "enemies/memories"
    self:setSprite("dummy")
    self.alpha = 0

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

    self.remember = 0
    self:registerAct("Remember")
end

function Memories:onAct(battler, name)
    if name == "Remember" then
        self.remember = self.remember + 1

        --Spamton
        if self.remember == 1 then
            return {
                "* Noelle tries to remember something.",
                "* ...",
                "* Suddenly, she remembers a scam willing to help her."
            }
        elseif self.remember == 2 then
            return {
                "* Noelle asks the man about something she's searching for.",
                "* An ad for a spyware pops up."
            }
        elseif self.remember == 3 then
            return {
                "* Noelle asks the man about his pet.",
                "* Upon seeing it, Noelle is amused and thanks the man."
            }
        elseif self.remember == 4 then
            return {
                "* The memories are complete.",
                "* She may not cherish them, but she is grateful to Spamton for his \"help\"."
            }
        end
        --Kris

        --Berdly

        --Queen

        --Rudy

        --Susie

        --Dess


    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super:onAct(self, battler, name)
end

return Memories