local fountain, super = Class(Event, "fountain")

function fountain:init(data)
	self.ignorePos=data.properties["ignorePos"] or true
	super:init(self, self.ignorePos and 320 or data.x, self.ignorePos and 200 or data.y)

	self.blackRects={}
	self.blackRects[1]=Rectangle(-320, -240, (SCREEN_WIDTH/4)+75, SCREEN_HEIGHT+40)
	self.blackRects[1]:setColor(0,0,0,1)
	self:addChild(self.blackRects[1])
	self.blackRects[2]=Rectangle(87, -240, (SCREEN_WIDTH/4)+75, SCREEN_HEIGHT+40)
	self.blackRects[2]:setColor(0,0,0,1)
	self:addChild(self.blackRects[2])
	self.blackRects[3]=Rectangle(-320, 70, SCREEN_WIDTH, 250)
	self.blackRects[3]:setColor(0,0,0,1)
	self:addChild(self.blackRects[3])

	self.ground = Rectangle(0, 200, 250, 250)
	self.ground:setOrigin(0.5, 0.5)
	self.groundAlpha=AlphaFX(1)
	self.ground:addFX(self.groundAlpha)
	self:addChild(self.ground)
	self.ground.inherit_color=true

	self.fountainEdges=Sprite("edges", 0, 0, nil, nil, "world/events/fountain")
	self.fountainEdges.inherit_color=true
	self.fountainEdges:setOrigin(0.5, 0.5)
	self.fountainEdges:setLayer(self.ground.layer-1)
	self.fountainEdges.wrap_texture_y = true
	self.fountainEdges:setScale(2)
	self.fountainEdges.physics.speed_y = -2
	self.fountainEdges.alpha=0.5
	self.fountainEdges.clones={}
	self:addChild(self.fountainEdges)
	for i=1,3 do
		self.fountainEdges.clones[i]=Sprite("edges", 0, 0, nil, nil, "world/events/fountain")
		self.fountainEdges.clones[i].inherit_color=true
		self.fountainEdges.clones[i]:setOrigin(0.5, 0.5)
		self.fountainEdges.clones[i]:setLayer((self.fountainEdges.layer-1)+i/10)
		self.fountainEdges.clones[i].wrap_texture_y = true
		self.fountainEdges.clones[i]:setScale(2)
		self.fountainEdges.clones[i].physics.speed_y = -2
		self.fountainEdges.clones[i].alpha=0.5
		self:addChild(self.fountainEdges.clones[i])
	end

	self.fountainBottom=Sprite("bottom", 0, -60, nil, nil, "world/events/fountain")
	self.fountainBottom:setLayer(self.ground.layer-0.5)
	self.fountainBottom.inherit_color=true
	self.fountainBottom:setOrigin(0.5, 0.5)
	self.fountainBottom:setScale(2)
	self.fountainBottom.clones={}
	self:addChild(self.fountainBottom)
	for i=1,2 do
		self.fountainBottom.clones[i]=Sprite("bottom", 0, 0, nil, nil, "world/events/fountain")
		self.fountainBottom.clones[i].inherit_color=true
		self.fountainBottom.clones[i]:setOrigin(0.5, 0.5)
		self.fountainBottom.clones[i]:setLayer((self.fountainBottom.layer-0.5)+i/10)
		self.fountainBottom.clones[i]:setScale(2)
		self.fountainBottom.clones[i].alpha= i==1 and 0.5 or 0.3
		self:addChild(self.fountainBottom.clones[i])
	end

	self.bg=Sprite("bg", 0, 0, nil, nil, "world/events/fountain")
	self.bg:setOrigin(0.5, 0.5)
	self.bg.inherit_color=true
	self.bg.wrap_texture_x=true
	self.bg.wrap_texture_y=true
	self.bg:setScale(2, 2)
	self.bg:setLayer(self.fountainEdges.clones[2].layer-0.5)
	self:addChild(self.bg)
	self.bg.physics.direction=math.rad(225)
	self.bg.physics.speed=1

	self.bg2=Sprite("bg", 0, 0, nil, nil, "world/events/fountain")
	self.bg2:setOrigin(0.5, 0.5)
	self.bg2.inherit_color=true
	self.bg2.wrap_texture_x=true
	self.bg2.wrap_texture_y=true
	self.bg2.alpha=0.3
	self.bg2:setScale(2, 2)
	self.bg2:setLayer(self.bg.layer-0.5)
	self:addChild(self.bg2)
	self.bg2.physics.direction=math.rad(45)
	self.bg2.physics.speed=1

	self.hue = 0
	self:setColor(1, 1, 1)

	--funky stuff
	self.siner=0
	self.bgsiner=0
	self.siner2=0
	self.bgsiner2=0
	self.slowdown=0
	self.eyebody = 1
	self.eyesense="up"

	print("fountain loaded at "..data.x..","..data.y)
end

function fountain:update()
	super:update(self)
    self.hue = (self.hue + DT/12) % 1

	self:setColor(Utils.hslToRgb(self.hue, 1, 0.25))

	-- The funky stuff
	if self.slowdown < 1 then
    	self.slowdown = self.slowdown + 0.01*DTMULT
    end
    self.siner = self.siner - (self.slowdown * 0.5)*DTMULT
    self.siner2 = self.siner2+1*DTMULT
	self.bgsiner2 = self.bgsiner2 + 0.02342*DTMULT
    self.bgsiner = self.bgsiner - (self.slowdown / 24)*DTMULT
    if self.eyebody>1 then
    	self.eyesense="down"
    elseif self.eyebody<0.3 then
    	self.eyesense="up"
    end
    if self.eyesense=="up" then
    	self.eyebody=self.eyebody+0.01*DTMULT
    elseif eyesense=="down" then
    	self.eyebody=self.eyebody-0.01*DTMULT
    end
    if self.bgsiner > 7 then
		self.bgsiner = self.bgsiner - 7*DTMULT
	end
	if self.bgsiner2 > 7 then
		self.bgsiner2 = self.bgsiner2 - 7*DTMULT
	end

	self.groundAlpha.alpha=(0.5 * self.eyebody)

	self.fountainEdges.x = 0 + (math.sin((self.siner2 / 16)) * 12)
	self.fountainEdges.clones[1].x = 0 + (math.sin((self.siner2 / 16)) * 12)
	self.fountainEdges.clones[2].x = 0 - (math.sin((self.siner2 / 16)) * 12)
	self.fountainEdges.clones[3].x = 0 - (math.sin((self.siner2 / 16)) * 12)

	self.fountainBottom.clones[1].y = (-68 + (math.sin((self.siner / 16)) * 8))
	self.fountainBottom.clones[2].y = (-64 + (math.sin((self.siner / 16)) * 4))
end

return fountain