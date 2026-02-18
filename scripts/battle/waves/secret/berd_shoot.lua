local shoot, super = Class(Wave) --berd_shoot

function shoot:init()
    super:init(self)
    self.time = -1

    self.end_script = false

    -- Make the bullets act like that one attack from the Roaring Knight because why not lol
    self.knight_attack = love.math.random()<=0.75

    --self:setArenaOffset(25, 0)
end

function shoot:onStart()
    self.double = #Game.battle.waves==2 --Make double idio
    if self.double then
        self.knight_attack = false
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
        self.base.rotation = math.pi
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
                local delay = self.knight_attack and 30 or (i-1)*5
                self:spawnBullet("secret/weird_sine", self.base.x, self.base.y, area, delay, self.knight_attack and -50 or -10, self.knight_attack)
                wait(0.1)
            end

            if self.knight_attack then
                self.timer:after(2.5, function()
                    for i,bullet in ipairs(self.bullets) do
                        if bullet.id == "secret/weird_sine" then
                            bullet:launch()
                        end
                    end
                end)
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
            self.timer:after(0.2, function()
                self.finished = true
            end)
        end
    end

    super.update(self)
end

function shoot:draw()

    if self.knight_attack or DEBUG_RENDER then
        for i,bullet in ipairs(self.bullets) do
            if bullet.id == "secret/weird_sine" then
                if not bullet.launched or DEBUG_RENDER then
                    love.graphics.setLineWidth(3)
                    love.graphics.setColor(1,0,0,Utils.clampMap(bullet.timer, 25, 50+bullet.delay, 0, 0.5))
                    local x = bullet.goto_x-math.cos(bullet.rotation)*700
                    local y = bullet.goto_y-math.sin(bullet.rotation)*700
                    love.graphics.line(bullet.goto_x, bullet.goto_y, x, y)
                end
            end
        end
    end

    super.draw(self)
end

function shoot:onEnd(death)
    if not death then
        self.encounter.berdly.sprite:resetSprite()
        Game.battle.timer:tween(1, self.encounter.berdly, {x=self.berdly_orig_x}, "out-expo")
    end
end

return shoot