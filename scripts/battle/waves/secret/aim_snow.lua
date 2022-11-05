local IceShocks, super = Class(Wave)

function IceShocks:init()
    super:init(self)
    self.time=10
end

function IceShocks:onStart()
    self.timer:everyInstant(999, function()
        self.timer:script(function(wait)
            local lines = {}
            wait(1/30)
            local x, y = Game.battle.soul.x, Game.battle.soul.y
            local angle = math.random(380)
            lines[1]=Rectangle(x, y, 2, 999)
            lines[1]:setColor(1, 0, 0, 0.5)
            lines[1]:setLayer(BATTLE_LAYERS["below_bullets"])
            lines[1]:setOrigin(0.5, 0.5)
            lines[1].rotation = math.rad(angle)
            Game.battle:addChild(lines[1])
            wait(0.1)
            lines[2]=Rectangle(x, y, 2, 999)
            lines[2]:setColor(1, 0, 0, 0.5)
            lines[2]:setLayer(BATTLE_LAYERS["below_bullets"])
            lines[2]:setOrigin(0.5, 0.5)
            lines[2].rotation = math.rad(angle+15)
            Game.battle:addChild(lines[2])
            wait(0.1)
            lines[3]=Rectangle(x, y, 2, 999)
            lines[3]:setColor(1, 0, 0, 0.5)
            lines[3]:setLayer(BATTLE_LAYERS["below_bullets"])
            lines[3]:setOrigin(0.5, 0.5)
            lines[3].rotation = math.rad(angle-15)
            Game.battle:addChild(lines[3])
            wait(0.35)
            self.timer:everyInstant(1/30, function()
                for i=1,3 do
                    self:spawnBullet("lonelySnow", x+(300)*math.cos(lines[i].rotation+(math.pi)), y+(300)*math.sin(lines[i].rotation+(math.pi)), lines[i].rotation, 20)
                end
            end, 60)
            wait((1/30)*60)
            for i,v in ipairs(lines) do
                v:remove()
            end
        end)
    end)
end

function IceShocks:update()
    -- Code here gets called every frame

    super:update(self)
end

return IceShocks