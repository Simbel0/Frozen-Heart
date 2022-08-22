local lab, super = Class(Map)

function lab:onEnter()
	super:onEnter(self)
	for _,member in ipairs(Game.party) do
		member.actor.visible=false
	end

	Game.world:startCutscene("ending."..Game:getFlag("noelle_battle_status", "killkill"))
end

return lab