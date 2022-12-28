local falling_tornado, super = Class(Wave) --berd_fallingTornado

function falling_tornado:init()
    super:init(self)
    self.time = 10
end

function falling_tornado:onStart()
    -- Every 0.33 seconds...
    self.timer:every(1, function()
        -- Our X position is offscreen, to the right
        local x = Utils.random(Game.battle.arena.left, Game.battle.arena.right)
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