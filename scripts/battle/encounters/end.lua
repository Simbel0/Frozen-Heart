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