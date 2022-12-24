local dog, super = Class(Map)

function dog:onEnter()
	super:onEnter(self)
	Game.world:startCutscene("dog")
end

return dog