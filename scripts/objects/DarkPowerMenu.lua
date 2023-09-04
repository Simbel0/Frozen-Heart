local DarkPowerMenu, super = Class(DarkPowerMenu, false)

function DarkPowerMenu:init()
    super.init(self)

    self.heart_sprite = Assets.getTexture("player/heart_monster")
end

return DarkPowerMenu