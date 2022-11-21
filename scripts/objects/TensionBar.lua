local TensionBar_n, super = Class("TensionBar", true)

function TensionBar_n:init(x, y, dont_animate)
	super:init(self, x, y, dont_animate)

	self.orig_pos = {x, y}

	self.shorten = false
end

function TensionBar_n:setShortVersion(bool)
	if bool then
		self.x = 2
		self.y = 65
	else
		self.x = orig_pos[1]
		self.y = orig_pos[2]
	end
	self.shorten = bool
end

function TensionBar_n:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.tp_bar_outline, 0, 0)

    love.graphics.setColor(PALETTE["tension_back"])
    Draw.pushScissor()
    Draw.scissorPoints(0, 0, 25, 196 - (self:getPercentageFor250(self.current) * 196) + 1)
    love.graphics.draw(self.tp_bar_fill, 0, 0)
    Draw.popScissor()

    if (self.apparent < self.current) then
        love.graphics.setColor(PALETTE["tension_decrease"])
        Draw.pushScissor()
        Draw.scissorPoints(0, 196 - (self:getPercentageFor250(self.current) * 196) + 1, 25, 196)
        love.graphics.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()

        love.graphics.setColor(PALETTE["tension_fill"])
        Draw.pushScissor()
        Draw.scissorPoints(0, 196 - (self:getPercentageFor250(self.apparent) * 196) + 1 + (self:getPercentageFor(self.tension_preview) * 196), 25, 196)
        love.graphics.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()
    elseif (self.apparent > self.current) then
        love.graphics.setColor(1, 1, 1, 1)
        Draw.pushScissor()
        Draw.scissorPoints(0, 196 - (self:getPercentageFor250(self.apparent) * 196) + 1, 25, 196)
        love.graphics.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()

        love.graphics.setColor(PALETTE["tension_fill"])
        if (self.maxed) then
            love.graphics.setColor(PALETTE["tension_max"])
        end
        Draw.pushScissor()
        Draw.scissorPoints(0, 196 - (self:getPercentageFor250(self.current) * 196) + 1 + (self:getPercentageFor(self.tension_preview) * 196), 25, 196)
        love.graphics.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()
    elseif (self.apparent == self.current) then
        love.graphics.setColor(PALETTE["tension_fill"])
        if (self.maxed) then
            love.graphics.setColor(PALETTE["tension_max"])
        end
        Draw.pushScissor()
        Draw.scissorPoints(0, 196 - (self:getPercentageFor250(self.current) * 196) + 1 + (self:getPercentageFor(self.tension_preview) * 196), 25, 196)
        love.graphics.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()
    end

    if (self.tension_preview > 0) then
        local alpha = (math.abs((math.sin((self.tsiner / 8)) * 0.5)) + 0.2)
        local color_to_set = {1, 1, 1, alpha}

        local theight = 196 - (self:getPercentageFor250(self.current) * 196)
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


    if ((self.apparent > 20) and (self.apparent < 250)) then
        love.graphics.setColor(1, 1, 1, 1)
        Draw.pushScissor()
        Draw.scissorPoints(0, 196 - (self:getPercentageFor250(self.current) * 196) + 1, 25, 196 - (self:getPercentageFor250(self.current) * 196) + 3)
        love.graphics.draw(self.tp_bar_fill, 0, 0)
        Draw.popScissor()
    end

    love.graphics.setColor(1, 1, 1, 1)
    if not self.shorten then
    	love.graphics.draw(self.tp_text, -30, 30)
    else
    	love.graphics.draw(self.tp_text, 2.5, -40)
    end

    local tamt = math.floor(self:getPercentageFor250(self.apparent) * 100)
    self.maxed = false
    love.graphics.setFont(self.font)
    if not self.shorten then
	    if (tamt < 100) then
	        love.graphics.print(tostring(math.floor(self:getPercentageFor250(self.apparent) * 100)), -30, 70)
	        love.graphics.print("%", -25, 95)
	    end
	    if (tamt >= 100) then
	        self.maxed = true

	        love.graphics.setColor(PALETTE["tension_maxtext"])

	        love.graphics.print("M", -28, 70)
	        love.graphics.print("A", -24, 90)
	        love.graphics.print("X", -20, 110)
	    end
	else
		if (tamt < 100) then
			if (tamt >= 10) then
	        	love.graphics.print(tostring(math.floor(self:getPercentageFor250(self.apparent) * 100)):sub(1, 1), 5, 60)
	        	love.graphics.print(tostring(math.floor(self:getPercentageFor250(self.apparent) * 100)):sub(-1, -1), 5, 80)
	        else
                love.graphics.print("0", 5, 60)
	        	love.graphics.print(tostring(math.floor(self:getPercentageFor250(self.apparent) * 100)), 5, 80)
	        end
	        love.graphics.print("%", 5, 110)
	    end
	    if (tamt >= 100) then
	        self.maxed = true

	        love.graphics.setColor({1, 1, 1})

	        love.graphics.print("M", 4, 60)
	        love.graphics.print("A", 6, 80)
	        love.graphics.print("X", 8, 100)
	    end
	end
end

return TensionBar_n