local spell, super = Class(Spell, "tension_absorb")

function spell:init()
    super:init(self)

    -- Display name
    self.name = "Tension Abs."
    -- Name displayed when cast (optional)
    self.cast_name = "Tension Absorb"

    -- Battle description
    self.effect = "Calm the\nTENSION"
    -- Menu description
    self.description = "Absorb the TP of one enemy to prevent it to cast spells."

    -- TP cost
    self.cost = 30

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    self.tension =  0

    -- Tags that apply to this spell
    self.tags = {"tension"}
end

function spell:getCastMessage(user, target)
    local message = super:getCastMessage(self, user, target)
    if Game.battle.noelle_tension_bar:getTension() == 0 then
        return message .. "\n* But there is no tension to absorb!"
    else
        self.tension = Utils.round(Utils.random(15, 100))
        while self.tension > Game.battle.noelle_tension_bar:getTension() do
            self.tension = self.tension - 1
        end
        return message .. "\n* Absorbed [color:FFA040]" .. self.tension .. "%[color:reset] of TP!"
    end
end

function spell:onCast(user, target)
    if Game.battle.noelle_tension_bar:getTension() == 0 then
        Game.battle:finishActionBy(user)
        return false
    end

    local function createEllipse(x, y)
        local ellipse = Ellipse(x, y, 0, 0)
        ellipse.color={ 100/255, 100/255, 255/255 }
        ellipse.layer = BATTLE_LAYERS["above_battlers"]
        Game.battle:addChild(ellipse)
        return ellipse
    end

    local tension = self.tension
    

    local ellipses = {}

    local x, y = target:getRelativePos(target.width/2, target.height/2, Game.battle)

    for i=1, tension, 5 do
        local ellipse = createEllipse(x, y)
        table.insert(ellipses, ellipse)
    end

    Game.battle.timer:script(function(wait)
        wait(1/30)
        Assets.playSound("ghostappear")
        local mask = ColorMaskFX({100/255, 100/255, 255/255}, 0)
        target:addFX(mask)

        Game.battle.noelle_tension_bar:giveTension(-tension, true)
        Game.battle.timer:tween(0.25, mask, {amount = 1}, "linear", function()
            Game.battle.timer:tween(0.25, mask, {amount = 0}, "linear", function()
                target:removeFX(mask)
            end)
        end)
        for _, ellipse in ipairs(ellipses) do
            Game.battle.timer:tween(1/30, ellipse, {width=20, height=20})
            ellipse.physics.direction = math.rad(Utils.random(0, 360))
            ellipse.physics.speed = Utils.random(2, 5)
            ellipse.physics.friction = Utils.random(0.1, 0.15)
        end
        wait(0.65)

        local u_x, u_y = user:getRelativePos(user.width/2, user.height/2, Game.battle)

        for _, ellipse in ipairs(ellipses) do
            ellipse.physics.direction = Utils.angle(x, y, ellipse.x, ellipse.y)
            ellipse.physics.friction = 0
            ellipse.physics.speed = 0
        end

        local count=0
        for _, ellipse in ipairs(ellipses) do
            Game.battle.timer:tween(0.25, ellipse, {x=u_x, y=u_y, color={255/255, 160/255, 64/255}}, "linear", function()
                count=count+1
                Game.battle:removeChild(ellipse)
            end)
        end
        while count<#ellipses do
            wait(0.1)
        end

        Assets.playSound("cardrive")
        Game:giveTension(tension)
        mask:setColor(255/255, 160/255, 64/255)
        user:addFX(mask)
        Game.battle.timer:tween(0.25, mask, {amount = 1}, "linear", function()
            Game.battle.timer:tween(0.25, mask, {amount = 0}, "linear", function()
                user:removeFX(mask)
            end)
        end)
        Game.battle:finishActionBy(user)
    end)

    return false
end

return spell