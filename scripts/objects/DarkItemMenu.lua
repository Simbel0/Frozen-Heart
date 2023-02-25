local DarkItemMenu, super = Class(DarkItemMenu, false)

function DarkItemMenu:init()
    super.init(self)

    self.heart_sprite = Assets.getTexture("player/heart_monster")
end

return DarkItemMenu