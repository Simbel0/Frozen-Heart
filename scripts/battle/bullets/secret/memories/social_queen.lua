local Social, super = Class(Bullet)

function Social:init(x, y)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/memories/socialface")
    self.sprite:play(1/2)

    self.words = {
        "BRAVE",
        "ANGEL",
        "NICE",
        "KIND",
        "POWER",
        "KNIGHT"
    }
end

function Social:onWaveSpawn(wave)
    wave.timer:every(1, function()
        local font = Assets.getFont("main_mono")

        local word = Utils.pick(self.words)
        for i=1,#word do
            local char = word:sub(i, i)
            local w = font:getWidth(char)
            
            local b = wave:spawnBullet("secret/memories/letter", char, (self.x+(self.width/2))+w*i, self.y, font, false)
            b.physics.speed = 5
            b.physics.direction = Utils.angle(b, Game.battle.soul)
            b.alpha = 1
        end
    end)
end

function Social:update()
    -- For more complicated bullet behaviours, code here gets called every update

    super:update(self)
end

return Social