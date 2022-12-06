local StallAttack, super = Class(Wave)

function StallAttack:init()
    super:init(self)
    self.time=10
    self.i = 150
    self.dir = 1
    self:setArenaOffset(-100, 0)
end

function StallAttack:onStart()
    -- Every 0.33 seconds...
    self.timer:every(0.7, function()
        print("yes_A")
        local x = 250 + self.i
        local y = SCREEN_HEIGHT

        self.i = self.i + 30
        if self.i > 300 then
            self.i = 0
        end

        self:spawnBullet("secret/stallactic", x, y, math.rad(270), 15)
    end)
end

function StallAttack:update()
    -- Code here gets called every frame

    Game.battle.arena.x = Game.battle.arena.x + (2*self.dir)*DTMULT
    print(Game.battle.arena.x)
    if self.dir==1 and Game.battle.arena.x>=500 then
        self.dir = -1
    elseif self.dir==-1 and Game.battle.arena.x<=100 then
        self.dir = 1
    end

    super:update(self)
end

return StallAttack