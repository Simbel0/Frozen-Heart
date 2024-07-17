local fountain, super = Class(Map)

function fountain:onEnter()
	super:onEnter(self)
    Game:setBorder("simple")
	if Game:getFlag("plot", 0)==11 then
        print("Start the quick intro")
        if Game.battle then
        	Game.battle:remove()
        end
        if Game.world.cutscene then
        	Game.world.cutscene:endCutscene()
        end
        Game.world:startCutscene("secret.quickstart")
    end
end

return fountain