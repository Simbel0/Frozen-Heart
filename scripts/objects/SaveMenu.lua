local SaveMenu, super = Class(SaveMenu, false)

function SaveMenu:init()
    super.init(self)

    self.heart_sprite = Assets.getTexture("player/heart_monster")
end

function SaveMenu:update()
    print(self.state)
    if self.state == "SAVED" then
        if Input.pressed("cancel") or Input.pressed("confirm") then
            self:remove()
            Game.world:closeMenu()
            if not Game:getFlag("susie_reaction_save", false) then
                Game:setFlag("susie_reaction_save", true)
                Game.world:showText("[facec:susie/neutral_side][voice:susie]* (...[wait:5]Not sure what I just\ndid but ok.)")
                return
            end
        end
    end
    super:update(self)
end

return SaveMenu