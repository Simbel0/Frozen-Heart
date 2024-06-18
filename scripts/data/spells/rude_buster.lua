local spell, super = Class("rude_buster", true)

function spell:getCastMessage(user, target)
    local message = super:getCastMessage(self, user, target)
    if (Game.battle.encounter.id == "secret_battle" and Game.battle.encounter.intro) then
        message = "[noskip]"..message.."\n[wait:5][speed:0.1]* ...[speed:1]But "..user.chara:getName().." couldn't see anything."
    end
    return message
end

function spell:onCast(user, target)
    local buster_finished = false
    local anim_finished = false
    local function finishAnim()
        anim_finished = true
        if buster_finished then
            Game.battle:finishAction()
        end
    end
    if not user:setAnimation("battle/rude_buster", finishAnim) then
        anim_finished = false
        user:setAnimation("battle/attack", finishAnim)
    end
    Game.battle.timer:after(15/30, function()
        Assets.playSound("rudebuster_swing")
        local full_miss = (Game.battle.encounter.id == "secret_battle" and Game.battle.encounter.intro)
        local x, y = user:getRelativePos(user.width, user.height/2 - 10, Game.battle)
        local tx, ty = target:getRelativePos(target.width/2, target.height/2, Game.battle)
        if full_miss then
            tx = 800
        end
        local blast = RudeBusterBeam(false, x, y, tx, ty, function(pressed)
            if not full_miss then
                local damage = math.ceil((user.chara:getStat("magic") * 5) + (user.chara:getStat("attack") * 11) - (target.defense * 3))
                if pressed then
                    damage = damage + 30
                    Assets.playSound("scytheburst")
                end
                if target.id == "ring_noelle" then
                    if not Game.battle.encounter.last_section then
                        damage = love.math.random(2, 5)+(pressed and 1 or 0)
                    end
                elseif target.id == "Spamton_NEO" then
                    damage = Utils.round(damage/2)+(pressed and 30 or 0)
                end

                target:flash()
                target:hurt(damage, user)
            end
            buster_finished = true
            if anim_finished then
                Game.battle:finishAction()
            end
        end)
        blast.layer = BATTLE_LAYERS["above_ui"]
        Game.battle:addChild(blast)
    end)
    return false
end

return spell