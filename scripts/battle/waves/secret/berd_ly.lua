local actuallyHim, super = Class(Wave)

function actuallyHim:init()
    super:init(self)
    self.time=12
    self.wave=0
end

function actuallyHim:onStart()
    self.timer:everyInstant(1.5, function()
        self.wave = self.wave+1
        local wave = self.wave
        --for i=1,#self.bullets do
        --    self.bullets[i]:remove()
        --end
        for i=1,4 do
            local x = Game.battle.arena.right+30

            local y = (Game.battle.arena.top-40)+45*i

            local bullet = self:spawnBullet("secret/tornado", x, y, math.rad(180), 0)
            bullet.alpha=0
            bullet.wave = self.wave
            self.timer:tween(0.25, bullet, {alpha=1})
        end
        self.timer:after(0.5, function()
            --1: two-by-two, 2:up-to-down, 3:down-to-up
            local type = math.random(1,3)
            local bullets = {}
            for i,v in ipairs(self.bullets) do
                if v.wave == wave then
                    table.insert(bullets, v)
                end
            end
            
            if type==1 then
                local first = math.random()<0.5 and {1, 3} or {2, 4}
                local last = Utils.filter({1, 2, 3, 4}, function(element)
                    for i,v in ipairs(first) do
                        if v == element then
                            return false
                        end
                    end
                    return true
                end)

                self.timer:tween(1, bullets[first[1]], {x=Game.battle.arena.left-30}, "in-out-quad", function()
                    self.timer:after(0.5, function()
                        self.timer:tween(1, bullets[first[1]], {x=-30}, "in-out-quad")
                    end)
                end)
                self.timer:tween(1, bullets[first[2]], {x=Game.battle.arena.left-30}, "in-out-quad", function()
                    self.timer:after(0.5, function()
                        self.timer:tween(1, bullets[first[2]], {x=-30}, "in-out-quad")
                    end)
                end)
                self.timer:after(0.25, function()
                    self.timer:tween(1, bullets[last[1]], {x=Game.battle.arena.left-30}, "in-out-quad", function()
                        self.timer:after(0.5, function()
                            self.timer:tween(1, bullets[last[1]], {x=-30}, "in-out-quad")
                        end)
                    end)
                    self.timer:tween(1, bullets[last[2]], {x=Game.battle.arena.left-30}, "in-out-quad", function()
                        self.timer:after(0.5, function()
                        self.timer:tween(1, bullets[last[2]], {x=-30}, "in-out-quad")
                        end)
                    end)
                end)
            elseif type == 2 then
                self.timer:tween(1, bullets[1], {x=Game.battle.arena.left-30}, "in-out-quad", function()
                    self.timer:after(0.5, function()
                        self.timer:tween(1, bullets[1], {x=-30}, "in-out-quad")
                    end)
                end)
                self.timer:after(0.25, function()
                    self.timer:tween(1, bullets[2], {x=Game.battle.arena.left-30}, "in-out-quad", function()
                        self.timer:after(0.5, function()
                            self.timer:tween(1, bullets[2], {x=-30}, "in-out-quad")
                        end)
                    end)
                end)
                self.timer:after(0.5, function()
                    self.timer:tween(1, bullets[3], {x=Game.battle.arena.left-30}, "in-out-quad", function()
                        self.timer:after(0.5, function()
                            self.timer:tween(1, bullets[3], {x=-30}, "in-out-quad")
                        end)
                    end)
                end)
                self.timer:after(0.75, function()
                    self.timer:tween(1, bullets[4], {x=Game.battle.arena.left-30}, "in-out-quad", function()
                        self.timer:after(0.5, function()
                            self.timer:tween(1, bullets[4], {x=-30}, "in-out-quad")
                        end)
                    end)
                end)
            elseif type == 3 then
                self.timer:tween(1, bullets[4], {x=Game.battle.arena.left-30}, "in-out-quad", function()
                    self.timer:after(0.5, function()
                        self.timer:tween(4, bullets[4], {x=-30}, "in-out-quad")
                    end)
                end)
                self.timer:after(0.25, function()
                    self.timer:tween(1, bullets[3], {x=Game.battle.arena.left-30}, "in-out-quad", function()
                        self.timer:after(0.5, function()
                            self.timer:tween(1, bullets[3], {x=-30}, "in-out-quad")
                        end)
                    end)
                end)
                self.timer:after(0.5, function()
                    self.timer:tween(1, bullets[2], {x=Game.battle.arena.left-30}, "in-out-quad", function()
                        self.timer:after(0.5, function()
                            self.timer:tween(1, bullets[2], {x=-30}, "in-out-quad")
                        end)
                    end)
                end)
                self.timer:after(0.75, function()
                    self.timer:tween(1, bullets[1], {x=Game.battle.arena.left-30}, "in-out-quad", function()
                        self.timer:after(0.5, function()
                            self.timer:tween(1, bullets[1], {x=-30}, "in-out-quad")
                        end)
                    end)
                end)
            end
        end)
    end)
end

function actuallyHim:update()
    -- Code here gets called every frame

    super:update(self)
end

return actuallyHim