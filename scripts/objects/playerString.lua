local String, super = Class(Object)

function String:init(x, y, sneo_body)
    super:init(self, x, y, 1, 400)
    self.layer = sneo_body.parent.parent.layer - 10
    --self.top_x = x - (top_x or x)
    self.color = COLORS.red
    self.inherit_color = true
    self.swing_speed = 0
    self.siner = 0
    self.line_rotation = -math.pi/2
    self.lineLength = 0
    self.lineSpeed = 10
    self.extend = true
    self.is_extending = true
    
    self.starting_points = {0, 0}
    local neo_x, neo_y = sneo_body:getRelativePos(sneo_body.x, sneo_body.y, self)
    print("init", neo_x, neo_y)
    self.ending_points = {neo_x, neo_y}
    self.draw_x, self.draw_y = 0, 0

    self.collider = Hitbox(self, 0, 0, 1, 1)
end

function String:update()
    super:update(self)

    local dx = self.ending_points[1] - self.starting_points[1]
    local dy = self.ending_points[2] - self.starting_points[2]
    local totalLength = math.sqrt(dx * dx + dy * dy)

    if self.extend then
	    if self.lineLength < totalLength then
	        self.lineLength = self.lineLength + self.lineSpeed * DTMULT
	        self.lineLength = math.min(self.lineLength, totalLength)
	    else
	    	self.is_extending = false
	    end
	else
		if self.lineLength > 0 then
	        self.lineLength = self.lineLength - self.lineSpeed * DTMULT
	        self.lineLength = math.max(self.lineLength, 0)
	    else
	    	self:remove()
	    end
	end

    self.draw_x = self.starting_points[1] + (dx / totalLength) * self.lineLength
    self.draw_y = self.starting_points[2] + (dy / totalLength) * self.lineLength

    self.collider.x = self.draw_x
    self.collider.y = self.draw_y
    for i,obs in ipairs(Game.stage:getObjects(Obstacle)) do
    	if self:collidesWith(obs) then
    		self.extend = false
    		self.is_extending = false
    	end
    end
end

function String:draw()
    super:draw(self)
    love.graphics.setColor(self:getDrawColor())
    love.graphics.setLineWidth(self.width)
    love.graphics.line(self.starting_points[1], self.starting_points[2], self.draw_x, self.draw_y)

    if DEBUG_RENDER and self.collider then
        self.collider:draw(1, 0, 0)
    end
end

return String