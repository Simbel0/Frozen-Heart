local phone, super = Class(Bullet)

function phone:init(x, y, speed)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/neo/phone")
    self.sprite:play(speed)
    self.sprite.frame=love.math.random(1,3)

    self.string = Rectangle(self.sprite.width/2, -880, 2, 900)
    self.string.color=COLORS.green
    self.string:setLayer(self.sprite.layer-1)
    self:addChild(self.string)

    --self.sprite:setScale(0.5, 0.5)
    self:setHitbox(25, 5, self.sprite.width/2, (self.sprite.height)-10)

    self.start=false
    self.sound_fired=false

    self.shot_health = Game.battle.encounter.cheater and 20 or 30
end

function phone:onWaveSpawn()
    if self.wave.mode>1 then
        self.shot_health = Game.battle.encounter.cheater and 30 or 40
    end
    self.wave.timer:tween(1, self, {y=(Game.battle.arena.bottom-Game.battle.arena.top/2)-40}, "in-bounce", function()
        self.start=true
    end)
end

function phone:update()
    super:update(self)
    if self.start then
        if self.sprite.frame==3 then
            if not self.sound_fired then
                Assets.playSound("phone")
                if self.wave.mode==1 then
                    self.wave:spawnBullet("neo/soundbullet", self.x, self.y+10, 10, false, true)
                    self.wave:spawnBullet("neo/soundbullet", self.x, self.y-self.sprite.height, 10, false, true)

                    self.wave:spawnBullet("neo/soundbullet", self.x, self.y+10, 10, false, false)
                    self.wave:spawnBullet("neo/soundbullet", self.x, self.y-self.sprite.height, 10, false, false)
                    self.sound_fired=true
                else
                    local bullets = {}
                    table.insert(bullets, self.wave:spawnBullet("neo/soundbullet", self.x, self.y+10, 6, false, true))
                    table.insert(bullets, self.wave:spawnBullet("neo/soundbullet", self.x, self.y+10, 6, false, true))
                    table.insert(bullets, self.wave:spawnBullet("neo/soundbullet", self.x, self.y-self.sprite.height, 12, false, true))
                    --self.wave:spawnBullet("neo/soundbullet", self.x, self.y-self.sprite.height, 12, false, true)

                    --self.wave:spawnBullet("neo/soundbullet", self.x, self.y+10, 12, false, false)
                    table.insert(bullets, self.wave:spawnBullet("neo/soundbullet", self.x, self.y+10, 6, false, true))
                    table.insert(bullets, self.wave:spawnBullet("neo/soundbullet", self.x, self.y-self.sprite.height, 6, false, true))
                    table.insert(bullets, self.wave:spawnBullet("neo/soundbullet", self.x, self.y-self.sprite.height, 6, false, true))

                    print(#bullets)
                    --[[local b = table.remove(bullets, love.math.random(1, #bullets))
                    print(b)
                    if b then --???
                        b.rotation = b.rotation + math.rad(Utils.random(-5, 5))
                        b.physics.speed = 11
                    end

                    local b2 = table.remove(bullets, love.math.random(1, #bullets))
                    print(b2)
                    if b2 then --???
                        b2.rotation = b2.rotation + math.rad(Utils.random(-5, 5))
                        b2.physics.speed = 11
                    end]]
                    for i,v in ipairs(bullets) do
                        v.rotation = v.rotation + math.rad(Utils.random(-7, 7))
                    end

                    self.sound_fired=true
                end
            end
        else
            self.sound_fired=false
        end
    end
end

function phone:onYellowShot(shot, damage)
    self.shot_health = self.shot_health - damage
    if self.shot_health <= 0 then
        self.start=false
        local afi=AfterImage(self.string, 1)
        afi.physics.grow_x=2
        self.string:addChild(afi)
        self.string.alpha=0
        Assets.playSound("explosion")
        local explosion=Explosion(shot.x, shot.y)
        explosion.layer=10000
        Game.battle:addChild(explosion)
        self.wave.timer:tween(3, self, {x=self.x+100, y=SCREEN_HEIGHT+100, rotation=math.rad(150)}, "out-cubic", function()
            Assets.playSound("impact")
            self.wave.timer:after(0.5, function()
                self.wave.finished=true
            end)
        end)
    else
        self.sprite.color={1, 0.8, 0.8}
        self.wave.timer:tween(1/8, self.sprite, {color={1, 1, 1}})
    end
    return "a", false
end

return phone