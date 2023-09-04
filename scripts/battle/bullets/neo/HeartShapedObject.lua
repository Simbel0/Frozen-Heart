--Heartheartheartheartheartheart33333333
local HeartShapedObject, super = Class(Bullet)

function HeartShapedObject:init(x, y, speed_x, speed_y)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/neo/heart")

    self:setHitbox(13, 10, 26, 35)

    self.remove_offscreen = false
    self.destroy_on_hit = false

    self.physics.speed_x = -love.math.random(3, 8)
    self.physics.speed_y = -love.math.random(1, 10)
    self.physics.gravity = 0.5

    self.start_physics = {
        speed_x = self.physics.speed_x,
        speed_y = self.physics.speed_y,
        gravity = self.physics.gravity
    }

    self.shot_health = 20

    self.wires = {}
end

function HeartShapedObject:onWaveSpawn(wave)
    for i=0,2 do
        wave.timer:after(0.7+(0.5*i), function()
            self.wires[i+1] = wave:spawnBullet("neo/heart_wire", self.init_x, self.init_y, self.start_physics)
        end)
    end
end

function HeartShapedObject:update()
    -- For more complicated bullet behaviours, code here gets called every update
    
    if self.y + self.height >= Game.battle.arena.bottom and self.x > Game.battle.arena.left then
        self.physics.speed_y = -self.physics.speed_y + 0.6
        for i=1,2 do
            local bullet = self.wave:spawnBullet("smallbullet", self.x, self.y, math.rad(i==1 and 265 or 285), 10)
            bullet.physics.gravity = Utils.random(0.2, 0.6)
        end
        for i=1,2 do
            local bullet = self.wave:spawnBullet("smallbullet", self.x+self.width, self.y+self.height, math.rad(i==1 and 265 or 285), 10)
            bullet.physics.gravity = Utils.random(0.2, 0.6)
        end
        self.y = self.y - 10
    end

    if #self.wires==3 then
        if self:isOffScreen() and self.wires[1]:isOffScreen() and self.wires[2]:isOffScreen() and self.wires[3]:isOffScreen() then
            self:remove()
        end
    end

    super:update(self)
end

function HeartShapedObject:isOffScreen()
    return self.x < -100 or self.y < -100 or self.x > SCREEN_WIDTH + 100 or self.y > SCREEN_HEIGHT + 100
end

function HeartShapedObject:onYellowShot(shot, damage)
    self.shot_health = self.shot_health - damage
    if self.shot_health <= 0 then
        self.physics = {}
        self.collidable = false
        self.sprite:stop()
        self.graphics.grow = 0.1
        self:fadeTo(0, 0.1, function() self:destroy() end)
    end
    return "a", false
end

function HeartShapedObject:destroy()
    self.attacker:hurt(110)
    Game:giveTension(5)
    self:remove()
end

function HeartShapedObject:onRemove()
    for i,wire in ipairs(self.wires) do
        wire:remove()
    end
end

return HeartShapedObject