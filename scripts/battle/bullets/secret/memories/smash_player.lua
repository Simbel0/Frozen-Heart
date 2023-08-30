local Player, super = Class(Bullet)

function Player:init(x, y, dir, speed)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/memories/heart")
    self:setScale(1)

    self.timer = 0

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
end

function Player:onWaveSpawn(wave)
    self.indication = wave:spawnSprite("bullets/memories/heart")
    self.indication:setColor(1, 0, 0)
    self.indication.alpha = 0
end

function Player:update()
    -- For more complicated bullet behaviours, code here gets called every update
    print(self.timer, self.angle, self.indication.x, self.indication.y, self.indication.alpha)

    self.timer = self.timer + DTMULT

    if self.timer < 10 then
        self.angle = Utils.angle(self, Game.battle.soul)
    elseif self.timer >= 10 and self.indication.alpha < 0.5 then
        local x = self.x + math.deg(math.cos(self.angle))*3
        local y = self.y + math.deg(math.sin(self.angle))*3
        self.indication:setPosition(x, y)
        self.indication.alpha = 0.5
        self.start_x = self.x
        self.start_y = self.y
    elseif self.timer >= 10 and self.x ~= self.indication.x then
        self.x = Utils.ease(self.start_x, self.indication.x, (self.timer-10)/40, "outCubic")
        self.y = Utils.ease(self.start_y, self.indication.y, (self.timer-10)/40, "outCubic")
    else
        self.timer = 0
        self.indication.alpha = 0
    end

    super:update(self)
end

return Player