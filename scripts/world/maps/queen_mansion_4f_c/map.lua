local queen_mansion_4f_c, super = Class(Map)

function queen_mansion_4f_c:onEnter()
	super:onEnter(self)
	Game:setBorder("mansion")
end

return queen_mansion_4f_c