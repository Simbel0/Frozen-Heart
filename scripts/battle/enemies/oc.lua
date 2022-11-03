local Dummy, super = Class(EnemyBattler)

function Dummy:init()
    super:init(self)

    -- Enemy name
    self.name = "Creator"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("dummy")

    -- Enemy health
    self.max_health = 2004
    self.health = 2004
    -- Enemy attack (determines bullet damage)
    self.attack = 6
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 0

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 5

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "oc/touhou1"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "Let's start with something... basic."
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT ??? DF ???\n* A self-insert of Frozen Heart's creator.\n* Why would he do that?"

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Debug files are read all around you.",
        "* The game isn't loading properly.",
        "ENCOUNTER_TEXT",
        "* Smells like glitches."
    }
    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* The dummy looks like it's\nabout to fall over."

    --self:setOrigin(0.5, 0.5)
    local x, y = self:getScreenPos()
    print(x, y)
    self.sphere = Sprite("sphere", 550, 220-30)
    self.sphere:setOrigin(0.5, 0.5)
    self.sphere.radius = 3
    self.rotate_sphere = true
    self.angle = 0
    Game.battle:addChild(self.sphere)

    -- Register act called "Smile"
    self:registerAct("Talk")
end

function Dummy:update()
    if self.rotate_sphere then
        self.sphere.x = self.sphere.x+math.cos(self.angle)*self.sphere.radius
        self.sphere.y = self.sphere.y+math.sin(self.angle)*self.sphere.radius
        self.angle = self.angle + 0.1*DTMULT
    end
end

function Dummy:onAct(battler, name)
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

return Dummy