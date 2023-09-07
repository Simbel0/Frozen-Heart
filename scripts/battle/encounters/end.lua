local End, super = Class(Encounter)

function End:init()
    super:init(self)

    self.text = ""

    self.music = "soliloquy"
    self.background = false

    self.memories = self:addEnemy("memories")
    self.memories:setScreenPos(SCREEN_WIDTH-140, 260)

    Game.battle.party[1].actor.path = "party/noelle/dark"

    self.default_xactions = false

    Game.battle:registerXAction("noelle", "Remember", nil, 10)

    Game.world.camera.x = 995

    Utils.hook(Battle, "returnSoul", function(orig, og_self, dont_destroy)
        if dont_destroy == nil then dont_destroy = false end
        local bx, by = 325, 55
        if og_self.soul then
            og_self.soul:transitionTo(bx, by, not dont_destroy)
        end
    end)

    Utils.hook(HeartBurst, "init", function(orig, og_self, x, y, color)
        orig(og_self, x-9, y-9, color)
        print("oh")
    end)

    Utils.hook(Bullet, "onDamage", function(orig, self, soul)
        local damage = self:getDamage()
        if Game.battle.party[1].chara:getHealth() - damage <= 0 then
            Game.battle:hurt(Game.battle.party[1].chara:getHealth()-1, true, self:getTarget())
            Game.battle:setState("ACTIONSELECT")
        else
            orig(self, soul)
        end
    end)
end

function End:onBattleStart()
    self.alpha_fx = AlphaFX(1)
    Game.battle.party[1]:addFX(self.alpha_fx)
    Game.battle.battle_ui.action_boxes[1]:addFX(self.alpha_fx)
end

function End:update()
    if self.ending then
        local battler = Game.battle.party[1]
        battler.thorn_ring_timer = (battler.thorn_ring_timer or 0) + DTMULT

        if battler.thorn_ring_timer >= 6 then
            battler.thorn_ring_timer = battler.thorn_ring_timer - 6

            if battler.chara:getHealth() >= 0 then
                battler.chara:setHealth(battler.chara:getHealth() - 1)
            end
            if battler.chara:getHealth() == 0 then
                Game.battle.timer:tween(3, self.alpha_fx, {alpha=0})
                Game.battle.music:fade(0, 3)
            end
        end
    end
    super:update(self)
end

function End:getPartyPosition(index)
    if index == 1 then
        return 140, 260
    end
    return super.getPartyPosition(index)
end

function End:createSoul(bx, by, color)
    return Soul(325, 55, color)
end

return End