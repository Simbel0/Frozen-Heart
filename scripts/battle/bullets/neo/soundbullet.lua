local soundwave, super = Class(Bullet)

function soundwave:init(x, y, speed, flip, aim_player)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/neo/soundbullet")

    self.sprite.flip_x=flip

    self.sprite:setScale(0.5, 0.5)
    self:setHitbox(5, 5, (self.sprite.width/2)-10, (self.sprite.height/2)-10)

    --[[if aim_player then
        self.sprite.color=COLORS.red
    else
        self.sprite.color=COLORS.aqua
    end]]

    print(math.deg(Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y))+4)

    self.physics.speed=speed
    self.rotation=aim_player and math.rad(math.deg(Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y))+4) or math.rad(Utils.random(150, 170))
    self.physics.match_rotation=true

    self.start=false
end

function soundwave:update()
    super:update(self)
end

return soundwave