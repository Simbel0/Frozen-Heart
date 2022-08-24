local Spamton_NEO, super = Class(Encounter)

function Spamton_NEO:init()
    super:init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* ..."

    -- Battle music ("battle" is rude buster)
    self.music = "SnowGrave NEO"
    -- Enables the purple grid battle background
    self.background = false

    self.sneo=self:addEnemy("Spamton_NEO", 550, 240)
    --self.sneo.sprite.frozen = true
    --self.sneo.sprite.freeze_progress = 0.15
end

return Spamton_NEO