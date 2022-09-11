local spell, super = Class("ultimate_heal")

function spell:init()
    super:init(self)
    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "all"
end

function spell:getCastMessage(user, target)
    local message = super:getCastMessage(self, user, target):sub(2)
    if self.cost>50 then
        message = {"* Using your power,"..message, "* The cost of "..self:getCastName().." decreased!"}
        self.cost = self.cost - 10
    else
        message = {"* Using your power,"..message, "* The cost of "..self:getCastName().." can't decrease anymore."}
    end
    return message
end

function spell:onCast(user, target)
    if target.chara then
        Game:setFlag("no_heal", false)
    end
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
end

return spell
