local lab, super = Class(Map)

function lab:onEnter()
	super:onEnter(self)
	Game.world.player.visible=false
	for i,v in ipairs(Game.world.followers) do
		v.visible=false
	end

	Game.world:startCutscene("ending."..Game:getFlag("noelle_battle_status", "no_trance"))
end

return lab