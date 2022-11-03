local Dummy, super = Class(Encounter)

function Dummy:init()
    super:init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "ENCOUNTER_TEXT"

    -- Battle music ("battle" is rude buster)
    self.music = "touhou_song"
    -- Enables the purple grid battle background
    self.background = false

    -- Add the dummy enemy to the encounter
    self.oc = self:addEnemy("oc")

    --- Uncomment this line to add another!
    --self:addEnemy("dummy")
end

return Dummy