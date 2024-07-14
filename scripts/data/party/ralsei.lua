local character, super = Class("ralsei")

function character:init()
    super:init(self)

    self.stats = {
        health = 140,
        attack = 12,
        defense = 2,
        magic = 11,
    }
    self.health=140
end

return character