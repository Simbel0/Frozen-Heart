local ANGEL, super = Class(Wave)

function ANGEL:init()
    super:init(self)

    self.time = -1
end

function ANGEL:onStart()
    local base_x = 205
    local gap = 40

    self:spawnBullet("secret/memories/characterBullet", "[", base_x, 50, 1)
    self:spawnBullet("secret/memories/characterBullet", "A", base_x + gap, 50, 3)
    self:spawnBullet("secret/memories/characterBullet", "N", base_x + gap*2, 50, 5)
    self:spawnBullet("secret/memories/characterBullet", "G", base_x + gap*3, 50, 7)
    self:spawnBullet("secret/memories/characterBullet", "E", base_x + gap*4, 50, 6)
    self:spawnBullet("secret/memories/characterBullet", "L", base_x + gap*5, 50, 4)
    self:spawnBullet("secret/memories/characterBullet", "[", base_x + gap*6, 50, 2, true)

    self.next = 1
    self.timer:after(2, function()
        self.og_length = #self.bullets
        self.timer:everyInstant(0.5, function()
            local b
            for i,bullet in ipairs(self.bullets) do
                if bullet.order == self.next then
                    b = bullet
                    break
                end
            end
            self.timer:cancel(b.shake_mouv)
            b.physics.direction = Utils.angle(b, Game.battle.soul)
            b.physics.speed = 10
            print(self.next, b.texture, #self.bullets)
            self.next = self.next + 1
            if self.next > self.og_length then
                self.timer:after(1, function()
                    self.finished = true
                end)
                return false
            end
        end)
    end)
end

function ANGEL:update()
    -- Code here gets called every frame

    super:update(self)
end

return ANGEL