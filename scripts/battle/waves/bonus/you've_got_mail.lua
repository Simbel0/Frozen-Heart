local you_ve_got_mail, super = Class(Wave)

function you_ve_got_mail:init()
    super:init(self)
    self.mode = Game.battle.encounter.sneo.wave_loop
    self.orig_rot = Game.battle.encounter.sneo.sprite:getPart("head").rotation
    self.timer_n = 0
    self.siner = 0
    self.time=Utils.random(10, 15)
    self:setArenaSize(310, 132)
    self:setArenaOffset(-100, 0)
end

function you_ve_got_mail:onStart()
    if not (self.mode==1) then
        self.timer:everyInstant(1.4, function()
            local y = Game.battle.soul.y+7
            self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+20, y, nil, 0.7, {Utils.random(Game.battle.arena.right, SCREEN_WIDTH-20), y}, false, true, true)
        end)
    end
    local sneo = self.encounter.sneo
    self.org_y=sneo.y
    sneo:setAnimation("walk")
    local arm = sneo.sprite:getPart("arm_l")
    sneo.sprite:setPartSprite("arm_l", "npcs/spamton/arm_cannon")
    sneo.sprite:setPartSwingSpeed("arm_l", 0)
    sneo.sprite:setHeadFrame(3)
    sneo.sprite:tweenPartRotation("arm_l", math.rad(math.deg(Utils.angle(sneo.x, sneo.y, Game.battle.soul.x, Game.battle.soul.y))), 0.3, "out-cubic")

    self.charge_sound = Assets.playSound("sneo_overpower", 1, 1)
    self.charge_sound:setLooping(true)
    self.shot_sound = Assets.playSound("spamton_laugh", 1, 1)
end

function you_ve_got_mail:update()
    local sneo = self.encounter.sneo
    local arm  = sneo.sprite:getPart("arm_l")
    print(self.timer_n)

    self.siner=self.siner+DTMULT

    sneo.y = sneo.y+math.sin(self.siner*0.3)*10

    if self.timer_n==0 then
        self.circle=Sprite("bullets/neo/bigcircle", arm.sprite.width, 9)
        self.circle:setScale(0)
        self.circle.graphics.grow=0.005
        self.circle:setLayer(arm.sprite.layer+10)
        --self.circle:setOrigin(1, 0)
        self.circle:shiftOrigin(0.5, 0.5)
        arm.sprite:addChild(self.circle)
        self.charge_sound:setPitch(1)
        self.charge_sound:play()
        shot_played = false
    elseif self.timer_n<=30 then
        arm.swing_rotation = Utils.angle(arm, Game.battle.soul)
        self.charge_sound:setPitch(1+(self.timer_n)/10)
    elseif self.timer_n>=40 and self.timer_n<60 then
        if self.circle then
            self.soul_pos = {Game.battle.soul.x, Game.battle.soul.y}
            self.circle:remove()
            self.circle=nil
        end
        local x, y = arm:getScreenPos()
        local mail_x, mail_y = x-(arm.sprite.width+20)+math.cos(arm.sprite.rotation), y+75*math.sin(arm.sprite.rotation)
        self:spawnBullet("neo/mail", mail_x, mail_y, arm.swing_rotation+math.rad(Utils.random(-3.5, 3.5)), Utils.random(20, 30))
        sneo.sprite:tweenPartRotation("head", math.rad(Utils.random(90, 110)), 0.2, "out-cubic")
        self.charge_sound:stop()
        if not shot_played then
            self.shot_sound:play()
            shot_played = true
        end
    elseif self.timer_n>60 then
        sneo.sprite:tweenPartRotation("head", math.rad(0), 0.3, "out-cubic")
        self.timer_n=-99
    end

    self.timer_n = self.timer_n + DTMULT
    --Stupid workaround so that the timer will be at 0 at the next frame no matter what
    if self.timer_n<0 then
        self.timer_n=0
    end

    super:update(self)
end

function you_ve_got_mail:onEnd()
    self.charge_sound:stop()

    local sneo = self.encounter.sneo

    sneo:setAnimation("idle")
    sneo.sprite:setHeadAnimating(true)
    sneo.sprite:resetPart("arm_l", true)

    Game.battle.timer:after(0.1, function()
        sneo.sprite:tweenPartRotation("head", math.rad(10), 0.3, "out-cubic")
        sneo.sprite:getPart("wing_l").swing_speed = 0
        sneo.sprite:getPart("wing_r").swing_speed = 0
    end)

    Game.battle.timer:tween(0.5, sneo, {y=self.org_y}, "out-cubic")

    super:onEnd(self)
end

return you_ve_got_mail