local character, super = Class("kris")

function character:init()
    super:init(self)

    self.stats["health"]=160
    self.health=160
end

return character