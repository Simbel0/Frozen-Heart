local falling_tornado, super = Class(Wave) --berd_fallingTornado

function falling_tornado:init()
    super:init(self)
    self.time = 10
end

function falling_tornado:onStart()
    self.double = #Game.battle.waves==2 --Make double idio
    self.timer:every(self.double and 1.15 or 0.75, function()
        local center_x, _ = Game.battle.arena:getCenter()
        -- Our X position is offscreen, to the right
        local x = Utils.random(center_x-20, center_x+20)
        -- Get a random Y position between the top and the bottom of the arena
        local y = -20

        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
        local bullet = self:spawnBullet("secret/tornado", x, y, math.rad(90), Utils.random(3,4))
        bullet.o_x = x+math.cos(Kristal.getTime()*2)*40
        bullet.speed_x = Utils.random(1,4)
        print(bullet.o_x)

        -- Dont remove the bullet offscreen, because we spawn it offscreen
        bullet.remove_offscreen = false
    end)
end

function falling_tornado:update()
    -- Code here gets called every frame

    for i,v in ipairs(self.bullets) do
        v.x = v.o_x+math.cos(Kristal.getTime()*v.speed_x)*40
    end

    super:update(self)
end

return falling_tornado