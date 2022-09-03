local actor, super = Class("susie")

function actor:init()
	super:init(self)

	self.animations["heal"]={"heal", 1/16, false}

	self.offsets["heal"]={-6, -14}
end

return actor