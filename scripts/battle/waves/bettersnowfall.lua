local BetterSnowFall, super = Class(Wave)

function BetterSnowFall:init()
    super:init(self)
    self.time=10
    self:setArenaSize(400, 200)
    self:setArenaOffset(0, 40)
end

function BetterSnowFall:onArenaEnter()
    Game.battle.arena.color={0, 0, 1}
end

function BetterSnowFall:onStart()
    -- Every 0.33 seconds...
    self.timer:every(math.random(5,15)/60, function()
        -- Our X position is offscreen, to the right
        local x = Utils.random(SCREEN_WIDTH/2, SCREEN_WIDTH + 20)+40
        -- Get a random Y position between the top and the bottom of the arena
        local y = Utils.random(-50, -10)

        local scale = Utils.random(0.25, 0.5)

        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
        local bullet = self:spawnBullet("snowflakeBullet", x, y, math.rad(Utils.random(150, 200)), Utils.random(2,6), math.random()>0.5 and true or false, scale)

        -- Dont remove the bullet offscreen, because we spawn it offscreen
        bullet.remove_offscreen = false
        self.timer:after(Utils.random(1, 4), function()
            if bullet.x>0 and bullet.y>0 then
                for i=1,math.random(4,6) do
                    self:spawnBullet("lonelySnow", bullet.x, bullet.y, math.rad(Utils.random(360)), Utils.random(2,7))
                end
            end
            bullet:remove()
        end)
    end)
end

function BetterSnowFall:update()
    -- Code here gets called every frame

    super:update(self)
end

return BetterSnowFall