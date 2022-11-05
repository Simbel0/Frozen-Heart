local kindaTouhou, super = Class(Wave)

function kindaTouhou:init()
    super:init(self)
    self.time = 20

    self.x = 10
    self.dir = "right"
end

function kindaTouhou:onStart()
    self.timer:every(1/3, function()
        local angle = love.math.random(360)
        for i=1,20 do
            self:spawnBullet("lonelySnow", self.x, 0, math.rad(angle+360/20*i), 6)
        end
        self.x = self.x + (self.dir =="right" and 35 or -35)
        if self.dir == "right" and self.x>640 then
            self.dir = "left"
        elseif self.dir == "left" and self.x<10 then
            self.dir = "right"
        end
    end)
end

function kindaTouhou:update()
    -- Code here gets called every frame

    super:update(self)
end

return kindaTouhou