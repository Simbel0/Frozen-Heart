local NoelleTensionBar, super = Class(Object)

function NoelleTensionBar:init(x, y, dont_animate)
    if Game.world and (not x) then
        local x2 = Game.world.camera:getRect()
        x = x2 - 25
    end

    super:init(self, x or SCREEN_WIDTH+30, y or 40)

    self.layer = BATTLE_LAYERS["ui"] - 1

    self.tp_bar_fill = Assets.getTexture("ui/battle/tp_bar_fill")
    self.tp_bar_outline = Assets.getTexture("ui/battle/tp_bar_outline")

    self.width = self.tp_bar_outline:getWidth()
    self.height = self.tp_bar_outline:getHeight()

    self.nTension=0
    self.nMaxtension=100

    self.nApparent = 0
    self.nCurrent = 0

    self.change = 0
    self.changetimer = 15
    self.font = Assets.getFont("main")
    self.tp_text = Assets.getTexture("ui/battle/tp_text")

    self.parallax_y = 0

    -- still dont understand nil logic
    if dont_animate then
        self.animating_in = false
    else
        self.animating_in = true
    end

    self.animation_timer = 0

    self.tsiner = 0

    self.tension_preview = 0
    self.shown = false
end

function NoelleTensionBar:show()
    if not self.shown then
        self:resetPhysics()
        self.x = self.init_x
        self.shown = true

        self.physics.speed_x = -13
        self.physics.friction = 1.2
    end
end

function NoelleTensionBar:getDebugInfo()
    local info = super:getDebugInfo(self)
    table.insert(info, "Tension: "  .. Utils.round(self:getPercentageFor(self.nTension) * 100) .. "%")
    table.insert(info, "Apparent: " .. Utils.round(self.nApparent / 2.5))
    table.insert(info, "Current: "  .. Utils.round(self.nCurrent / 2.5))
    return info
end

function NoelleTensionBar:setTension(amount, dont_clamp)
    self.nTension = dont_clamp and amount or Utils.clamp(amount, 0, self.nMaxtension)
end

function NoelleTensionBar:giveTension(amount, dont_clamp)
    self.nTension = self.nTension+(dont_clamp and amount or Utils.clamp(amount, 0, self.nMaxtension))
end

function NoelleTensionBar:removeTension(amount)
    self.nTension = self.nTension-amount
    if self.nTension<0 then
        self.nTension=0
    end
end

function NoelleTensionBar:getTension()
    return self.nTension or 0
end

function NoelleTensionBar:getTension250()
    return self:getPercentageFor(self:getTension()) * 250
end

function NoelleTensionBar:setTensionPreview(amount)
    self.tension_preview = amount
end

function NoelleTensionBar:getPercentageFor(variable)
    return variable / self.nMaxtension
end

function NoelleTensionBar:getPercentageFor250(variable)
    return variable / 250
end

function NoelleTensionBar:update()
    if (math.abs((self.nApparent - self:getTension250())) < 20) then
        self.nApparent = self:getTension250()
    elseif (self.nApparent < self:getTension250()) then
        self.nApparent = self.nApparent + (20 * DTMULT)
    elseif (self.nApparent > self:getTension250()) then
        self.nApparent = self.nApparent - (20 * DTMULT)
    end
    if (self.nApparent ~= self.nCurrent) then
        self.changetimer = self.changetimer + (1 * DTMULT)
        if (self.changetimer > 15) then
            if ((self.nApparent - self.nCurrent) > 0) then
                self.nCurrent = self.nCurrent + (2 * DTMULT)
            end
            if ((self.nApparent - self.nCurrent) > 10) then
                self.nCurrent = self.nCurrent + (2 * DTMULT)
            end
            if ((self.nApparent - self.nCurrent) > 25) then
                self.nCurrent = self.nCurrent + (3 * DTMULT)
            end
            if ((self.nApparent - self.nCurrent) > 50) then
                self.nCurrent = self.nCurrent + (4 * DTMULT)
            end
            if ((self.nApparent - self.nCurrent) > 100) then
                self.nCurrent = self.nCurrent + (5 * DTMULT)
            end
            if ((self.nApparent - self.nCurrent) < 0) then
                self.nCurrent = self.nCurrent - (2 * DTMULT)
            end
            if ((self.nApparent - self.nCurrent) < -10) then
                self.nCurrent = self.nCurrent - (2 * DTMULT)
            end
            if ((self.nApparent - self.nCurrent) < -25) then
                self.nCurrent = self.nCurrent - (3 * DTMULT)
            end
            if ((self.nApparent - self.nCurrent) < -50) then
                self.nCurrent = self.nCurrent - (4 * DTMULT)
            end
            if ((self.nApparent - self.nCurrent) < -100) then
                self.nCurrent = self.nCurrent - (5 * DTMULT)
            end
            if (math.abs((self.nApparent - self.nCurrent)) < 3) then
                self.nCurrent = self.nApparent
            end
        end
    end

    if (self.tension_preview > 0) then
        self.tsiner = self.tsiner + DTMULT
    end

    super:update(self)
end

function NoelleTensionBar:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.tp_bar_outline, 0, 0)

    love.graphics.setColor({ 0, 0, 114/255 })
    Draw.pushScissor()
    Draw.scissorPoints(0, 0, 25, 196 - (self:getPercentageFor250(self.nCurrent) * 196) + 1)
    love.graphics.draw(self.tp_bar_fill, 0, 0)
    Draw.popScissor()

    if (self.nApparent < self.nCurrent) then
        love.graphics.setColor(PALETTE["tension_decrease"])
        Draw.pushScissor()
        Draw.scissorPoints(0, 196 - (self:getPercentageFor250(self.nCurrent) * 196) + 1, 25, 196)
        love.graphics.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()

        love.graphics.setColor(PALETTE["tension_fill"])
        Draw.pushScissor()
        Draw.scissorPoints(0, 196 - (self:getPercentageFor250(self.nApparent) * 196) + 1 + (self:getPercentageFor(self.tension_preview) * 196), 25, 196)
        love.graphics.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()
    elseif (self.nApparent > self.nCurrent) then
        love.graphics.setColor(1, 1, 1, 1)
        Draw.pushScissor()
        Draw.scissorPoints(0, 196 - (self:getPercentageFor250(self.nApparent) * 196) + 1, 25, 196)
        love.graphics.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()

        love.graphics.setColor({ 100/255, 100/255, 255/255 })
        if (self.maxed) then
            love.graphics.setColor({ 200/255, 200/255, 255/255 })
        end
        Draw.pushScissor()
        Draw.scissorPoints(0, 196 - (self:getPercentageFor250(self.nCurrent) * 196) + 1 + (self:getPercentageFor(self.tension_preview) * 196), 25, 196)
        love.graphics.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()
    elseif (self.nApparent == self.nCurrent) then
        love.graphics.setColor({ 100/255, 100/255, 255/255 })
        if (self.maxed) then
            love.graphics.setColor({ 200/255, 200/255, 255/255 })
        end
        Draw.pushScissor()
        Draw.scissorPoints(0, 196 - (self:getPercentageFor250(self.nCurrent) * 196) + 1 + (self:getPercentageFor(self.tension_preview) * 196), 25, 196)
        love.graphics.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()
    end

    if (self.tension_preview > 0) then
        local alpha = (math.abs((math.sin((self.tsiner / 8)) * 0.5)) + 0.2)
        local color_to_set = {1, 1, 1, alpha}

        local theight = 196 - (self:getPercentageFor250(self.nCurrent) * 196)
        local theight2 = theight + (self:getPercentageFor(self.tension_preview) * 196)
        -- Note: causes a visual bug.
        if (theight2 > ((0 + 196) - 1)) then
            theight2 = ((0 + 196) - 1)
            color_to_set = {COLORS.dkgray[1], COLORS.dkgray[2], COLORS.dkgray[3], 0.7}
        end

        Draw.pushScissor()
        Draw.scissorPoints(0, theight2 + 1, 25, theight + 1)

        -- No idea how Deltarune draws this, cause this code was added in Kristal:
        local r,g,b,_ = love.graphics.getColor()
        love.graphics.setColor(r, g, b, 0.7)
        love.graphics.draw(self.tp_bar_fill, 0, 0)
        -- And back to the translated code:
        love.graphics.setColor(color_to_set)
        love.graphics.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()

        love.graphics.setColor(1, 1, 1, 1)
    end


    if ((self.nApparent > 20) and (self.nApparent < 250)) then
        love.graphics.setColor(1, 1, 1, 1)
        Draw.pushScissor()
        Draw.scissorPoints(0, 196 - (self:getPercentageFor250(self.nCurrent) * 196) + 1, 25, 196 - (self:getPercentageFor250(self.nCurrent) * 196) + 3)
        love.graphics.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.tp_text, -30, 30)

    local tamt = math.floor(self:getPercentageFor250(self.nApparent) * 100)
    self.maxed = false
    love.graphics.setFont(self.font)
    if (tamt < 100) then
        love.graphics.print(tostring(math.floor(self:getPercentageFor250(self.nApparent) * 100)), -30, 70)
        love.graphics.print("%", -25, 95)
    end
    if (tamt >= 100) then
        self.maxed = true

        love.graphics.setColor({109/255, 153/255, 255/255})

        love.graphics.print("M", -28, 70)
        love.graphics.print("A", -24, 90)
        love.graphics.print("X", -20, 110)
    end

    super:draw(self)
end

return NoelleTensionBar