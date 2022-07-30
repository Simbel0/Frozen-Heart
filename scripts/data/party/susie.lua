local character, super = Class("susie")

function character:init()
    super:init(self)

    self:addSpell("tension_absorb")

    self.stats["health"]=190
    self.stats["attack"]=18
    self.stats["magic"]=3

    self.health=190

    self.max_stats = {}
end

function character:onTurnStart(battler)
    if Game:getFlag("plot", 0)<2 then
        Game.battle:pushForcedAction(battler, "ACT", Game.battle:getActiveEnemies()[1], {name = "Talk"})
    end
    super:onTurnStart(self, battler)
end

function character:getGameOverMessage(main)
    return {
        "Come on,[wait:5]\nthat all you got!?",
        main.name..",[wait:5]\nget up...!"
    }
end

return character