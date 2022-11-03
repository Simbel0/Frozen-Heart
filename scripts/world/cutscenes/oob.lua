return {
	intro = function(cutscene)
		kris = cutscene:getCharacter("kris")
		oc = cutscene:getCharacter("dummy")

		cutscene:wait(cutscene:walkTo(kris, oc.x, kris.y, 2))
		cutscene:look(kris, "up")

		Game.world.camera.keep_in_bounds = false

		cutscene:wait(cutscene:panTo(oc.x, oc.y-oc.sprite.height))
		cutscene:wait(0.5)

		cutscene:text("* And so you have arrived.")

		cutscene:text("* So uh, hello there, I guess?")
		cutscene:text("* It seems you have reached the end of your journey.")
		cutscene:text("* I am impressed. I didn't think anyone would reach this place.")
		cutscene:text("* Perhaps you have rather hacked your way in?")
		cutscene:text("* Well that's a you problem. I'm only a coded cutscene.")
		cutscene:text("* And possibly the creator of this mod, also.")
		cutscene:text("* I'm just here to tell you some nice words, "..Utils.titleCase(Game.save_name)..".")
		if Game.save_name == "PLAYER" then
			cutscene:text("* ...")
			cutscene:text("* That name doesn't sound right, does it?")
			cutscene:text("* Maybe it does.")
			cutscene:text("* But at least, it tells something about you.")
			cutscene:text("* But anyways..")
		end
		cutscene:text("* Thank you for playing my mod.")
		cutscene:text("* I hope you've enjoyed Frozen Heart.")
		cutscene:text("* It's almost a miracle that this game released so yeah..")
		cutscene:text("* ...")
		cutscene:text("* Well I have one last proposition to make to you.")
		cutscene:text("* You're here for fights, aren't you?")
		cutscene:text("* You wouldn't have download this mod if it was just a fancy visual novel, right?")
		cutscene:text("* Then let me propose you one last fight.")
		cutscene:text("* A thank you of some sort that I spend more time coding than I'd like to admit.")
		cutscene:text("* The difficulty curve however is raised to the unholy level known as Touhou.")
		cutscene:text("* Kinda. More like a bootleg Touhou.")
		cutscene:text("* So prepare yourself, save the game, take some items inside your storages..")
		cutscene:text("* And come back when you'll be ready.")
		cutscene:text("* You can also just... never come back if you don't want to. That's fine.")
		cutscene:text("* Anyway.")
		cutscene:text("* Are you up to this last challenge?")
		cutscene:choicer({"Let's do\nthis!", "Let me\nsome time"})
		if cutscene.choice==2 then
			cutscene:text("* No problemo.")
			cutscene:text("* Take your time, it's only optional after all.")
			cutscene:attachCamera()
		else
			cutscene:text("* I see.")
			cutscene:text("* Well then.")
			Game.world.camera.keep_in_bounds = true
			cutscene:wait(cutscene:fadeIn(1))
			Game.world.timer:tween(1, Game.world.map:getTileLayer("barriers"), {alpha=0})
			Game.world.timer:tween(1, Game.world.map:getTileLayer("barriers_new"), {alpha=1})
			cutscene:attachCamera()
			cutscene:text("* Let's see what we can do together.")
			Game:setFlag("plot", 999)
			cutscene:startEncounter("oc_battle", true, oc)
		end
	end
}