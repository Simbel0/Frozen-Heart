local Choicebox_o, super = Class(Choicebox, false)

function Choicebox_o:init(x, y, width, height, battle_box)
    super:init(self, x, y, width, height)

    if Game:getFlag("plot", 0)==3 then
        self.heart = Assets.getTexture("player/heart_menu_reverse")
    end
end

return Choicebox_o