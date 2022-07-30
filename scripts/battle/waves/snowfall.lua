local Snowfall, super = Class(Wave)

function Snowfall:init()
    super:init(self)
    self.time=12
end

function Snowfall:onArenaEnter()
    Game.battle.arena.color={0, 0, 1}
end

function Snowfall:onStart()
    -- Every 0.33 seconds...
    self.timer:every(math.random(5,15)/60, function()
        -- Our X position is offscreen, to the right
        local x = Utils.random(SCREEN_WIDTH/2, SCREEN_WIDTH + 20)
        -- Get a random Y position between the top and the bottom of the arena
        local y = Utils.random(-50, -10)

        local scale = Utils.random(0.25, 0.5)

        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
        local bullet = self:spawnBullet("snowflakeBullet", x, y, math.rad(Utils.random(110, 170)), Utils.random(2,6), math.random()>0.5 and true or false, scale)

        -- Dont remove the bullet offscreen, because we spawn it offscreen
        bullet.remove_offscreen = false
        self.timer:after(2, function() bullet.remove_offscreen = true end)
    end)
end

function Snowfall:update()
    -- Code here gets called every frame

    super:update(self)
end

return Snowfall