local DarkConfigMenu, super = Class(DarkConfigMenu, false)

function DarkConfigMenu:init()
    super.init(self)

    self.heart_sprite = Assets.getTexture("player/heart_monster")
end

return DarkConfigMenu