local itsRainingPipis, super = Class(Wave)

function itsRainingPipis:init()
    super:init(self)
    self.mode = Game.battle.encounter.sneo.wave_loop
    self.time=-1
    self.wait_for_end = false
    self:setArenaSize(142, (142*2)-15)
    self:setArenaOffset(-150, 0)
end

function itsRainingPipis:onStart()
    local sneo = self.encounter.sneo
    self.org_x=sneo.x
    local arm = sneo.sprite:getPart("arm_l")
    self.wall = Sprite("bullets/neo/pipis_wall", Game.battle.arena.right+17, Game.battle.arena.bottom+3)
    self.wall:setOrigin(0, 0.5)
    self.wall:setScale(4.5, 2)
    self.wall:setColor(Utils.unpack(Game.battle.arena.color))
    self.wall.alpha = 0
    self.wall.graphics.fade_to = 1 
    Game.battle:addChild(self.wall)
    self.timer:script(function(wait)
        sneo.sprite:setPartSprite("arm_l", "npcs/spamton/arm_cannon")
        sneo.sprite:setPartSwingSpeed("arm_l", 0)
        sneo.sprite:setHeadFrame(2)
        sneo.sprite:tweenPartRotation("arm_l", math.rad(270), 0.3, "out-cubic")
        wait(0.5)
        sneo.sprite:setPartSprite("arm_l", "npcs/spamton/arm_cannon_egg")
        local reboot_egg = 0
        self.timer:every(0.75, function()
            sneo.sprite:setPartSprite("arm_l", "npcs/spamton/arm_cannon")
            sneo.sprite:tweenPartRotation("arm_l", math.rad(290), 0.1, "out-cubic")
            Assets.playSound("wing")
            for i = 0, 2 do
                local pipis = Sprite("bullets/neo/pipis", 0, -35)
                pipis.physics.direction = math.rad(250+(20*i)+Utils.random(-10, 10))
                pipis.physics.speed = 12
                pipis.graphics.spin = love.math.random(1, 4)
                arm:addChild(pipis)
            end
            reboot_egg = reboot_egg + 1
            self.timer:after(0.12, function()
                sneo.sprite:tweenPartRotation("arm_l", math.rad(270), 0.2, "out-cubic")
                if reboot_egg<(self.mode==1 and 3 or 4) then
                    self.timer:after(0.1, function()
                        sneo.sprite:setPartSprite("arm_l", "npcs/spamton/arm_cannon_egg")
                    end)
                end
            end)
        end, self.mode==1 and 3 or 4)
        wait((0.75*(self.mode==1 and 3 or 4))+0.25)
        Assets.playSound("snd_sneo_laugh_long")
        sneo.sprite:setHeadFrame(3)
        sneo.sprite:setAllPartsShaking(true)
        Game.battle.timer:tween(2, sneo, {x=SCREEN_WIDTH+80}, "out-cubic")
        self.wall.graphics.fade = 0.1
        wait(1.2)
        self.wait_for_end = true
        self.timer:everyInstant(1, function()
            print("pipis")
            self:spawnBullet("neo/pipis", Utils.random(Game.battle.arena.right+20, SCREEN_WIDTH-20), -10, Utils.random(1, 3), math.rad(90), Game:getFlag("first_pipis", true), {y=Game.battle.arena.bottom-6}, true)
            Game:setFlag("first_pipis", false)
        end, self.mode==1 and 10 or 15)
    end)
end

function itsRainingPipis:update()
    -- Code here gets called every frame
    if self.wait_for_end then
        if #self.bullets==0 then
            self.wait_for_end=false
            Game.battle.timer:after(1, function()
                self.finished=true
            end)
        end
    end

    super:update(self)
end

function itsRainingPipis:onEnd()
    local sneo = self.encounter.sneo

    sneo.sprite:setHeadAnimating(true)
    sneo.sprite:setAllPartsShaking(false)
    sneo.sprite:resetPart("arm_l", true)
    Game.battle.timer:tween(0.5, sneo, {x=self.org_x}, "out-cubic")

    self.wall:fadeTo(0, 0.5, function()
        self.wall:remove()
    end)
    super:onEnd(self)
end

return itsRainingPipis