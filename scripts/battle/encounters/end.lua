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