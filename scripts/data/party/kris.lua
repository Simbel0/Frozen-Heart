local character, super = Class("kris")

function character:init()
    super:init(self)

    self.stats["health"]=166
    self.health=166
end

return character