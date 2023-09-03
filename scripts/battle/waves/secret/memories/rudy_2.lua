local Stay_Around, super = Class(Wave)

function Stay_Around:init()
    super:init(self)

    self.time = -1
    self.count = 0
end

function Stay_Around:onStart()
    local s_x, s_y = Game.battle.soul.x, Game.battle.soul.y
    local base_angle = love.math.random(360)
    for i = 1, 20 do
        local angle = math.rad(base_angle+360/20*i)
        local x = math.cos(angle)*2
        local y = math.sin(angle)*2
        self:spawnBullet("secret/memories/love_around", s_x + math.deg(x), s_y + math.deg(y), angle)
    end

    self.timer:every(1/2, function()
        if self.count >= 20 then
            self.finished = true
            return false
        end

        local r = love.math.random(1, #self.bullets)

        while self.bullets[r].go_go do
            r = love.math.random(1, #self.bullets)
        end
        self.bullets[r].go_go = true
        self.count = self.count + 1
        self.bullets[r].physics.speed = -10
    end)
end

function Stay_Around:update()
    -- Code here gets called every frame
    print(#self.bullets, self.count)

    super:update(self)
end

return Stay_Around