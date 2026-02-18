local actor, super = Class("noelle")

function actor:init()
	super:init(self)

	self.default = "walk_sad"

	self.flip="left"

	self.animations["cutscene_shock"]={"battle/intro", 1/16, false, next="walk_sad/right"}
	self.animations["transition_snowgrave"]={"battle/trancesition", 0.2, false, next="battle/idleTrance"}
	self.animations["battle/idleTrance"]={"battle/idleTrance", 0.2, true}

	self.animations["battle/idleConfict"]={"battle/idle_conflict", 0.2, true}
	self.animations["innerbattle"]={"party/noelle/dark_c/innerbattle", 0.2, true}
end

function actor:getDefault()
	if Game:getFlag("plot", 0)>=3 then
		return "walk_blush"
	end
	return super:getDefault(self)
end

return actor