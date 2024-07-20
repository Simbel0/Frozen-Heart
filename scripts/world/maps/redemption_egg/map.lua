local man, super = Class(Map)

function man:onEnter()
	super:onEnter(self)
	for i,v in ipairs(Game.world.followers) do
		v.visible=false
	end
	if Game:getFlag("man_room", false) then
		--local tree = Game.world:getEvent(18)
		self.wobbly = Game.world:spawnObject(Registry.createEvent("wobblything", {
		properties = {
			x=1745,
			y=315
		}
		}), Game.world:parseLayer("objects"))
		self.wobbly:setPosition(1745, 315)
		--tree:remove()
	end
end

function man:onExit()
	super:onExit(self)
	for i,v in ipairs(Game.world.followers) do
		v.visible=true
	end
end

return man