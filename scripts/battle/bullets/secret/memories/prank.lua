local Prank, super = Class(Bullet)

function Prank:init(x, y)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/memories/prank")
    self.sprite:play(1/2)

    self.start_wave = false
    self.dir = "down"

    self.base_x = x
    self.base_y = y

    self.speed = 2

    self.dont_swing = false

    self.held_mouse = false

    self.destroy_on_hit = false
end

function Prank:onWaveSpawn(wave)
    wave.timer:every(Utils.random(0.75, 1), function()
        local dirs = {"left", "right", "up", "down"}

        if self.base_x <= 230 then
            Utils.removeFromTable(dirs, "left")
            table.insert(dirs, "right")
            table.insert(dirs, "right")
        elseif self.base_x >= 410 then
            Utils.removeFromTable(dirs, "right")
            table.insert(dirs, "left")
            table.insert(dirs, "left")
        end
        if self.base_y >= 265 then
            Utils.removeFromTable(dirs, "down")
            table.insert(dirs, "up")
            table.insert(dirs, "up")
        elseif self.base_y <= 75 then
            Utils.removeFromTable(dirs, "up")
            table.insert(dirs, "down")
            table.insert(dirs, "down")
        end

        table.insert(dirs, Utils.facingFromAngle(Utils.angle(self, Game.battle.soul)))

        print(Utils.dump(dirs))

        self.dir = Utils.pick(dirs)
    end)
end

function Prank:update()
    -- For more complicated bullet behaviours, code here gets called every update

    if self.dir == "left" then
        self.base_x = self.base_x - self.speed*DTMULT
    elseif self.dir == "right" then
        self.base_x = self.base_x + self.speed*DTMULT
    elseif self.dir == "down" then
        self.base_y = self.base_y + self.speed*DTMULT
    elseif self.dir == "up" then
        self.base_y = self.base_y - self.speed*DTMULT
    end

    self.x = self.base_x + math.cos(Kristal.getTime()*5)*55
    self.y = self.base_y + math.sin((Kristal.getTime()/4)*5)*55

    self.rotation = math.rad(0+math.cos(Kristal.getTime()*3)*30)

    super:update(self)
end

function Prank:onDamage(soul)
    super:onDamage(self, soul)
    local b = self.wave:spawnBullet("secret/memories/prank", self.x, self.y)
    b.dir = Utils.pick({"left", "right", "up", "down"})
end

return Prank