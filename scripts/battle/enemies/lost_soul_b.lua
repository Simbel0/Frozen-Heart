local Lost_Soul_B, super = Class(EnemyBattler)

function Lost_Soul_B:init()
    super:init(self)

    -- Enemy name
    self.name = "Lost Soul"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("berdly")

    -- Enemy health (doubled because the whole party is stronger than just Kris and Noelle alone)
    self.max_health = 900*2
    -- Berdly's health is at 0 since he's already dead
    self.health = 0
    -- But we'll use a fake health variable to keep track if the player decides to free Berdly by attacking them
    self.fake_health = self.max_health

    -- Enemy attack (determines bullet damage)
    self.attack = 7
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 0

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0
    self.exit_on_defeat = false

    self.tired_percentage = -1

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "secret/berd_fallingTornado",
        "secret/berd_ly"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        ""
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "Controlled by ice, this lost soul reminds you of someone..."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* The Lost Soul is silent.\n* It feels unusual.",
        "* The Lost Soul tried to summon allies.[wait:3]\n* But nobody came.",
        "* Smells like frozen chicken.",
        "* Noelle looks at Kris from afar.",
        ""
    }

    
    self:registerAct("Glare", "")
    self:registerAct("Play Smart", "", {"ralsei"})
    self:registerAct("Play Dumb", "", {"susie"})
end

function Lost_Soul_B:onAct(battler, name)
    if name == "Glare" then
        -- Give the enemy 100% mercy
        self:addMercy(7)
        -- Act text (since it's a list, multiple textboxes)
        return {
            "* You glared at the lost soul!",
            "* The Lost Soul tries to keep its cool."
        }

    elseif name == "Play Smart" then
        self:addMercy(8)
        return {
            "* You and Ralsei said something that sounds smart!",
            "* The Lost Soul is lost in a deep reflection!"
        }
    elseif name == "Play Dumb" then
        self:addMercy(6)
        return {
            "* You and Susie somehow managed to say the same dumb thing!",
            "* The Lost Soul would laugh at you if it could."
        }
    elseif name == "Standard" then --X-Action
        if battler.chara.id == "ralsei" then
            self:addMercy(4)
            return "* Ralsei tried to talk to the Lost Soul!"
        elseif battler.chara.id == "susie" then
            self:addMercy(7)
            return "* Susie tried to break the ice on the Lost Soul!"
        else
            -- Text for any other character (like Noelle)
            return "* "..battler.chara:getName().." don't know what to do!"
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super:onAct(self, battler, name)
end

function Lost_Soul_B:hurt(amount, battler, on_defeat, color)
    self.fake_health = self.fake_health - amount
    if battler.chara then
        self:statusMessage("damage", amount, color or (battler and {battler.chara:getDamageColor()}))
    end

    self.hurt_timer = 1
    self:onHurt(amount, battler)

    --No need to check if Berdly is dead or not. He is.
    --self:checkHealth(on_defeat, amount, battler)
end

function Lost_Soul_B:getSpareText(battler, success)
    local text = super:getSpareText(self, battler, success)

    if success then
        text = {text.."[wait:10]\n* But Berdly can't leave the battle..."}
    end

    return text
end

return Lost_Soul_B