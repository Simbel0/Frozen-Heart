local mansion_top, super = Class(Map)

function mansion_top:onEnter()
	super:onEnter(self)

	if Game:getFlag("togetherDialogue", false) then
		Game.world:getEvent(2):setPosition(1710, 300)
		Game.world:getEvent(2):setFacing("down")
		Game.world:getEvent(1):setPosition(1930, 300)
		Game.world:getEvent(1):setFacing("down")
	end
end

return mansion_top