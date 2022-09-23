local Snowfall_alter, super = Class(Wave)

function Snowfall_alter:init()
    super:init(self)
    self.time=10
    self:setArenaSize(400, 18)
end

function Snowfall_alter:onArenaEnter()
    Game.battle.arena.color={0, 0, 1}
end

function Snowfall_alter:onStart()
    -- Every 0.33 seconds...
    self.timer:everyInstant(Utils.random(5,15)/60, function()
        -- Our X position is offscreen, to the right
        local x = Utils.random(Game.battle.arena.left, Game.battle.arena.right)
        -- Get a random Y position between the top and the bottom of the arena
        local y = -50

        local scale = Utils.random(0.25, 0.5)

        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
        local bullet = self:spawnBullet("snowflakeBullet", x, y, math.rad(90), Utils.random(2,6), nil, scale)

        -- Dont remove the bullet offscreen, because we spawn it offscreen
        bullet.remove_offscreen = false
        self.timer:after(2, function() bullet.remove_offscreen = true end)
    end)
end

function Snowfall_alter:update()
    -- Code here gets called every frame

    super:update(self)
end

return Snowfall_alter