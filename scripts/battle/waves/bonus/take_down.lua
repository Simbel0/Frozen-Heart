local Take_Down, super = Class(Wave)

function Take_Down:init()
    super:init(self)
    self.time=-1
    self:setArenaOffset(0, -100)
    self:setArenaSize(16, 16)
end

function Take_Down:onStart()
    self.timer:script(function(wait)
        local sneo = self.encounter.sneo
        local arm = sneo.sprite:getPart("arm_l")
        sneo.sprite:setPartSprite("arm_l", "npcs/spamton/arm_cannon")
        sneo.sprite:setPartSwingSpeed("arm_l", 0)
        sneo.sprite:setHeadFrame(2)

        local susie = Game.battle.party[2]
        local noelle = Game.battle.party[3]
        sneo.sprite:tweenPartRotation("arm_l", Utils.angle(sneo.x, sneo.y, susie.x, susie.y), 0.3, "out-cubic")
        wait(0.5)
        sneo.sprite:setPartSprite("arm_l", "npcs/spamton/arm_cannon_egg")
        wait(0.5)
        sneo.sprite:tweenPartRotation("arm_l", Utils.angle(sneo.x, sneo.y, susie.x, susie.y)+math.rad(10), 0.3, "out-cubic")
        sneo.sprite:setPartSprite("arm_l", "npcs/spamton/arm_cannon")
        local pos_x, pos_y = arm:getScreenPos()
        local pipis = Sprite("bullets/neo/pipis_1", pos_x-10, pos_y+10)
        pipis:setScale(2)
        pipis:setRotationOrigin(0.5, 0.5)
        pipis.graphics.spin = 4
        Game.battle.timer:tween(0.25, pipis, {x=Game.battle.party[2].x, y=Game.battle.party[2].y-10}, "linear", function()
            pipis:explode()
            Game.battle.party[2]:hurt(999)
            Game.battle.party[2].chara.health = -162
        end)
        Game.battle:addChild(pipis)

        wait(1.5)

        sneo.sprite:tweenPartRotation("arm_l", Utils.angle(sneo.x, sneo.y, noelle.x, noelle.y), 0.3, "out-cubic")
        wait(0.5)
        sneo.sprite:setPartSprite("arm_l", "npcs/spamton/arm_cannon_egg")
        wait(0.5)
        sneo.sprite:tweenPartRotation("arm_l", Utils.angle(sneo.x, sneo.y, noelle.x, noelle.y)+math.rad(10), 0.3, "out-cubic")
        sneo.sprite:setPartSprite("arm_l", "npcs/spamton/arm_cannon")
        local pipis = Sprite("bullets/neo/pipis_1", pos_x-10, pos_y+10)
        pipis:setScale(2)
        pipis:setRotationOrigin(0.5, 0.5)
        pipis.graphics.spin = 4
        Game.battle.timer:tween(0.25, pipis, {x=Game.battle.party[3].x, y=Game.battle.party[3].y-10}, "linear", function()
            pipis:explode()
            Game.battle.party[3]:hurt(999)
            Game.battle.party[3].chara.health = -159
        end)
        Game.battle:addChild(pipis)

        wait(1.5)
        self.finished = true
    end)
end

function Take_Down:update()
    -- Code here gets called every frame

    super:update(self)
end

function Take_Down:onEnd()
    self.encounter.sneo.sprite:setHeadAnimating(true)
    self.encounter.sneo.sprite:resetPart("arm_l", true)
end

return Take_Down