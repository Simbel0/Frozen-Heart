local spell, super = Class("ultimate_heal")

function spell:getCastMessage(user, target)
    local message = super:getCastMessage(self, user, target)
    if Game.battle.encounter.id ~= "noelle_battle" then
        return message
    end

    message = message:sub(2)
    if self.cost>50 then
        message = {"* Using your power,"..message, "* The cost of "..self:getCastName().." decreased!"}
        self.cost = self.cost - 10
    else
        message = {"* Using your power,"..message, "* The cost of "..self:getCastName().." can't decrease further."}
    end
    return message
end

function spell:onCast(user, target)
    if target.chara then
        Game:setFlag("no_heal", false)
    end
    if Game.battle.encounter.id ~= "noelle_battle" then
        super:onCast(self, user, target)
    else
        Game.battle.timer:script(function(wait)
            Assets.playSound("boost")
            user:flash()
            local bx, by = Game.battle:getSoulLocation()
            local soul = Sprite("effects/susiesoulshine", bx-15, by-15)
            soul:play(1/15, false, function() soul:remove() end)
            soul:setOrigin(0.25, 0.25)
            soul:setScale(2, 2)
            Game.battle:addChild(soul)
            wait(1)
            target:heal((user.chara:getStat("magic") * 8) * math.random(2,5))
            Game.battle:finishActionBy(user)
        end)
        return false
    end
end

function spell:getTarget()
    if Game.battle.encounter.id == "noelle_battle" then
        return "all"
    end
    return super:getTarget(self)
end

return spell
