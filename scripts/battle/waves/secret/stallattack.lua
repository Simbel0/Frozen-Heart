local StallAttack, super = Class(Wave)

function StallAttack:init()
    super:init(self)
    self.time=10
    self.i = 150
    self.dir = 1
    self:setArenaOffset(-100, 0)
end

function StallAttack:onStart()
    self.double = #Game.battle.waves==2 --Make double idio
    if self.double then
        self:setArenaPosition(SCREEN_WIDTH/2, self.arena_y)
        Game.battle.soul:setExactPosition(Game.battle.arena:getCenter())
    end
    self.timer:every(self.double and 2 or 0.7, function()
        print("yes_A")
        local x, y
        if not self.double then
            x = 250 + self.i
            y = SCREEN_HEIGHT

            self.i = self.i + 30
            if self.i > 300 then
                self.i = 0
            end
        else
            x = Utils.random(Game.battle.arena:getLeft(), Game.battle.arena:getRight())
            y = SCREEN_HEIGHT
        end

        Assets.playSound("snd_spearrise")
        self:spawnBullet("secret/stallactic", x, y, math.rad(270), 15)
    end)
end

function StallAttack:update()
    -- Code here gets called every frame

    if not self.double then
        Game.battle.arena.x = Game.battle.arena.x + (2*self.dir)*DTMULT
        print(Game.battle.arena.x)
        if self.dir==1 and Game.battle.arena.x>=500 then
            self.dir = -1
        elseif self.dir==-1 and Game.battle.arena.x<=100 then
            self.dir = 1
        end
    end

    super:update(self)
end

return StallAttack