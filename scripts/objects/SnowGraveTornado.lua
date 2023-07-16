local SnowGraveTornado, super = Class(Object)

function SnowGraveTornado:init(x)
	super:init(self, x, 0)

	self.timer = 0
	self.snowspeed = 0
	self.stimer = 0
	self.init = true
	self.siner = 0
	self.since_last_snowflake = 0
	self.reset_once = true
end

function SnowGraveTornado:createSnowflake(x, y)
    local snowflake = SnowGraveSnowflake(x, y)
    snowflake.physics.gravity = -2
    snowflake.physics.speed_y = math.sin(self.timer / 2) * 1
    snowflake.siner = self.timer / 2
    self:addChild(snowflake)
    return snowflake
end

function SnowGraveTornado:update()
    super:update(self)
    self.timer = self.timer + DTMULT
    self.since_last_snowflake = self.since_last_snowflake + DTMULT
end

function SnowGraveTornado:draw()
    super:draw(self)

    if (self.timer >= 0) then
        self.snowspeed = self.snowspeed + (20 + (self.timer / 5)) * DTMULT
    end

    self.stimer = self.stimer + 1 * DTMULT

    if self.reset_once then
        self.reset_once = false
        self.since_last_snowflake = 1
    end

    if self.since_last_snowflake > 1 then
    	print("ello")
        self:createSnowflake(45, 560) --455
        self:createSnowflake(0, 600) --500
        self:createSnowflake(-45, 520) --545
        self.since_last_snowflake = self.since_last_snowflake - 1
    end

    if (self.stimer >= 8) then
        self.stimer = 0
    end
end

return SnowGraveTornado