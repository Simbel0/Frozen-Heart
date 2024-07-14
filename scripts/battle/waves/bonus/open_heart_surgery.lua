local Heart, super = Class(Wave)

function Heart:init()
    super:init(self)
    self.mode = Game.battle.encounter.sneo.wave_loop
    self.time = 10
    self:setArenaSize(360, 142)
    self:setArenaOffset(-80, 0)
end

function Heart:onStart()
    local sneo = Game.battle.encounter.sneo
    local body = sneo.sprite:getPart("body")

    sneo.sprite:setPartSprite("head", "npcs/spamton/head_death")
    sneo.sprite:tweenPartRotation("head", math.rad(40), 0.3, "out-cubic")
    sneo.sprite:setAllPartsShaking(true)
    for _,part in ipairs(sneo.sprite.parts) do
        sneo.sprite:setSwingSpeed(0)
    end
    sneo.sprite:tweenPartRotation("body", math.rad(10), 0.3, "out-cubic")
    sneo.sprite:getPart("arm_l").rotation = math.rad(10)
    sneo.sprite:getPart("arm_r").rotation = math.rad(-10)

    self.possibilities = {
        {8, 1},
        {6, 5},
        {3, 10},
        {8, 5}
    }
    self.timer:after(1, function()
        Assets.playSound("noise")
        sneo.sprite:setPartSprite("body", "npcs/spamton/body_broke")
        self.heart_timer = self.timer:everyInstant(3, function()
            local x, y = body:getScreenPos()
            self.heart = self:spawnBullet("neo/HeartShapedObject", x, y)
        end, math.huge)
    end)
end

function Heart:update()
    -- Code here gets called every frame

    super:update(self)
end

function Heart:onEnd()
    local sneo = Game.battle.encounter.sneo
    sneo.sprite:resetParts()
    sneo.sprite:resetPart("head", true)
    sneo.sprite:getPart("arm_l").rotation = math.rad(0)
    sneo.sprite:getPart("arm_r").rotation = math.rad(0)
    sneo.sprite:setPartSprite("body", "npcs/spamton/body")
end

return Heart