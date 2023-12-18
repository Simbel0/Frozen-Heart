return function(cutscene)
	cutscene:fadeOut(0)
	love.window.setTitle("Dogtal")
	maracas = Utils.random()>=0.95
	print(maracas)
	local dog = Sprite(maracas and "kristal/dog_maracas" or "kristal/dog", SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
	dog:setOrigin(0.5, 0.5)
	dog:setScale(8)
	dog:setLayer(WORLD_LAYERS["top"])
	Game.world:addChild(dog)

	dog:play(maracas and 1/8 or 1)
	Game.world.music:play(maracas and "baci_perugina2" or "results")

	cutscene:wait(function()
		return false
	end)
end