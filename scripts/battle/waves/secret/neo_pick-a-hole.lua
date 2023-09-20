local Basic, super = Class(Wave)

function Basic:init()
    super:init(self)
    self.time = 15
    self.mode = 1
end

function Basic:onStart()
    self.timer:everyInstant(1, function()
        -- Our X position is offscreen, to the right
        local hole = love.math.random(0, 3)
        local shooter = Utils.random()<0.3 and Utils.pick(Utils.filter({0, 1, 2, 3}, function(e)
            if e == hole then
                return false
            end
            return true
        end)) or -1
        print(hole, shooter)
        for i=0, 3 do
            if i ~= hole then
                local bullet = self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+30, 142+(i*37), math.rad(180), 5)
                if i == shooter then
                    print("oh hi :D")
                    bullet.shoot = true
                    bullet.flash = true
                end
            end
        end
    end)
end

function Basic:update()
    -- Code here gets called every frame

    for i,bullet in ipairs(self.bullets) do
        if not bullet.fading and bullet.x < Game.battle.arena.left then
            bullet.fading = true
            bullet:fadeOutAndRemove(0.5)
        end
    end

    super:update(self)
end

return Basic