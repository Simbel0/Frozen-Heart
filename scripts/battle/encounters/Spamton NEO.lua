local Spamton_NEO, super = Class(Encounter)

function Spamton_NEO:init()
    super:init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* ..."

    -- Battle music ("battle" is rude buster)
    self.music = nil
    -- Enables the purple grid battle background
    self.background = false

    self.sneo=self:addEnemy("Spamton_NEO", 525, 240)
    --self.sneo.sprite.frozen = true
    --self.sneo.sprite.freeze_progress = 0.15
end

function Spamton_NEO:onBattleStart()
    if spamtonMusic:isPlaying() then
        Game.battle.music=spamtonMusic
    else
        Game.battle.music:play("SnowGrave NEO")
    end
    Game.world:getEvent(2).adjust=3
end

return Spamton_NEO