local her_room, super = Class(Map)

function her_room:onEnter()
	super:onEnter(self)
	Game:setBorder("mansion")
end

return her_room