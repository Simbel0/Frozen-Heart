local pipis, super = Class(Wave)

function pipis:init()
    super:init(self)
    self.time = 6
end

function pipis:onStart()
    local _, y = Game.battle.arena:getCenter()
    local pipis = self:spawnBullet("neo/pipis", self.encounter.sneo.x, y, 0, 0, true, 120, false)
    pipis.sprite.alpha=0
    pipis.sprite:fadeTo(1, 0.5)
end

return pipis