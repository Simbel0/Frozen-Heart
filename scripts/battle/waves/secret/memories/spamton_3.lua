local PipisFall, super = Class(Wave)

function PipisFall:init()
    super:init(self)

    self.time=10

    self.arena_throw = 0
end

function PipisFall:onStart()
    self.timer:everyInstant(1.5, function()
        self:spawnBullet("secret/memories/pipis", Utils.random(Game.battle.arena.left, Game.battle.arena.right), -20)
    end)
end

function PipisFall:update()
    -- Code here gets called every frame
    local arena = Game.battle.arena

    if self.arena_throw > 0 then
        self.arena_throw = self.arena_throw - 0.25*DTMULT

        arena.y = arena.y + self.arena_throw*DTMULT
    end

    if arena.y > 172 then
        arena.y = arena.y - 2*DTMULT
    end

    super:update(self)
end

return PipisFall