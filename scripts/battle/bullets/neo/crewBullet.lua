local crewBullet, super = Class(Bullet)

function crewBullet:init(x, y, dir, speed, destination, protected, shoot, shootable)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/neo/crew")

    self.sprite:setScale(0.5, 0.5)
    self:setHitbox(5, 5, (self.sprite.width*self.sprite.scale_x)-10, (self.sprite.height*self.sprite.scale_y)-10)

    self.shootable = shootable~=nil and shootable or true

    if self.shootable then
        self:setColor(21/255, 203/255, 231/255)
    end

    if protected then
        self.shield=Sprite("bullets/neo/barrier")
        self.shield:setScale(0.5)
        self.shield:setOrigin(0.5, 0.5)
        self.shield.x=self.sprite.width/4
        self.shield.y=self.sprite.height/4
        self.shield.graphics.spin = 0.1

        self.bullet_collider = ColliderGroup(self.shield, {
            CircleCollider(self.shield, 44, 44, 40, {invert = true}), -- whole shield collider, with a radius of 40 pixels (allowing some leniency)
            Hitbox(self.shield, 5,20, 62, 60) -- a collider that will make it so a chunk of the collider doesn't count as collision
        }, {invert = true})

        self:addChild(self.shield)
    end

    self.start = false
    if destination==nil then
        -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
        self.physics.direction = dir
        -- Speed the bullet moves (pixels per frame at 30FPS)
        self.physics.speed = speed
        self.start = true
    else
        self.dest=destination
        self.speed=speed
        self.start = false
    end

    self.shoot = shoot

    self.red_mode = false
    self.red_mode_limit = 0

    self.shot_health = 1
    self.shot_tp = 1
end

function crewBullet:onWaveSpawn()
    if self.dest then
        self.wave.timer:tween(self.speed, self, {x=self.dest[1], y=self.dest[2]}, "out-quad", function()
            self.start = true
        end)
    end
end

function crewBullet:draw()
    super:draw(self)
    if DEBUG_RENDER then
        if self.bullet_collider then
            self.bullet_collider:drawFor(self, 1,0,0)
        end
    end
end

function crewBullet:update()
    super:update(self)

    if not self.red_mode then
        if self.start then
            if self.shoot and self.sprite.frame==3 then
                if not self.shooted then
                    self.shooted=true
                    Assets.stopAndPlaySound("voice/sneo")
                    if self.wave.mode == 1 then
                        self.wave:spawnBullet("neo/bullet", self.x, self.y, math.rad(180), 10)
                    else
                        self.wave:spawnBullet("neo/bullet", self.x, self.y, Utils.angle(self.x, self.y, Game.battle.soul.x+Game.battle.soul.width/2, Game.battle.soul.y+Game.battle.soul.height/2), 15)
                    end
                end
            else
                self.shooted=false
            end
        end

        if self.shield then
            for i,shot in ipairs(Game.stage:getObjects(YellowSoulShot)) do
            if self.bullet_collider:collidesWith(shot) then
                Assets.playSound("bell")
                shot:destroy()
                self.shield.color ={1, 0, 0}
                Game.battle.timer:tween(0.1, self.shield.color, {1,1,1})
                end
            end
        end
    else
        if self.red_mode_limit>0 then
            self.sprite:shake()
            self.sprite.anim_speed = self.sprite.anim_speed + (((#self.wave.crews+1)-self.red_mode_order)/10) * DTMULT
            self.x = self.x + 0.5 * DTMULT
            self.red_mode_limit = self.red_mode_limit-DTMULT
            if Utils.random(0, 10)<5 then
                Assets.stopAndPlaySound("voice/sneo")
            end
        else
            if self.physics.speed~=20 and not self.explosion then
                self.physics.speed = 20
                if self.wave.mode == 1 then
                    self.physics.direction = math.pi
                else
                    self.physics.direction = Utils.angle(self.x, self.y, Game.battle.soul.x+Game.battle.soul.width/2, Game.battle.soul.y+Game.battle.soul.height/2)
                end
            end
            if self.x<Game.battle.arena.left then
                self:resetPhysics()
                self.sprite.alpha = 0
                self.wave:spawnBullet("neo/explosion", self.x, self.y, 4.5, 1, 1.5)
                Assets.stopAndPlaySound("badexplosion")
                self:remove()
            end
        end
    end
end

function crewBullet:selfDestructMode(order)
    self.red_mode = true
    self.red_mode_limit = 45 + ((self.wave.mode==1 and 10 or 12) * order)
    self.red_mode_order = order
    self.shootable = false
    self.wave.timer:tween(0.5, self, {color={1, 0, 0}})
    if self.alpha < 1 then
        self:fadeTo(1, 1)
    end
    if self.shield then
        self.shield:fadeOutAndRemove(1)
    end
end

function crewBullet:onYellowShot(shot, damage)
    if self.shootable then
        self.shot_health = self.shot_health - damage
        if self.shot_health <= 0 then
            if self.shield then
                self.shield:remove()
            end
            self.physics = {}
            self.collidable = false
            self.sprite:stop()
            self.graphics.grow = 0.1
            self:fadeTo(0, 0.1, function() self:destroy() end)
        end
    end
    return "c", false
end

function crewBullet:destroy(shot)
    Game:giveTension(self.shot_tp)
    self:remove()
end

function crewBullet:onRemove(parent)
    if self.wave.id == "bonus/protectedCrew" then
        Utils.removeFromTable(self.wave.crews, self)
    end
end

return crewBullet