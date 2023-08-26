local CharacterBullet, super = Class(Bullet)

function CharacterBullet:init(texture, x, y, order, flip)
    -- Last argument = sprite path
    self.texture = texture
    super:init(self, x, y, "bullets/memories/angel/"..texture:upper())

    self.order = order

    self.sprite.flip_x = flip
end

function CharacterBullet:onWaveSpawn(wave)
    self.shake_mouv = wave.timer:every(0.35, function()
        self.x = self.init_x + Utils.random(-3, 3)
        self.y = self.init_y + Utils.random(-3, 3)
    end)
end

function CharacterBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super:update(self)
end

return CharacterBullet