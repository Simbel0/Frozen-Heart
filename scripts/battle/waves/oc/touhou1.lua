local TH1, super = Class(Wave)

function TH1:init()
    super:init(self)
    self.time = 20
end

function TH1:onStart()
    local oc = self.encounter.oc
    local sphere = oc.sphere
    self.angle = 0
    oc.rotate_sphere = false
    self.timer:tween(1, sphere, {x=Game.battle.arena.left+Game.battle.arena.right/2, y=Game.battle.arena.top-50}, "out-cubic", function() self.start_fire=true end)
    -- Every 0.33 seconds...
    self.timer:every(1/65, function()
        -- Our X position is offscreen, to the right
        if self.start_fire then
            self:spawnBullet("smallbullet", sphere.x, sphere.y, self.angle, 6)
            self.angle = self.angle + 2
        end
    end)
    self.timer:every(1, function()
        for i=-2,2 do
            self:spawnBullet("smallbullet", oc.x, oc.y-oc.sprite.height/2, math.rad(180+(7*i)), 6)
        end
    end)
end

function TH1:update()
    -- Code here gets called every frame

    super:update(self)
end

return TH1