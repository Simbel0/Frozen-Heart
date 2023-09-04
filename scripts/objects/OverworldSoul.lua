local OverworldSoul, super = Class(OverworldSoul)

function OverworldSoul:init(x, y)
    super.init(self, x, y)

    self.sprite:setSprite("player/heart_dodge_old")
end

return OverworldSoul