local Snowfall2, super = Class(Wave)

function Snowfall2:init()
    super:init(self)
    self.time=10
    self:setArenaSize(213, 142)

    self.prev_x = nil
end

function Snowfall2:onStart()
    -- Every 0.33 seconds...
    self.timer:every(0.5, function()
        local x, y = Utils.random(Game.battle.arena.left, Game.battle.arena.right), -20
        if self.prev_x then
            local ok
            while true do
                print(x, self.prev_x)
                ok = true
                for i=self.prev_x-5, self.prev_x+5 do
                    print(i)
                    if i==x then
                        ok = false
                    end
                end
                if ok then
                    break
                else
                    x = Utils.random(Game.battle.arena.left, Game.battle.arena.right)
                end
            end
        end
        self.prev_x = x

        local rect = Rectangle(x, SCREEN_HEIGHT/2, 1, SCREEN_HEIGHT+20)
        rect:setOrigin(0.5)
        rect:setLayer(BATTLE_LAYERS["bullets"])
        rect:setColor(1, 1, 1, 0.5)
        self:spawnObject(rect)

        self.timer:tween(0.25, rect, {scale_x=20}, nil, function()
            self.timer:tween(0.35, rect, {scale_x=0}, "in-cubic", function()
                self.timer:after(0.1, function()
                    self:spawnBullet("snowflakeBullet", x, y, math.rad(90), 20)
                end)
            end)
        end)
    end)
end

return Snowfall2