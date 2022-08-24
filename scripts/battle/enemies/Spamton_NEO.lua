local Spamton_NEO, super = Class(EnemyBattler)

function Spamton_NEO:init()
    super:init(self)

    -- Enemy name
    self.name = "Spamton NEO"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("spamton_neo")
    self:setAnimation("stop")

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
        "* Spamton feels the cold breeze as he takes a ride around town.[w:10]\nHe hates it.",
        "* Spamton believes in you.[w:10]\r\nProbably not.",
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* The dummy looks like it's\nabout to fall over."

    -- Register act called "Smile"
    self:registerAct("Smile")
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)
    self:registerAct("Tell Story", "", {"ralsei"})
end

function Spamton_NEO:onAct(battler, name)
    if name == "Smile" then
        -- Give the enemy 100% mercy
        self:addMercy(100)
        -- Change this enemy's dialogue for 1 turn
        self.dialogue_override = "... ^^"
        -- Act text (since it's a list, multiple textboxes)
        return {
            "* You smile.[wait:5]\n* The dummy smiles back.",
            "* It seems the dummy just wanted\nto see you happy."
        }

    elseif name == "Tell Story" then
        -- Loop through all enemies
        for _, enemy in ipairs(Game.battle.enemies) do
            -- Make the enemy tired
            enemy:setTired(true)
        end
        return "* You and Ralsei told the dummy\na bedtime story.\n* The enemies became [color:blue]TIRED[color:reset]..."

    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        self:addMercy(50)
        if battler.chara.id == "ralsei" then
            -- R-Action text
            return "* Ralsei bowed politely.\n* The dummy spiritually bowed\nin return."
        elseif battler.chara.id == "susie" then
            -- S-Action: start a cutscene (see scripts/battle/cutscenes/dummy.lua)
            Game.battle:startActCutscene("dummy", "susie_punch")
            return
        else
            -- Text for any other character (like Noelle)
            return "* "..battler.chara:getName().." straightened the\ndummy's hat."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super:onAct(self, battler, name)
end

return Spamton_NEO