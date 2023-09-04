local DarkEquipMenu, super = Class(DarkEquipMenu, false)

function DarkEquipMenu:init()
    super.init(self)

    self.heart_sprite = Assets.getTexture("player/heart_monster")
end

return DarkEquipMenu