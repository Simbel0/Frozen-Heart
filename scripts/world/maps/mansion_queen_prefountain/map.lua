local prefountain, super = Class(Map)

function prefountain:load()
  super:load(self)
  Game:setBorder("mansion")
  
  self.sounds={"hurt", "damage", "import", "chargeshot_fire", "laz_c", "power", "ui_select"}
  self.volume=1
  self.sound_handler = Game.world.timer:every(1/30, function()
        if math.random()<0.2 then
            Assets.playSound(Utils.pick(self.sounds), self.volume)
        end
    end)
end

function prefountain:onExit()
    Game.world.timer:cancel(self.sound_handler)
    super:onExit(self)
end

return prefountain