local Tornado, super = Class(Bullet)

function Tornado:init(x, y, area, delay, speed, knight)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/weird_sine")
    self:setScale(2)
    self:setHitbox(13, 6.5, 15, 9)

    self.sprite:setScaleOrigin(0.5)
    self.sprite:setScale(-1, 1)
    self.sprite.y = 1.5

    self.goto_x = Utils.random(x, x+27*2)
    if area == "up" then
        self.goto_y = Utils.random(Game.battle.encounter.berdly.y - Game.battle.encounter.berdly.sprite.height*2, 10)
    else
        self.goto_y = Utils.random(Game.battle.encounter.berdly.y, SCREEN_HEIGHT-10)
    end

    self.goto_rot = (Utils.angle(Game.battle.soul.x, Game.battle.soul.y, self.goto_x, self.goto_y))+math.rad(Utils.random(-15, 15))

    self.timer = 0
    self.launched = false
    self.delay = delay
    self.speed = speed or -5
    self.knight_mode = knight or false

    self.remove_offscreen = true

    Assets.playSound("snd_spearrise")
end

function Tornado:launch()
    self.launched = true
    Assets.stopAndPlaySound("criticalswing")
    self:setPhysics({
        match_rotation = true,
        speed = self.speed
    })
    if not Kristal.Config["simplifyVFX"] then
        self.wave.timer:every(1/10, function()
            if not self or self:isRemoved() then return false end
            local img = AfterImage(self.sprite, 0.5)
            img:setLayer(self:getLayer()-0.1)
            Game.battle:addChild(img)
        end)
    end
end

function Tornado:update()
    -- For more complicated bullet behaviours, code here gets called every update
    self.timer = self.timer + DTMULT

    if self.timer < 30 then
        self.x = Utils.ease(self.init_x, self.goto_x, self.timer/30, "out-cubic")
        self.y = Utils.ease(self.init_y, self.goto_y, self.timer/30, "out-cubic")
        self.rotation = Utils.ease(0, self.goto_rot, self.timer/30, "out-cubic")
    elseif not self.knight_mode and self.timer >= 50+self.delay and not self.launched then
        self:launch()
    end

    super:update(self)
end

return Tornado