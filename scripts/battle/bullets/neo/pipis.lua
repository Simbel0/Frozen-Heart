local pipis, super = Class(Bullet)

function pipis:init(x, y, speed, dir, indication, explosion_point, rotating)
    super:init(self, x, y, "bullets/neo/pipis")
    self.sprite:stop()

    self.physics.direction = dir
    self.physics.speed = speed
    self.physics.friction = -0.05

    self.graphics.spin = rotating and Utils.random(1, 3) or 0

    self.shot_health = 3
    self.shot_tp = 1

    if type(explosion_point)=="table" then
        print(explosion_point["y"])
        self.x_dead = explosion_point["x"]
        self.y_dead = explosion_point["y"]
    elseif type(explosion_point)=="number" then
        self.time_out = explosion_point
    end

    if indication then
        print("indi")
        self.indication = Sprite("bullets/neo/pipis_sign", self.x-25, self.y+20)
        self.indication:setScale(1)
        self.indication:setOrigin(0.5, 0)
        Game.battle:addChild(self.indication)
    end

    self.remove_offscreen = false
end

function pipis:update()
    super:update(self)
    --print(self.y, self.y_dead, self.y>=self.y_dead)

    if self.indication then
        self.indication:setPosition(self.x-25, self.y+20)
    end

    if self.y_dead and self.y>=self.y_dead then
        print("oh")
        for i=1,5 do
            local bullet = self.wave:spawnBullet("neo/crewBullet", self.x, self.y, math.rad((math.deg(Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y))+Utils.random(10, 20))-17), Utils.random(15, 20), nil, false, false, false)
            bullet:setScale(1)
            bullet:setHitbox(5, 5, (bullet.sprite.width*bullet.sprite.scale_x)-10, (bullet.sprite.width*bullet.sprite.scale_y)-10)
        end
        self.shot_tp=0
        self:destroy()
    elseif self.time_out then
        self.time_out=self.time_out-DTMULT

        if self.time_out<=0 then
            for i=1,5 do
                local bullet = self.wave:spawnBullet("neo/crewBullet", self.x, self.y, math.rad((math.deg(Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y))+Utils.random(10, 20))-17), Utils.random(15, 20), nil, false, false, false)
                bullet:setScale(1)
                bullet:setHitbox(5, 5, (bullet.sprite.width*bullet.sprite.scale_x)-10, (bullet.sprite.width*bullet.sprite.scale_y)-10)
            end
            self.shot_tp=0
            self:destroy()
        end
    end
end

function pipis:onYellowShot(shot, damage)
    self.shot_health = self.shot_health - damage
    self.sprite:setFrame(4-self.shot_health)
    if self.shot_health <= 0 then
        self:destroy()
    else
        local piece = Sprite("bullets/neo/pipis_piece", self.x, self.y)
        piece:setFrame(love.math.random(1, 3))
        piece.physics.direction = math.rad(Utils.random(360))
        piece.physics.speed = Utils.random(4, 8)
        piece.alpha = 4
        piece.graphics.fade_to = 0
        piece.graphics.fade_callback = function() piece:remove() end
        piece.graphics.fade = 0.1
        Game.battle:addChild(piece)
    end
    return "a", false
end

function pipis:destroy(shot)
    Game:giveTension(self.shot_tp)
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
    if self.indication then self.indication:remove() end
    self:remove()
end

return pipis