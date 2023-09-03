local shadowSnowflake, super = Class(Wave)

function shadowSnowflake:init()
    super:init(self)
    self.time = 14
    self:setArenaSize((45*2)-15, 50)
end

function shadowSnowflake:onStart()
    self.encounter.noelle:setAnimation({"battle/point", 1/16, false})
    
    self.timer:everyInstant(2, function()
        Assets.playSound("spearappear")
        local bullet = self:spawnBullet("secret/snowflakeBullet", self.encounter.noelle.x-50, self.encounter.noelle.y, love.math.random()<0.5 and "left" or "right")
    end)
end

function shadowSnowflake:update()
    -- Code here gets called every frame

    super:update(self)
end

function shadowSnowflake:onEnd(death)
    print("hello")
    self.encounter.noelle:setAnimation("battle/idle")
end

return shadowSnowflake