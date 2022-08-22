local Dummy, super = Class(Encounter)

function Dummy:init()
    super:init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* It's freezing."

    -- Battle music ("battle" is rude buster)
    self.music = "SnowGrave NEO"
    -- Enables the purple grid battle background
    self.background = false

    -- Add the dummy enemy to the encounter
    self:addEnemy("dummy")

    --- Uncomment this line to add another!
    --self:addEnemy("dummy")
end

return Dummy