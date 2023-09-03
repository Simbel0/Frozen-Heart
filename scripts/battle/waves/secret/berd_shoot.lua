local shoot, super = Class(Wave) --berd_shoot

function shoot:init()
    super:init(self)
    self.time = -1

    self.end_script = false
end

function shoot:onStart()
    self.double = #Game.battle.waves==2 --Make double idio
    if self.double then
        for i,wave in ipairs(Game.battle.waves) do
            if wave.id ~= self.id then
                self.time = wave.time
            end
        end
    end
    local berdly = self.encounter.berdly
    self.berdly_orig_x = berdly.x
    self.timer:script(function(wait)
        Assets.playSound("jump")
        berdly:setAnimation("sine_start")
        wait(((1/14)*7)+0.5)
        Assets.playSound("bell", 0.5, 0.6)
        Assets.playSound("bell", 0.5, 0.8)
        berdly:setAnimation("sine_end")
        self.timer:tween((1/14)*2.5, berdly, {x=535}, "out-expo")
        wait((1/14)*5)
        self.base = self:spawnSprite("bullets/weird_sine", berdly.x-73, berdly.y-44)
        self.base.alpha = 0
        self.base:setGraphics({
            fade_to = 1,
            fade = 0.2
        })
        while self.base.alpha < 1 do
            wait()
        end
        wait(0.1)
        if not self.double then
            for i = 1, 10 do
                local area = Utils.random()<0.5 and "up" or "down"
                self:spawnBullet("secret/weird_sine", self.base.x, self.base.y, area, (i-1)*10)
                wait(0.1)
            end
        else
            self.timer:everyInstant(2, function()
                local area = Utils.random()<0.5 and "up" or "down"
                self:spawnBullet("secret/weird_sine", self.base.x, self.base.y, area, 0)
            end, math.huge)
        end
        self.end_script = true
    end)
end

function shoot:update()

    if self.end_script and not self.double then
        if #self.bullets == 0 then
            self.timer:after(0.5, function()
                self.finished = true
            end)
        end
    end

    super.update(self)
end

function shoot:onEnd(death)
    if not death then
        self.encounter.berdly.sprite:resetSprite()
        Game.battle.timer:tween(1, self.encounter.berdly, {x=self.berdly_orig_x}, "out-expo")
    end
end

return shoot