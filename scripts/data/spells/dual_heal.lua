local spell, super = Class("dual_heal", true)

function spell:onCast(user, target)
    for _,battler in ipairs(Game.battle.party) do
        battler:heal(user.chara:getStat("magic") * 5.5)
    end
end

return spell