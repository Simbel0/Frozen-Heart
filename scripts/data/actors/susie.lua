local actor, super = Class("susie")

function actor:init()
	super:init(self)

	self.animations["heal"] = {"heal", 1/16, false}
	self.animations["ice"]  = {"ice", 0, false}

	self.offsets["heal"] = {-6, -14}
	self.offsets["ice"]  = {-30, -41}
end

return actor