local man, super = Class(Map)

function man:onEnter()
	super:onEnter(self)
	for i,v in ipairs(Game.world.followers) do
		v.visible=false
	end
end

function man:onExit()
	super:onExit(self)
	for i,v in ipairs(Game.world.followers) do
		v.visible=true
	end
end

return man