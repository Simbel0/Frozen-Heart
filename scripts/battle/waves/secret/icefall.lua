local IceFall, super = Class(Wave)

function IceFall:init()
    super:init(self)
    self.time=10
end

function IceFall:onStart()
    self.double = #Game.battle.waves==2
    self.timer:every(self.double and 1.75 or 0.75, function()
        local start = Utils.random()<0.5 and "left" or "right"
        local x, y, angle

        if start == "left" then
            x, y, angle = 0, 0, math.rad(math.random(25, 45))
        else
            x, y, angle = SCREEN_WIDTH, 0, math.rad(math.random(145, 165))
        end

        local bullet = self:spawnBullet("snowflakeBullet", x, y, angle, 16, true, nil, nil, true)
    end)
end

function IceFall:update()
    -- Code here gets called every frame

    super:update(self)
end

return IceFall