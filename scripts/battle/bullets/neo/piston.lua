local piston, super = Class(Bullet)

function piston:init(x, y, dir, speed, shootable, flip)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/neo/crew")
    self:setOrigin(0.5, 0.5)
    self.sprite:play(0.15)

    self.x_orig = x
    self.y_orig = y

    self.shootable = shootable~=nil and shootable or true
    self.siner = 0
    self.timer = 0

    self.sprite.flip_x = flip
    self.stopped = true

    if not flip then
        self.remove_offscreen = false
    end
    self.destroy_on_hit = false

    if self.shootable then
        self:setColor(21/255, 203/255, 231/255)
    end

    self.y_dest = {
        5,
        (self.sprite.height/2)-5
    }

    self.sprite.alpha=0

    --self.sprite:setScale(0.5, 0.5)
    --self:setHitbox(5, 5, (self.sprite.width/2)-10, (self.sprite.height/2)-10)

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed

    self.piston_bottom = Sprite("bullets/neo/pillar_piston", flip and 5 or 2, 320)
    self.piston_bottom:setOrigin(0, 0)
    self.piston_bottom:setLayer(self.layer-10000)
    self:addChild(self.piston_bottom)

    self.piston_bottom_tube = Sprite("bullets/neo/pillar_thicc", 0, self.piston_bottom.height)
    self.piston_bottom_tube:setOrigin(0, 0)
    self.piston_bottom_tube.scale_y = 999
    self.piston_bottom:addChild(self.piston_bottom_tube)

    self.piston_top = Sprite("bullets/neo/pillar_piston", flip and 5 or 2, -320)
    self.piston_top:setOrigin(1, 1)
    self.piston_top.rotation = math.rad(180)
    self.piston_top:setLayer(self.layer-10000)
    self:addChild(self.piston_top)

    self.piston_top_tube = Sprite("bullets/neo/pillar_thicc", 0, self.piston_top.height)
    self.piston_top_tube:setOrigin(0, 0)
    self.piston_top_tube.scale_y = 999
    self.piston_top:addChild(self.piston_top_tube)

    if self.sprite.flip_x then
        self.collider = ColliderGroup(self, {
            Hitbox(self, 5, 5, (self.sprite.width*self.sprite.scale_x)-10, (self.sprite.height*self.sprite.scale_y)-10),
            Hitbox(self, 5, -320, self.piston_top_tube.width-10, 999)
        })
    end
end

function piston:onWaveSpawn()
    self.wave.timer:tween(0.75, self.piston_top, {y=5}, "linear", function()
        self.sprite.alpha = 1
        self.stopped = false
        --local fx = ColorMaskFX(nil, 4)
        --self.sprite:addChild(fx)
        --self.wave.timer:tween(0.5, fx, {amount=0})
    end)
    self.wave.timer:tween(0.75, self.piston_bottom, {y=(self.sprite.height/2)-5})
end

function piston:update()
    super:update(self)
    if not self.stopped then
        self.siner = self.siner + DT
        self.timer = self.timer + DT
    end

    if self.sprite.flip_x then
        self.x=self.x+0.5
    else
        if not self.stopped then
            self.x = (self.x_orig-25) + math.cos(self.timer*4)*60
            self.y = (self.y_orig-55) + math.sin(self.timer*2)*95
        end
    end

    if not self.stopped then
        if self.sprite.alpha==1 and not self.sprite.flip_x then
            if self.sprite.frame==3 then
                if not self.shooted then
                    self.shooted=true
                    for i=-1,2 do
                        self.wave:spawnBullet("neo/bullet", self.x, self.y, math.rad(180+(i*8)), 10)
                    end
                end
            else
                self.shooted=false
            end
        end
    end
end

function piston:onYellowShot(shot, damage)
    if self.shootable and not self.stopped then
        self.stopped = true
        self.sprite:pause()
        self.sprite:setFrame(4)
        Assets.playSound("bell")
        self.wave.timer:after(Game.battle.encounter.cheater and (damage>1 and 0.25 or 0.05) or (damage>1 and 0.5 or 0.2), function()
            self.stopped = false
            self.sprite:resume()
        end)
    end
    return "c", false
end

function piston:onCollide(soul)
    soul.x = soul.x + 30
    super:onCollide(self, soul)
end

return piston