local Spyware, super = Class(Bullet)

function Spyware:init(x, y)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/memories/spyware")
    self.sprite:stop()

    self.start_wave = false
    self.dir = "left"

    self.dont_swing = false

    self.held_mouse = false
end

function Spyware:onWaveSpawn(wave)
    wave.timer:after(1, function()
        self.sprite:play(0.5, false, function()
            self.start_wave = true
        end)
    end)
    wave.timer:every(1, function()
        if self.start_wave then
            local angle = love.math.random(360)
            for i=1,20 do
                self.wave:spawnBullet("secret/memories/dollar", self.x, self.y, math.rad(angle+360/20*i), 6)
            end
        end
    end)
end

function Spyware:update()
    -- For more complicated bullet behaviours, code here gets called every update
    local mouse_x, mouse_y = Input.getMousePosition()
    print(self.held_mouse)

    if (mouse_x >= self.x+34 and mouse_x <= self.x+34+14) and (mouse_y <= self.y-21 and mouse_y >= self.y-35) then
        if love.mouse.isDown(1) and not self.held_mouse then
            -- Attempt at preventing players from crashing their game so close to the end
            if #self.wave.popups <= 30 then
                for i=1,#self.wave.popups do
                    local x, y
                    repeat
                        x = Utils.random(30, SCREEN_WIDTH-30)
                    until (x<Game.battle.arena.left or x>Game.battle.arena.right)
                    repeat
                        y = Utils.random(30, SCREEN_HEIGHT-30)
                    until (y<Game.battle.arena.top or y>Game.battle.arena.bottom)

                    local b = self.wave:spawnBullet("secret/memories/spyware", x, y)
                    b.dont_swing = true
                    table.insert(self.wave.popups, b)
                end
            end
        end
    end

    if self.start_wave and not self.dont_swing then
        if self.dir == "left" then
            self.x = self.x - 3*DTMULT
            if self.x <= 210 then
                self.dir = "right"
            end
        else
            self.x = self.x + 3*DTMULT
            if self.x >= 410 then
                self.dir = "left"
            end
        end
    end

    if love.mouse.isDown(1) then
        self.held_mouse = true
    else
        self.held_mouse = false
    end

    super:update(self)
end

return Spyware