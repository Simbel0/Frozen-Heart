local fountain_room, super = Class(Map)

function fountain_room:onEnter()
	super:onEnter(self)
end

return fountain_room