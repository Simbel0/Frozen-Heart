local mail, super = Class(Wave)

function mail:init()
    super:init(self)
    self.time = 15
    self:setArenaSize(142*1.5, 142*1.5)
end

function mail:onStart()
    self.timer:everyInstant(1/12, function()
        -- I'm letting all my previous attempt at making this wave work here so coders who actually know math can mock me
        --[[local x = Utils.random(-60, SCREEN_WIDTH/2)
        if x > 0 and Utils.random()>0.6 then
            x = Utils.random(-60, -1)
        end
        local y
        if x < 0 then
            y = Utils.random(Game.battle.arena.top-30, Game.battle.arena.bottom+30)
        else
            local area = Utils.random()<0.5 and "up" or "down"
            if area == "up" then
                y = Utils.random(-20, 0)
            else
                y = Utils.random(SCREEN_HEIGHT, SCREEN_HEIGHT+20)
            end
        end]]

        -- (x-a)^{2}+(y-b)^{2}



        --[[local value = Utils.random(120, 240)
        print(value)
        local rad = math.rad(math.pow(value-530, 2)+math.pow(value-160, 2))
        local x, y = math.cos(rad), math.sin(rad)]]

        local angle = math.rad(Utils.random(120, 240))
        local x, y = 530 + 600 * math.cos(angle), 160 + 600 * math.sin(angle)
        local mail = self:spawnBullet("neo/mail", x, y, 0, 0)
        mail.init_x, mail.init_y = mail.x, mail.y
        mail.timer = 0
    end)
end

function mail:update()
    for i,mail in ipairs(self.bullets) do
        mail.timer = mail.timer + DTMULT

        if mail.timer < 200 then
            mail.x = Utils.ease(mail.init_x, 530, mail.timer/200, "out-cubic")
            mail.y = Utils.ease(mail.init_y, 160, mail.timer/200, "out-cubic")
        else
            mail:remove()
        end
    end
    super.update(self)
end

return mail