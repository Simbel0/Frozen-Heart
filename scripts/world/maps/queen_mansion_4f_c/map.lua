local map, super = Class(Map)

function map:onEnter()
	self.egg_hint = Game.world.timer:everyInstant(60, function()
		print("hint")
		local sprite = Sprite("world/events/blocktree/block", 2520, 220)
		Game.world:addChild(sprite)
		sprite:setLayer(Game.world:parseLayer("Calque de Tuiles 1"))
		sprite:setPhysics({
			direction = math.rad(175),
			speed = 3
		})
		sprite:setGraphics({
			fade = 0.03,
			fade_to = 0,
			fade_callback = function() sprite:remove() end
		})
	end)
end

function map:onExit()
	Game.world.timer:cancel(self.egg_hint)
end

return map