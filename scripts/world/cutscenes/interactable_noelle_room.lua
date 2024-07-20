return function(cutscene, event)
	local id = event.data.properties["id"]

	local interacted = Game:getFlag("interacted-"..id, false)
	Game:setFlag("interacted-"..id, true)

	local noelle=cutscene:getCharacter("noelle")
	
	if id==1 then
		if not interacted then
			cutscene:text("* (There are all sorts of clothes inside.)")
			if noelle then
				cutscene:text("* Su-[wait:0.5]Susie?[wait:1] Why are you looking at my clothes?", "blush_question", "noelle")
				cutscene:text("* Uhm...", "nervous", "susie")
				cutscene:text("* Just...[wait:1] Curiosity,[wait:0.5] I guess?", "nervous_side", "susie")
				cutscene:text("* O-[wait:0.5]Oh.", "confused_surprise", "noelle")
				cutscene:text("* I never saw you wear anything like this,[wait:0.5] though.", "neutral_side", "susie")
				cutscene:text("* Ahah,[wait:0.5] that's true.[wait:1] Does that surprise you that much?", "blush_smile_closed", "noelle")
				cutscene:text("* Kinda.[wait:1] But we only see each other at school so that might be why.", "smirk", "susie")
				cutscene:text("* Ye-Yeah,[wait:0.5] you're right...", "blush_smile", "noelle")
			else
				cutscene:text("* (..[wait:1]. huh[wait:1], never seen Noelle wear anything like this...?)", "surprise", "susie")
				cutscene:text("* (Wait![wait:1] Why did you make me check that??[wait:1] Let's go see Kris!!)", "shy", "susie")
			end
		else
			if noelle then
				cutscene:text("* Su-[wait:0.5]Susie...?[wait:1] Why did you open the closet again?", "confused_surprise", "noelle")
				cutscene:text("* ...Good question.", "nervous", "susie")
			end
			cutscene:text("* (Will you stop inspecting everything,[wait:0.5] stupid voice?!)", "teeth_b", "susie")
		end
	elseif id==2 then
		if not interacted then
			cutscene:text("* (There are catalogues of search results.)")
			cutscene:text("* (Seems like most things couldn't be made into objects...)")
			if noelle then
				cutscene:text("* Wow,[wait:0.5] how many catalogues you have?", "surprise", "susie")
				cutscene:text("* You're a bookworm or something?", "smirk", "susie")
				cutscene:text("* No,[wait:0.5] I-[wait:0.5]I didn't even realize they were here.", "smile_closed", "noelle")
			end
		else
			if noelle then
				cutscene:text("* ...", "neutral_side", "susie")
				cutscene:text("* I wonder how this one tastes.[react:1]", "smirk", "susie", {reactions={
					{"Susie???", "right", "bottommid", "confused_surprise", "noelle" }
				}})
			else
				cutscene:text("* (Susie took a bite out of one of the catalogues.)")
				cutscene:text("* Not bad.", "smile", "susie")
				cutscene:text("* Now let's get back to the topic.", "smirk", "susie")
			end
		end
	elseif id==3 then
		if not interacted then
			cutscene:text("* Wow,[wait:0.5] everything on that calendar is the same day.", "nervous", "susie")
			cutscene:text("* How useless can that thing be?", "smirk", "susie")
			if noelle then
				cutscene:text("* ...", "dejected", "noelle")
			end
		else
			if noelle then
				cutscene:text("* ...", "dejected", "noelle")
				cutscene:text("* (Did I say something wrong?)", "sus_nervous", "susie")
			else
				cutscene:text("* (Hey,[wait:0.5] get me away from that wall already.)", "annoyed", "susie")
			end
		end
	elseif id==4 then
		if noelle then
			if not interacted then
				cutscene:text("* So that's the bed Queen gave you?", "neutral_side", "susie")
				cutscene:text("* Ye-[wait:1]Yeah.[wait:1] It's pretty comfy, actually.", "smile_closed", "noelle")
				cutscene:text("* Sounds cool.", "smirk", "susie")
				cutscene:text("* I think Queen said that she had a room for you,[wait:1] Kris and Berd-", "smile_closed", "noelle", {auto=true})
				cutscene:text("* [speed:0.1]...", "shock_b", "noelle")
				cutscene:text("* [speed:0.1]...", "down", "noelle")
				cutscene:text("* ...Noelle?[wait:1] Are you okay?", "nervous", "susie")
				cutscene:text("* A-[wait:1]Ah!", "blush_surprise", "noelle")
				cutscene:text("* Yes,[wait:1] don't worry about me.", "blush_smile", "noelle")
				cutscene:text("* If you say so.", "neutral_side", "susie")
			else
				cutscene:text("* (I should stop thinking about that...)", "down", "noelle")
				cutscene:text("* (Susie is here with me,[wait:1] everything is going to be fine.)", "sad", "noelle")
				cutscene:text("* (It's just a bad dream,[wait:1] and I'll wake up soon.)", "sad_smile", "noelle")
			end
		else
			cutscene:text("* ...", "annoyed_down", "susie")
		end
	elseif id==5 then
		if noelle then
			if not interacted then
				cutscene:text("* (A wardrobe...)", "neutral_side", "susie")
				cutscene:text("* Susie..?[wait:1] What are you doing?", "confused_surprise", "noelle")
				cutscene:text("* No-[wait:0.5]Nothing!", "shy_b", "susie")
				cutscene:text("* (Let's get moving,[wait:0.5] weird voice!)", "shy", "susie")
			else
				cutscene:text("* (I said let's get moving!!)", "shy_b", "susie")
			end
		else
			if not interacted then
				cutscene:text("* (A wardrobe...[wait:1] With clothes inside.)", "neutral", "susie")
			else
				cutscene:text("* (Still a wardrobe.)", "neutral_side", "susie")
			end
		end
	elseif id==6 then
		if noelle then
			if not interacted then
				cutscene:text("* ...", "neutral_side", "susie")
				cutscene:text("* So uh...[wait:1] Why THIS type of giant ferris wheel?", "smirk", "susie")
				cutscene:text("* I-[wait:0.5]I don't know![wait:1] Queen is the one who made the room.", "blush_question", "noelle")
				cutscene:text("* But maybe we could...", "blush_smile", "noelle")
				cutscene:text("* Take it...[wait:1] together?[wait:1] It might bring us to Kris faster, no?", "blush_smile_closed", "noelle")
				cutscene:text("* Eh,[wait:0.5] I prefer not.", "nervous_side", "susie")
				cutscene:text("* Wh-[wait:0.5]Why?", "confused_surprise", "noelle")
				cutscene:text("* What if it actually doesn't bring us to Kris??", "shy_b", "susie")
				cutscene:text("* We-[wait:0.5]Well...", "confused_surprise_b", "noelle")
				cutscene:text("* I guess you're right...", "down", "noelle")
			else
				cutscene:text("* (Maybe I'll be luckier at the festival...)", "sad_smile_b", "noelle")
			end
		else
			if not interacted then
				cutscene:text("* ...", "neutral_side", "susie")
				cutscene:text("* Wonder why she got such a thing in her room.", "nervous", "susie")
				cutscene:text("* The ferris wheel by itself is cool.", "neutral", "susie")
				cutscene:text("* But why the hearts??", "nervous_side", "susie")
				cutscene:text("* Heh,[wait:0.5] whatever.", "neutral", "susie")
			else
				cutscene:text("* ...", "neutral_side", "susie")
			end
		end
	elseif id == 7 then
		cutscene:text("* (From the search 'is ice e real cryptid')")
		cutscene:text("* (It's a cross between ICE-E and something else...)")
		if noelle then
			cutscene:text("* Isn't that the ice thing mascot from that pizza place?", "neutral_side", "susie")
			cutscene:text("* Why do you have something like that in your room?", "nervous", "susie")
			cutscene:text("* That's, uhm, well...", "surprise_smile_b", "noelle")
			cutscene:text("* ...", "what_smile", "noelle")
			cutscene:text("* I wish it wasn't here, honestly.", "frown", "noelle")
			cutscene:text("* Huh.", "nervous_side", "susie")
			cutscene:text("* ...", "neutral_side", "susie")
			cutscene:text("* Then you won't mind if I take this for Kris's room, right?", "smile", "susie")
			cutscene:text("* Huh? What...?", "surprise_frown", "noelle")
			cutscene:text("* (Susie scavenged the ICE-E statue.)")
			local spr = cutscene:getEvent(event.data.properties["spriteObj"].id)
			spr:remove()
			event:remove()
		else
			if not interacted then
				cutscene:text("* That thing looks awful. Why does Noelle even have that?", "nervous_side", "susie")
			else
				cutscene:text("* What? Did you expect something else?", "neutral", "susie")
				cutscene:text("* WE have better things to do than look at whatever that is.", "closed_grin", "susie")
			end
		end
	elseif id == 8 then
		if noelle then
			cutscene:text("* Yo, this statue is sick!", "surprise_smile", "susie")
			cutscene:text("* A-Ah! Susie, I can explain, you know!", "blush_surprise_smile", "noelle")
			cutscene:text("* Huh? Explain what?", "neutral_side", "susie")
			cutscene:text("* You... don't see the resemblance to someone?", "confused_surprise_b", "noelle")
			cutscene:text("* Huh? No, I don't.", "nervous_side", "susie")
			cutscene:text("* ...", "what", "noelle")
			cutscene:text("* Well anyway, don't mind if I do!", "sincere_smile", "susie")

			cutscene:text("* (Susie stole the Susie-like statue.)")
			local spr = cutscene:getEvent(event.data.properties["spriteObj"].id)
			spr:remove()
			event:remove()
		else
			if not interacted then
				cutscene:text("* Damn, that's a cool statue.", "smirk", "susie")
			else
				cutscene:text("* What? Did you expect something else?", "neutral", "susie")
				cutscene:text("* WE have better things to do than look at statues.", "closed_grin", "susie")
			end
		end
	end
end