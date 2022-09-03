local prefountain, super = Class(Map)

function prefountain:load()
  super:load(self)
  self.sounds={"hurt", "damage", "import", "chargeshot_fire", "laz_c", "power", "ui_select"}
  self.volume=1
end

function prefountain:update()
    if math.random()<0.2 then
        Assets.playSound(Utils.pick(self.sounds), self.volume)
    end
end

return prefountain