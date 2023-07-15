---@class Triangle : Object
---@overload fun(...) : Triangle
local Triangle, super = Class(Object)

function Triangle:init(x, y, points)
    super.init(self, x, y)
    --points: x1, y1, x2, y2, x3, y3
    self.points = points
    self.color = {1, 1, 1}

    local high_point = (points[3] < points[5]) and points[5] or points[3]
    self.width = math.abs(high_point)
    high_point = (points[4] < points[6]) and points[6] or points[4]
    self.height = math.abs(high_point)
    
    self.line = false
    self.line_width = 1
end

function Triangle:draw()
    love.graphics.setLineWidth(self.line_width)
    love.graphics.polygon(self.line and "line" or "fill", self.points)

    love.graphics.setColor(1, 1, 1, 1)
    super.draw(self)
end

return Triangle