local pipis, super = Class(Bullet)

function pipis:init(x, y, speed, dir)
    super:init(self, x, y, "bullets/neo/pipis")
    self.sprite:stop()

    self.physics.direction = dir
    self.physics.speed = speed
    self.physics.gravity = 0.5

    self.graphics.spin = 2

    self.remove_offscreen = false
end

function pipis:update()
    super:update(self)

    if self.y >= Game.battle.arena.top-self.sprite.height/2 then
        for i=1,5 do
            local bullet = self.wave:spawnBullet("neo/crewBullet", self.x, self.y, math.rad((math.deg(Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y))+Utils.random(10, 20))-17), 10, nil, false, false, false)
            bullet:setScale(1)
            bullet:setHitbox(5, 5, (bullet.sprite.width*bullet.sprite.scale_x)-10, (bullet.sprite.width*bullet.sprite.scale_y)-10)
        end
        Assets.playSound("snd_explosion_8bit")
        self:destroy()
    end
end

function pipis:destroy()
    for i=1,3 do
        local piece = Sprite("bullets/neo/pipis_piece", self.x, self.y)
        piece:setFrame(i)
        piece:setScale(2)
        piece.physics.direction = math.rad(Utils.random(360))
        piece.physics.speed = 4
        piece.physics.gravity = 0.2
        piece.alpha = 3
        piece.graphics.fade_to = 0
        piece.graphics.fade_callback = function() piece:remove() end
        piece.graphics.fade = 0.1
        Game.battle:addChild(piece)
    end
    self.wave.arena_throw = 7
    self:remove()
end

return pipis