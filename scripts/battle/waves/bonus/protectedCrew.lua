local protectedCrew, super = Class(Wave)

function protectedCrew:init()
    super:init(self)
    self.mode = Game.battle.encounter.sneo.wave_loop
    self.time=-1
    self:setArenaOffset(-150, 0)
end

function protectedCrew:onStart()
    self.formations = {
        {
            {430, 130},
            {430, 240},
            {550, 130},
            {550, 240},
            {485, 185}
        },
        {
            {430, 240},
            {430, 190},
            {550, 160},
            {550, 125}
        },
        {
            {570, 245},
            {550, 205},
            {530, 170},
            {510, 130}
        }
    }
    local formation = love.math.random(1, 3)
    if formation==1 then
        self.crews={
            self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 130, nil, 1, {430, 130}, true, true),
            self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 240, nil, 1, {430, 240}, true, true),
            self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 130, nil, 1, {550, 130}, true, true),
            self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 240, nil, 1, {550, 240}, true, true),
            self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 185, nil, 1, {485, 185}, true, true)
        }
    elseif formation == 2 then
        self.crews={
            self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 240, nil, 1, {430, 240}, true, true),
            self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 190, nil, 1, {430, 190}, true, true),
            self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 160, nil, 1, {550, 160}, true, true),
            self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 125, nil, 1, {550, 125}, true, true),
        }
    else
        self.crews={
            self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 245, nil, 1, {570, 245}, true, true),
            self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 205, nil, 1, {550, 205}, true, true),
            self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 170, nil, 1, {530, 170}, true, true),
            self:spawnBullet("neo/crewBullet", SCREEN_WIDTH+50, 130, nil, 1, {510, 130}, true, true),
        }
    end

    self.timer:after(self.mode==1 and 5 or 7.5, function()
        local tab = {}
        for i = 1, #self.crews do
            table.insert(tab, i)
        end
        order = Utils.shuffle(tab)
        for i,v in ipairs(self.crews) do
            v:selfDestructMode(order[i])
        end
    end)
end

function protectedCrew:update()
    -- Code here gets called every frame
    local j=0
    local changeForm = 0

    for i,v in ipairs(self.crews) do
        if not v.collidable then
            j=j+1
        end
        if v.shooted then
            v.shoot = false
            changeForm = changeForm + 1
        end
        if not v.shooted and v.alpha==0 then
            changeForm = changeForm + 1
        end
    end

    if j==#self.crews and not self.willstop then
        self.willstop = true
        Game.battle.timer:after(2.5, function()
            self.finished = true
        end)
    end

    if changeForm==#self.crews then
        print("BS GOO!")
        self.timer:after(1/6, function()
            local formation = love.math.random(1, 3)
            for i,v in ipairs(self.crews) do
                print(v.x, self.formations[formation][1], v.y, self.formations[formation][2])
                if #self.formations[formation]==4 and i==5 then
                    v:fadeTo(0, 0.75)
                else
                    if i==5 and v.alpha == 0 then
                        v:fadeTo(1, 0.7)
                    end
                    self.timer:tween(0.75, v, {x=self.formations[formation][i][1], y=self.formations[formation][i][2]}, "out-quad", function()
                        if v.alpha == 1 then
                            v.shoot = true
                            v.shooted = false
                        end
                    end)
                end
            end
        end)
    end

    super:update(self)
end

return protectedCrew