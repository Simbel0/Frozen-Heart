return function(cutscene)
	if not Game:getFlag("man_room", false) and Game:getFlag("noelle_battle_status", "killspare")=="no_trance" then
		if love.math.random(0, 50)==27 then
			print("egg man")
			Game:setFlag("man_room", true)
			cutscene:mapTransition("redemption_egg", "entry")
		else
			print("no egg")
			cutscene:mapTransition("queen_mansion_4f_d", "entry_l")
		end
	else
		cutscene:mapTransition("queen_mansion_4f_d", "entry_l")
	end
end