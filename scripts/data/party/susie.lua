local character, super = Class("susie")

function character:init()
    super:init(self)

    self:addSpell("tension_absorb")

    self.stats["health"]=190
    self.stats["attack"]=18
    self.stats["magic"]=3

    self.soul_color = {1, 0, 0}

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

function character:onAttackHit(enemy, damage)
    if damage > 0 then
        Assets.playSound("impact", 0.8)
        if Game.battle then
            Game.battle:shakeCamera(4)
        end
    end
end

function character:getTitle()
    if Game:getFlag("plot", 0)==3 then
        if Game:getFlag("noelle_battle_status", "no_trance")=="no_trance" then
            return "LV"..self:getLevel().. " Friendly Knight\nWill face death\nto save a friend."
        elseif Game:getFlag("noelle_battle_status", "no_trance")=="thorn_kill" then
            return "LV"..self:getLevel().. " Oblivious Knight\nForgot to notice\ncritical details."
        elseif Game:getFlag("noelle_battle_status", "no_trance")=="killspare" then
            return "LV"..self:getLevel().. " Violent Knight\nDidn't learn a\nthing."
        end
    end
    return "LV"..self.level.." Healing Master\nCan use ultimate\nhealing. (Losers!)"
end

function character:getSoulColor()
    if Game:getFlag("plot", 0)<=3 then
        return 1, 1, 1, 1
    end
    return super:getSoulColor(self)
end

return character