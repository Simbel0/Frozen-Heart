local character, super = Class("noelle")

function character:init()
    super:init(self)

    self.stats["health"]=166

    self.health=166

    self:addSpell("snowgrave")

    self.max_stats = {}

    self.flags["boldness"] = 1
end

function character:getTitle()
    if Game:getFlag("plot", 0)==3 then
        return "LV1 Unfrozen Heart\nWent back on the\nright track."
    end
    return super:getTitle(self)
end

function character:drawPowerStat(index, x, y, menu)
    if index == 1 then
        local icon = Assets.getTexture("ui/menu/icon/snow")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Coldness", x, y)
        local coldness = 54
        love.graphics.print(coldness, x+130, y)
        return true
    elseif index == 2 then
        local icon = Assets.getTexture("ui/menu/icon/exclamation")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Boldness", x, y, 0, 0.8, 1)
        love.graphics.print(self:getFlag("boldness", 1), x+130, y)
        return true
    elseif index == 3 then
        local icon = Assets.getTexture("ui/menu/icon/fire")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Guts:", x, y)
        return true
    end
end

return character