local Heart_Wire, super = Class(Bullet)

function Heart_Wire:init(x, y, physics)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/neo/wire")
    self.sprite:stop()
    self.width, self.height = self.sprite.width, self.sprite.height

    self:setHitbox(5, 5, 11, 11)

    self:setLayer(self.layer - 5)

    self.physics.speed_x = physics["speed_x"]
    self.physics.speed_y = physics["speed_y"]
    self.physics.gravity = physics["gravity"]

    --self.index_in_history = 0-(15*order)
end

function Heart_Wire:onWaveSpawn(wave)
    self.width = 20
    self.height = 20
    self.sprite:setOrigin(0.30)
    self:setHitbox(5, 5, 11, 11)
end

function Heart_Wire:update()
    -- For more complicated bullet behaviours, code here gets called every update

    if self.y + self.height >= Game.battle.arena.bottom and self.x > Game.battle.arena.left then
        self.physics.speed_y = -self.physics.speed_y + 0.6
        self.y = self.y - 10
    end

    super:update(self)
end

function Heart_Wire:isOffScreen()
    return self.x < -100 or self.y < -100 or self.x > SCREEN_WIDTH + 100 or self.y > SCREEN_HEIGHT + 100
end

function Heart_Wire:onYellowShot(shot, damage)
    return "b", false
end

return Heart_Wire