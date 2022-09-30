local Basic, super = Class(Wave)

function Basic:onStart()
    self.mode = Game.battle.encounter.sneo.wave_loop

    self.i=10
    self.lower=true
    -- Every 0.33 seconds...
    self.timer:every(1/6, function()
        -- Our X position is offscreen, to the right
        local x = SCREEN_WIDTH+40
        local y
        -- Get a random Y position between the top and the bottom of the arena
        if self.mode==1 then
            y = Game.battle.arena.top+self.i

            self.i = self.i + (self.lower and 15 or -15)

            if self.lower and (Game.battle.arena.top+self.i>=Game.battle.arena.bottom) then
                self.lower=false
            elseif not self.lower and (self.i<=0) then
                self.lower=true
            end
        else
            y = Utils.random(Game.battle.arena.top, Game.battle.arena.bottom+10)
        end

        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
        local bullet = self:spawnBullet("neo/crewBullet", x, y, math.rad(180), 10)

        -- Dont remove the bullet offscreen, because we spawn it offscreen
        bullet.remove_offscreen = false
    end)
end

function Basic:update()
    -- Code here gets called every frame

    super:update(self)
end

return Basic