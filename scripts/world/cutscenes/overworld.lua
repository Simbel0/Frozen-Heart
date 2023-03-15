return {
	incorrectway=function(cutscene)
		local noelle=cutscene:getCharacter("noelle")
		Game:setFlag("incorrectWayTaken", Game:getFlag("incorrectWayTaken", -1)+1)
		local susie=cutscene:getCharacter("susie")

		if Game:getFlag("incorrectWayTaken", 0)==0 then 		
			if noelle then
				cutscene:text("* Susie..? Where are we going?", "confused_surprise_b", "noelle")
				cutscene:text("* That's what I'd like to know too.", "nervous_side", "susie")
				cutscene:text("* (Hey, the weird voice, that's the wrong way!)", "shy_b", "susie")
			else
				cutscene:text("* Kris is at the fountain, not in the mansion.", "neutral_side", "susie")
				cutscene:text("* I'd expect whatever you are to know the way better.", "annoyed", "susie")
			end
			cutscene:wait(cutscene:walkToSpeed(susie, susie.x+10, susie.y, 8))
		elseif Game:getFlag("incorrectWayTaken", 0)<5 then
			if noelle then
				cutscene:text("* (Wrong way.)", "neutral_side", "susie")
			else
				cutscene:text("* Wrong way.", "annoyed", "susie")
			end
			cutscene:wait(cutscene:walkToSpeed(susie, susie.x+10, susie.y, 8))
		else
			cutscene:text("* Oh my god, stop!", "angry", "susie")
			cutscene:wait(cutscene:walkToSpeed(susie, susie.x, 375, 8))
			cutscene:wait(cutscene:walkToSpeed(susie, 1245, 375, 16))
			cutscene:endCutscene()
		end
	end,
	incorrectFloor=function(cutscene)
		cutscene:setTextboxTop(true)
		local noelle=cutscene:getCharacter("noelle")
		Game:setFlag("incorrectWayTaken", Game:getFlag("incorrectWayTaken", -1)+1)
		local susie=cutscene:getCharacter("susie")

		if Game:getFlag("incorrectWayTaken", 0)==0 then 		
			if noelle then
				cutscene:text("* Susie..? Where are we going?", "confused_surprise_b", "noelle")
				cutscene:text("* That's what I'd like to know too.", "nervous_side", "susie")
				cutscene:text("* (Hey, the weird voice, we don't need to go down!!)", "shy_b", "susie")
			else
				cutscene:text("* What? You want to run away so soon?", "closed_grin", "susie")
				cutscene:text("* No.", "teeth_smile", "susie")
			end
			cutscene:wait(cutscene:walkToSpeed(susie, susie.x, susie.y+10, 8))
		elseif Game:getFlag("incorrectWayTaken", 0)<5 then
			if noelle then
				cutscene:text("* (We're on the right floor.)", "neutral_side", "susie")
			else
				cutscene:text("* Don't try to run away.", "teeth_smile", "susie")
			end
			cutscene:wait(cutscene:walkToSpeed(susie, susie.x, susie.y+10, 8))
		else
			cutscene:text("* Oh my god, stop!", "angry", "susie")
			cutscene:wait(cutscene:walkToSpeed(susie, 320, 375, 8))
			cutscene:wait(cutscene:walkToSpeed(susie, 1245, 375, 16))
			cutscene:endCutscene()
		end
	end,
	-----------------------------------------
	-----------------------------------------
	---------------------------------
	electricity1=function(cutscene)
		local noelle=cutscene:getCharacter("noelle")
		local susie=cutscene:getCharacter("susie")

		if noelle then
			cutscene:detachFollowers()
			noelle:setSprite("walk")
			cutscene:wait(cutscene:walkTo(noelle, 290, 465))
			cutscene:text("* Su-[wait:0.5]Susie,[wait:0.5] the path ahead seems more dangerous...", "surprise_frown_b", "noelle")
			cutscene:walkTo(susie, noelle.x-50, noelle.y)
			cutscene:detachCamera()
			cutscene:panTo(2180, 330, 4)
			cutscene:wait(4.5)
			cutscene:wait(cutscene:attachCamera(2))
			cutscene:look(noelle, "left")
			cutscene:text("* What?[wait:1] That?[wait:1] That's nothing.", "smirk", "susie")
			cutscene:text("* We already went through this with Kris and Ralsei,[wait:0.5] don't worry.", "smile", "susie")
			cutscene:text("* We'll both pass easily.", "smile", "susie")
			cutscene:text("* We[wait:0.5]-Well if you say so...", "blush_smile", "noelle")
			cutscene:text("* Let's go,[wait:0.5] then!", "blush_smile_closed", "noelle")
			noelle:resetSprite()
			cutscene:interpolateFollowers()
			cutscene:attachFollowers()
		end
	end,
	electricity2=function(cutscene)
		local noelle=cutscene:getCharacter("noelle")
		local susie=cutscene:getCharacter("susie")

		if noelle then
			local hit_count=Game:getFlag("hangplug_hits", 0)
			cutscene:wait(cutscene:walkToSpeed(susie, susie.x+50, susie.y, 8))
			if hit_count==0 then
				susie:setSprite("walk_back_arm")
				cutscene:look(susie, "left")
				cutscene:text("* See? We made it!", "sincere_smile", "susie")
				cutscene:text("* You're right! We passed like it was nothing!", "smile_closed", "noelle")
				cutscene:text("* I would not have wanted to grill on the spot so far in this dream!", "blush_smile_closed", "noelle")
				cutscene:text("* Yeah, me neither.", "nervous_side", "susie")
				cutscene:text("* Let's continue now. There's no other danger ahead.", "smile", "susie")
				cutscene:text("* Once we'll get to Kris, everything will be fine!", "smile", "susie")
				susie:resetSprite()
			elseif hit_count>=1 then
				cutscene:text("* So what were you saying about how it's nothing?", "smile_closed_b", "noelle")
				cutscene:text("* Well, uh...", "shy", "susie")
				cutscene:text("* ...", "shy", "susie")
				cutscene:text("* A lot of stuff happen since the last time I pass that room.", "blush", "susie")
				cutscene:text("* And maybe... They're faster than last time?", "nervous_side", "susie")
				cutscene:text("* Yeah, whatever, Susie.", "smile_closed_b", "noelle")
				cutscene:text("* Ah whatever! Let's continue!", "teeth_b", "susie")
				cutscene:text("* Once we'll get to Kris, there will be no more difficulties.", "teeth_smile", "susie")
			end
			cutscene:text("* ...", "sad_side", "noelle")
		end
	end,
	tooMuchElec=function(cutscene)
		for i,v in ipairs(Game.world:getEvents("hangplug")) do
			v.attack=false
		end
		local susie=cutscene:getCharacter("susie")
		cutscene:text("* Oh come on!!", "angry", "susie")
		---- Code by vitellary
		local marker_amount = 11 -- this should be however many markers you have
		local susie = cutscene:getCharacter("susie")
		for i=0,marker_amount do
		  local marker_x, marker_y = cutscene:getMarker("path_"..i) -- markers would be named 'name_1', 'name_2', etc
		  if marker_x >= susie.x then
		  	cutscene:wait(cutscene:walkToSpeed("susie", marker_x, marker_y, 10)) -- then its vertical position
		    cutscene:wait(cutscene:walkToSpeed("susie", marker_x, susie.y, 10)) -- walk to its horizontal position
		  end
		end
	end,
	-----------------------------------------
	-----------------------------------------
	-----------------------------------------
	doubts=function(cutscene)
		local noelle=cutscene:getCharacter("noelle")
		local susie=cutscene:getCharacter("susie")

		if noelle then
			cutscene:detachFollowers()
			noelle:setSprite("walk_sad")
			cutscene:wait(cutscene:walkToSpeed(susie, 1390, susie.y, 6))
			cutscene:look(susie, "left")
			susie.alert_icon = Sprite("effects/alert", susie.sprite.width/2)
	        susie.alert_icon:setOrigin(0.5, 1)
	        susie.alert_icon.layer = 100
	        susie:addChild(susie.alert_icon)
	        Game.world.timer:after(0.8, function()
	            susie.alert_icon:remove()
	        end)
	        Game.world.music:fade(0, 2, function() Game.world.music:stop() end)
			cutscene:text("* Susie,[wait:0.5] wait...", nil, "noelle")
			noelle:setPosition(880, 115)
			cutscene:look(noelle, "up")
			noelle:setSprite("head_lowered")
			cutscene:wait(1/12)
			cutscene:text("* Noelle?", "surprise", "susie")
			cutscene:wait(cutscene:walkToSpeed(susie, 1040, 160, 8))
			cutscene:text("* ...Susie...", nil, "noelle")
			cutscene:text("* Can I ask you something?", nil, "noelle")
			cutscene:text("* Of course,[wait:0.5] anything.", "neutral_side", "susie")
			cutscene:text("* ...", nil, "noelle")
			cutscene:text("* What would you do if a friend of yours suddenly start acting a hurtful way?", nil, "noelle")
			Game.world.music:play("noelle_normal", 1, 1)
			cutscene:text("* Uh??", "surprise", "susie")
			cutscene:text("* What are you talking about?", "nervous", "susie")
			cutscene:text("* I don't know...[wait:1] I'm just...[wait:1] wondering.", nil, "noelle")
			cutscene:text("* If your friend suddenly became like someone else...[wait:1] What would you do?", nil, "noelle")
			cutscene:text("* If a friend became like someone else...", "annoyed_down", "susie")
			cutscene:wait(cutscene:walkToSpeed(susie, 960, 115, 4, "up"))
			cutscene:wait(1/2)
			cutscene:text("* I...", "nervous_side", "susie")
			cutscene:text("* ...", "nervous", "susie")
			cutscene:text("* I think...", "nervous", "susie")
			cutscene:text("* I would give them a good slap in the face.", "smile", "susie")
			cutscene:text("* Not because they deserve it for whatever they did..", "smirk", "susie")
			cutscene:text("* But because for someone to change as suddenly as you make it sound..", "smirk", "susie")
			cutscene:text("* And for them to make something that would..[wait:0.5] hurt their own friends..", "nervous", "susie")
			cutscene:text("* Then something must have happen to them first.", "neutral_side", "susie")
			cutscene:text("* And if so,[wait:0.5] they probably need help.", "neutral", "susie")
			noelle:setSprite("head_lowered_look_right")
			cutscene:text("* ...How slapping them would help them?", nil, "noelle")
			cutscene:text("* I don't know.[wait:1] Just in case they were sleepwalking maybe?", "smirk", "susie")
			cutscene:text("* ...", nil, "noelle")
			noelle:setSprite("laugh")
			noelle:play(1/4)
			cutscene:look(noelle, "down")
			cutscene:look(susie, "left")
			cutscene:text("* Ahah.[wait:1] Come on,[wait:0.5] Susie![wait:1] I was serious!", "smile_closed_b", "noelle")
			cutscene:text("* Who said I wasn't?", "teeth_smile", "susie")
			cutscene:text("* Oh my god!", "smile_closed_b", "noelle")
			cutscene:look(noelle, "up")
			noelle:setSprite("walk")
			cutscene:text("* But still...", "sad_smile", "noelle")
			cutscene:text("* Thank you,[wait:0.5] Susie.", "sad_smile_b", "noelle")
			cutscene:text("* I think I needed to hear something like that.", "down_smile", "noelle")
			cutscene:text("* I'm not sure I understand everything but...", "neutral_side", "susie")
			cutscene:text("* Anytime.[wait:1] That's what friends are for, right?", "sincere_smile", "susie")
			cutscene:text("* I-[wait:0.5]I guess so,[wait:0.5] yeah...", "smile_side", "noelle")
			cutscene:text("* Susie...", "blush_smile", "noelle")
			cutscene:wait(cutscene:walkToSpeed(noelle, noelle.x+38, noelle.y+4, 1))
			susie.visible=false
			noelle:setSprite("noelle_susie_shoulder")
			cutscene:wait(1/4)
			cutscene:text("* Thank you for everything.", "smile_closed", "noelle")
			cutscene:text("* You did a lot for me.", "blush_smile", "noelle")
			cutscene:text("* ...!", "shock", "susie")
			cutscene:text("* I mean...", "shock_down", "susie")
			cutscene:text("* You're welcome,[wait:0.5] I suppose?", "blush", "susie")
			cutscene:wait(2)
			noelle:setSprite("noelle_susie_shoulder_susiefixed")
			cutscene:text("* So uh...[wait:1] You planned on keeping your hand on my shoulder forever or...?", "blush", "susie")
			susie.visible = true
			noelle:setSprite("hand_mouth")
			cutscene:text("* N-[wait:0.5]No,[wait:0.5] sorry![wait:1] I just...[wait:1] didn't know what to do next.", "blush_surprise", "noelle")
			noelle:resetSprite()
			cutscene:look(noelle, "right")
			cutscene:text("* I think I'm ready to continue...", "blush_smile", "noelle")
			cutscene:text("* And to see Kris,[wait:0.5] of course!", "smile_closed", "noelle")
			cutscene:text("* Great.[wait:1] Let's get going then.", "smile", "susie")

			susie:resetSprite()
			noelle:resetSprite()

			Assets.playSound("snd_ominous_cancel")
			Game:setFlag("doubtDiscussion", true)

			cutscene:interpolateFollowers()
			cutscene:attachFollowers(1)

			cutscene:wait(1)
		end
	end,
	together=function(cutscene)
		local queen=cutscene:getCharacter("queen")
		local ralsei=cutscene:getCharacter("ralsei")
		local susie=cutscene:getCharacter("susie")
		local noelle=cutscene:getCharacter("noelle")

		cutscene:detachCamera()
		cutscene:detachFollowers()

		cutscene:look(ralsei, "left")
		cutscene:look(queen, "left")

		queen.alert_icon = Sprite("effects/alert", queen.sprite.width/2)
        queen.alert_icon:setOrigin(0.5, 1)
        queen.alert_icon.layer = 100
        queen:addChild(queen.alert_icon)
        ralsei.alert_icon = Sprite("effects/alert", ralsei.sprite.width/2)
        ralsei.alert_icon:setOrigin(0.5, 1)
        ralsei.alert_icon.layer = 100
        ralsei:addChild(ralsei.alert_icon)
        Game.world.timer:after(0.8, function()
        	queen.alert_icon:remove()
            ralsei.alert_icon:remove()
        end)
        if noelle then
        	noelle:setSprite("walk")
        end
        cutscene:wait(1)

		if noelle then
			cutscene:text("* Susie![wait:1] You're back!", "blush_pleased", "ralsei")
			cutscene:text("* And you brought a friend with you!", "smile", "ralsei")
			cutscene:text("* Nice to see you too,[wait:0.5] glasses nerd.", "smirk", "susie")
			cutscene:text("* ...", "surprise_frown_b", "noelle")
			cutscene:text("* Noelle Honey Sweety Darling", "smile", "queen")
			cutscene:text("* You Seem To Have Perfectly Slept", "true", "queen")
			cutscene:text("* You Have Successfully Come Back To The Default Settings", "nice", "queen")
			cutscene:text("* Yeah,[wait:0.5] I guess so...", "surprise_smile", "noelle")
			noelle:setSprite("walk_blush")
			cutscene:text("* Susie helped me a lot.", "blush_smile", "noelle")
			cutscene:text("* Oh What That", "surprise_side", "queen")
			cutscene:wait(cutscene:walkToSpeed(queen, queen.x-200, noelle.y, 6))
			cutscene:text("* My Sensors Are Detecting Something Unexpected", "surprise", "queen")
			noelle:setSprite("walk")
			cutscene:text("* Wh-[wait:0.5]Wha-", "shock_b", "noelle")
			cutscene:walkToSpeed(susie, susie.x, susie.y-20, 4, "down", true)
			cutscene:wait(cutscene:walkToSpeed(queen, susie.x, noelle.y, 6))
			cutscene:text("* Heat Levels Are Going Sky High", "surprise_side", "queen")
			cutscene:text("* Running Simulation For: What Going On", "down_a", "queen")
			cutscene:text("* Queen,[wait:0.5] I don't think you under-", "blush_surprise_smile", "noelle")
			cutscene:wait(cutscene:walkToSpeed(queen, noelle.x+45, noelle.y, 4))
			cutscene:text("* Simulation Finished\n* Taken Time: Very Fast", "analyze", "queen")
			cutscene:text("* Noelle I Am Very Surprised", "neutral", "queen")
			cutscene:text("* I Did Not Expect You To Feel That Way For-", "smile_side_l", "queen")
			cutscene:walkToSpeed(noelle, noelle.x-10, noelle.y, 4, "right", true)
			cutscene:text("* Queen please!!", "silly", "noelle")
			cutscene:text("* I'd die if you mention that here..", "surprise_smile", "noelle")
			cutscene:text("* ...", "down_c", "queen")
			cutscene:wait(cutscene:walkToSpeed(queen, noelle.x+100, noelle.y, 6, "left", true))
			cutscene:wait(0.5)
			cutscene:look(queen, "down")
			cutscene:text("* Respect Of Private Life Acknowledged", "smile", "queen")
			cutscene:text("* You Are Now Safe From Undesired Facts About: Your Face", "true", "queen")
			queen:setSprite("laugh")
			queen:play(1/6)
			Assets.playSound("queen/laugh")

			cutscene:wait(1)
			noelle:setSprite("walk_blush")
			cutscene:text("* (I guess that's better than nothing...)", "blush_smile", "noelle")
			cutscene:text("* Uh...[wait:1] Can someone fill me in?", "nervous", "susie")
			queen:setSprite("walk")
			cutscene:text("* Access Refused Try Another Question", "smile_side_r", "queen")
			cutscene:text("* Yeah okay...", "neutral", "susie")
			cutscene:wait(cutscene:walkToSpeed(susie, ralsei.x-50, ralsei.y, 6))
			cutscene:setTextboxTop(true)
			cutscene:text("* Ralsei,[wait:0.5] have you seen Kris?", "neutral_side", "susie")
			cutscene:text("* I would have expected the fountain to be closed by now.", "smirk", "susie")
			cutscene:text("* They didn't come back yet but now that you mention it...", "small_smile_side_b", "ralsei")
			cutscene:text("* It's true that Kris has been gone for very long.", "small_smile_side", "ralsei")
			local minutes = math.floor(Game.playtime / 60)
        	local seconds = math.floor(Game.playtime % 60)
        	local time_text = string.format("%d Mins %02d Secs", minutes, seconds)
        	noelle:setSprite("walk")
        	cutscene:look(queen, "right")
        	cutscene:look(susie, "left")
			cutscene:text("* Estimated Time Since Kris Has Been Gone: "..time_text, "neutral", "queen")
			cutscene:text("* Average Time Needed To Seal A Dark Fountain:", "neutral", "queen")
			cutscene:text("* I Have No Idea LMAO", "idk", "queen")
			cutscene:text("* So in any case,[wait:0.5] it's no good.", "neutral", "susie")
			cutscene:text("* Then I'll go see by myself.", "smirk", "susie")
			cutscene:text("* Are you sure,[wait:0.5] Susie?", "smile", "ralsei")
			cutscene:text("* Maybe Kris...[wait:1] Just needed to relax?", "pleased", "ralsei")
			cutscene:text("* Come on.[wait:1] Who relax in front of a rainbow geyser?", "nervous", "susie")
			cutscene:text("* ..I guess it won't hurt for them to have company.", "smile", "ralsei")
			cutscene:text("* Great.", "smirk", "susie")
			cutscene:text("* Noelle,[wait:0.5] you're coming?", "small_smile", "susie")
			cutscene:text("* Ah uhm yes!", "blush_question", "noelle")
			noelle:setSprite("walk_blush")
			cutscene:attachFollowers(2)
			cutscene:text("* You bring Noelle with you too?", "neutral", "ralsei")
			cutscene:look(susie, "right")
			cutscene:text("* Of course.[wait:1] 2 friends will be better than one,[wait:0.5] right?", "smile", "susie")
			cutscene:text("* Affirmative", "true", "queen")
			cutscene:text("* ..You're right.[wait:1] Sorry for sounding so doubting.", "pleased", "ralsei")
			cutscene:text("* Go now![wait:1] Kris is waiting for you two!", "wink", "ralsei")
			cutscene:look(susie, "left")
			cutscene:look(noelle, "left")
			cutscene:text("* Good Luck To You Two", "neutral", "queen")
			cutscene:text("* I Hope Noelle Will Like It", "smile_side_l", "queen")
			cutscene:text("* Queen![wait:1] What about what you said earlier!", "blush_smile_closed", "noelle")
			cutscene:text("* Do Not Worry It Was A Calculated Statement", "sorry", "queen")
			cutscene:text("* Susie Has 0.00001% Chance Of Understanding What I Am Referencing", "analyze", "queen")
			cutscene:text("* Oh my god let's just go!", "smile_closed_b", "noelle")
			cutscene:walkToSpeed(ralsei, 1930, 300, 6, "down")
			cutscene:walkToSpeed(queen, 1710, 300, 6, "down")
			cutscene:wait(cutscene:attachCamera())

			susie:resetSprite()
			noelle:resetSprite()
		else
			cutscene:text("* Susie![wait:1] You're back!", "blush_pleased", "ralsei")
			cutscene:text("* Nice to see you too,[wait:0.5] glasses nerd.", "smirk", "susie")
			cutscene:wait(cutscene:walkToSpeed(queen, queen.x-200, susie.y, 6))
			cutscene:text("* How Is Noelle Honey Sweety Doing", "smile", "queen")
			cutscene:text("* She...", "nervous_side", "susie")
			cutscene:text("* She's fine now.", "nervous", "susie")
			cutscene:text("* She was acting weird but everything is settle now.", "smirk", "susie")
			cutscene:text("* This Is Perfect", "smile", "queen")
			cutscene:text("* I Sure Hope You Are Not Hiding A Horrible Thing You Did To Her", "true", "queen")
			cutscene:text("* Wha-[wait:0.5] Why would you even think of that??", "shock_nervous", "susie")
			cutscene:text("* It Sounded Cool To Say", "lmao", "queen")
			queen:setSprite("laugh")
			queen:play(1/6)
			Assets.playSound("queen/laugh")

			cutscene:wait(1)
			cutscene:text("* Right...", "suspicious", "susie")
			cutscene:attachCameraImmediate()
			cutscene:wait(cutscene:walkToSpeed(susie, ralsei.x-50, ralsei.y, 6))
			cutscene:setTextboxTop(true)
			cutscene:text("* Ralsei,[wait:0.5] have you seen Kris?", "neutral_side", "susie")
			cutscene:text("* I would have expected the fountain to be closed by now.", "smirk", "susie")
			cutscene:text("* They didn't come back yet but now that you mention it...", "small_smile_side_b", "ralsei")
			cutscene:text("* It's true that Kris has been gone for very long.", "small_smile_side", "ralsei")
			local minutes = math.floor(Game.playtime / 60)
        	local seconds = math.floor(Game.playtime % 60)
        	local time_text = string.format("%d Mins %02d Secs", minutes, seconds)
        	queen:setSprite("walk")
        	cutscene:look(queen, "right")
        	cutscene:look(susie, "left")
			cutscene:text("* Estimated Time Since Kris Has Been Gone: "..time_text, "neutral", "queen")
			cutscene:text("* Average Time Needed To Seal A Dark Fountain:", "neutral", "queen")
			cutscene:text("* I Have No Idea LMAO", "idk", "queen")
			cutscene:text("* So in any case,[wait:0.5] it's no good.", "neutral", "susie")
			cutscene:text("* Then I'll go see by myself.", "smirk", "susie")
			cutscene:text("* Are you sure,[wait:0.5] Susie?", "smile", "ralsei")
			cutscene:text("* Maybe Kris...[wait:1] Just needed to relax?", "pleased", "ralsei")
			cutscene:text("* Come on.[wait:1] Who relax in front of a rainbow geyser?", "nervous", "susie")
			cutscene:text("* ..I guess it won't hurt for them to have company.", "smile", "ralsei")
			cutscene:text("* Great.", "smirk", "susie")
			cutscene:look(susie, "right")
			cutscene:text("* Go then![wait:1] Kris is waiting for you, Susie!", "wink", "ralsei")
			cutscene:look(susie, "left")
			cutscene:text("* Good Luck To You Susie", "neutral", "queen")
			cutscene:text("* I Hope Noelle Is Fine", "sorry", "queen")
			cutscene:text("* Why do you keep insisting she's not fine??!", "angry", "susie")
			cutscene:text("* Unnecessery Drama", "nice", "queen")
			cutscene:text("* I'm going!!", "teeth_b", "susie")
			cutscene:walkToSpeed(ralsei, 1930, 300, 6, "down")
			cutscene:walkToSpeed(queen, 1710, 300, 6, "down")
			cutscene:wait(cutscene:attachCamera())

			susie:resetSprite()
		end
		Game:setFlag("togetherDialogue", true)
	end,
	queen_dialogue=function(cutscene)
		cutscene:text("* Your Friend Said I Will Be Able To Turn Your Castle Into My Mansion", "smile", "queen")
		cutscene:text("* I Hope You Are Ready To Have Me As Your Wacky Roommate", "big_smile", "queen")
		if cutscene:getCharacter("noelle") then
			cutscene:text("* (I never said anything about that.)[react:1]", "surprise_confused", "ralsei", {reactions={
				{"(Susie has a\ncastle?)", "right", "bottommid", "confused_surprise", "noelle"}
			}})
		else
			cutscene:text("* (I never said anything about that.)", "surprise_confused", "ralsei")
		end
	end,
	ralsei_dialogue=function(cutscene)
		if cutscene:getCharacter("noelle") then
			cutscene:text("* Kris is waiting for you two!", "blush_smile", "ralsei")
		else
			cutscene:text("* Kris is waiting for you, Susie!", "blush_smile", "ralsei")
		end
		cutscene:after(function() Game.world:getEvent(1):setFacing("down") end)
	end,
	realisation=function(cutscene)
		local susie=cutscene:getCharacter("susie")
		local noelle=cutscene:getCharacter("noelle")
		if noelle then
			cutscene:wait(cutscene:walkToSpeed(susie, 360, 920, 8))
			cutscene:wait(0.1)
			cutscene:look(susie, "up")
			cutscene:look(noelle, "up")

			cutscene:text("* Wha-What is going on there??", "afraid", "noelle")
			cutscene:text("* I don't know but it sounds pretty intense.", "sus_nervous", "susie")
			cutscene:text("* Let's go kick the butt of whoever is kicking Kris's!", "teeth_smile", "susie")

			cutscene:wait(1.5)
			cutscene:look(noelle, "right")

			cutscene:text("* Su-Susie...? What are we waiting?", "blush_question", "noelle")
			cutscene:text("* Uhm... Nothing, we're going now.", "nervous", "susie")
		else
			cutscene:wait(cutscene:walkToSpeed(susie, 320, 920, 8))
			cutscene:wait(0.1)
			cutscene:look(susie, "up")

			cutscene:text("* Wha-What the hell are those noises??", "surprise_frown", "susie")
			cutscene:text("* It doesn't sound like what happened last time!", "sad", "susie")
			cutscene:text("* ...", "neutral", "susie")
			cutscene:text("* Whoever is kicking Kris's ass, I'm coming!!", "teeth", "susie")

			cutscene:wait(1.5)

			cutscene:text("* Any... moment now.", "nervous_side", "susie")
		end
		cutscene:text("* (MOVE, STUPID VOICE!!)", "teeth_b", "susie")
	end,
	nopower=function(cutscene)
		local susie=cutscene:getCharacter("susie")
		local noelle=cutscene:getCharacter("noelle")

		local shake=Game.world.timer:everyInstant(1, function()
			susie:shake(2)
		end)
		cutscene:setTextboxTop(true)

		cutscene:text("* Ugh... My head is hurting like hell...", "bangs_neutral", "susie")
		if noelle then
			cutscene:detachFollowers()
			cutscene:detachCamera()
			cutscene:text("* Su-Susie? Are you okay??", "afraid_b", "noelle")
			cutscene:text("* Ye-Yeah. Don't worry too much about it.", "nervous", "susie")
			cutscene:text("* ...But...", "sad_b", "noelle")
			cutscene:text("* Come on, Noelle! I won't give up to a little headache!", "sincere_smile", "susie")
			local stopDuring=false
			Game.world.timer:everyInstant(1, function()
				Game.world.timer:tween(0.3, susie, {y=susie.y-5})
				if susie.y<=460 or stopDuring then
					return false
				end
			end)
			cutscene:text("* We just need to go forward and then...", "nervous_side", "susie")
			cutscene:text("* Susie, please, we can just take a little break and...", "afraid", "noelle")
			stopDuring=true
			Game.world.timer:cancel(shake)
			noelle:setSprite("shocked")
			Assets.stopAndPlaySound("unboost")
			Game.world.map.volume=0
			Game.world.music:fade(0, 0.5)
			local offset = susie.sprite:getOffset()
			local flash = FlashFade(susie.sprite.texture, offset[1], offset[2])
    		flash.layer = 100
    		flash.flash_speed = 0.5
    		susie:addChild(flash)
			--susie:flash()
			cutscene:fadeOut(0.5, {color={1, 1, 1}})
			cutscene:wait(1.5)
			susie:setSprite("fell")
			Game.world.timer:tween(1, Game.world.map, {volume=0.1})
			cutscene:wait(cutscene:fadeIn(1))
			cutscene:wait(1.5)
			cutscene:text("* (Susie's power went back to normal.)")
			cutscene:text("* (She cannot cast Tension Absorb anymore.)")
    		Game.party[1]:removeSpell("tension_absorb")
    		noelle:setSprite("walk")
    		cutscene:look("up")
    		cutscene:text("* Susie!!", "afraid", "noelle")
    		cutscene:wait(cutscene:walkTo(noelle, susie.x, susie.y+15, 0.4))
    		noelle:play(1/16)
    		cutscene:text("* Susie, are you alright??", "afraid_b", "noelle")
    		cutscene:text("* Ugh... I feel so weak now...", "bangs_neutral", "susie")
    		susie:setSprite("landed_1")
    		Assets.playSound("noise")
    		cutscene:wait(cutscene:walkTo(noelle, susie.x, susie.y+25, 0.2, "up", true))
    		noelle.sprite:pause()
    		cutscene:wait(0.25)
    		cutscene:text("* ...", "surprise_frown_b", "noelle")
    		cutscene:text("* Wa-Wait!", "surprise_frown", "noelle")
    		local wait, text = cutscene:text("* Susie, don't move!", "question", "noelle", {wait=false})
    		cutscene:wait(cutscene:walkTo(noelle, noelle.x, susie.y+135, 0.5))
    		cutscene:wait(wait)
    		Assets.playSound("spellcast")
    		noelle:setAnimation({"battle/spell", 1/15, false, next="walk/up"})
    		cutscene:wait(0.75)

    		Assets.playSound("power")
		    local sprite_to_use = susie.sprite
		    local offset = sprite_to_use:getOffset()
		    local flash = FlashFade(sprite_to_use.texture, offset[1], offset[2])
		    flash:setLayer(susie.layer+100)
		    flash:setColor(0, 1, 0)
		    susie:addChild(flash)
		    Game.world.timer:every(1/30, function()
		        for i = 1, 2 do
		            local x = susie.x + ((love.math.random() * susie.width) - (susie.width / 2)) * 2
		            local y = susie.y - (love.math.random() * susie.height) * 2
		            local sparkle = HealSparkle(x, y)
		            sparkle:setColor(0, 1, 0)
		            susie.parent:addChild(sparkle)
		        end
		    end, 4)

		    cutscene:wait(0.75)

		    cutscene:text("* H-How do you feel?", "blush_question", "noelle")
		    cutscene:text("* I... feel...", "bangs_neutral", "susie")
		    susie:setSprite("walk")
		    cutscene:look("down")
    		Assets.playSound("noise")
    		cutscene:wait(0.75)
    		cutscene:text("* I feel a lot better, actually.", "surprise", "susie")
    		cutscene:text("* So uh... Thanks, I guess.", "shy", "susie")
    		cutscene:text("* ...!", "blush_big_smile", "noelle")
    		cutscene:text("* Yo-You're welcome!", "blush_finger", "noelle")
    		cutscene:look("up")
    		cutscene:text("* Now we can really go kick butt!", "smile", "susie")
    		cutscene:interpolateFollowers()
    		cutscene:attachFollowers()
    		cutscene:text("* Yeah, like you said!", "blush_smile_closed", "noelle")
    	else
    		cutscene:text("* But I won't give up to a little headache!", "angry_b", "susie")
			local stopDuring=false
			Game.world.timer:everyInstant(0.7, function()
				Game.world.timer:tween(0.3, susie, {y=susie.y-5})
				if susie.y<=460 or stopDuring then
					return false
				end
			end)
			cutscene:text("* I just need to go forward and then...", "angry_c", "susie")
			stopDuring=true
			Game.world.timer:cancel(shake)
			Assets.stopAndPlaySound("unboost")
			Game.world.map.volume=0
			Game.world.music:fade(0, 0.5)
			local offset = susie.sprite:getOffset()
			local flash = FlashFade(susie.sprite.texture, offset[1], offset[2])
    		flash.layer = 100
    		flash.flash_speed = 0.5
    		susie:addChild(flash)
			--susie:flash()
			cutscene:fadeOut(0.5, {color={1, 1, 1}})
			cutscene:wait(1.5)
			susie:setSprite("fell")
			Game.world.timer:tween(1, Game.world.map, {volume=0.1})
			cutscene:wait(cutscene:fadeIn(1))
			cutscene:wait(1.5)
			cutscene:text("* (Susie's power went back to normal.)")
			cutscene:text("* (She cannot cast Tension Absorb anymore.)")
    		Game.party[1]:removeSpell("tension_absorb")

    		cutscene:wait(1.5)
    		cutscene:text("* Huuuh...", nil, "susie")

    		susie:setSprite("landed_1")
    		Assets.playSound("noise")

    		cutscene:wait(0.5)

    		cutscene:text("* Come on, Susie... Get up...", "bangs_neutral", "susie")
    		cutscene:text("* I need to help Kris... Seal the fountain...!", "bangs_teeth", "susie")

    		susie:setSprite("walk")
		    cutscene:look("up")
    		Assets.playSound("noise")

    		cutscene:wait(0.5)

    		cutscene:text("* Come on!", "angry_c", "susie")
    		cutscene:text("* I've got some butt to kick.", "closed_grin", "susie")
    	end
    	local tran = Game.world:getEvent(22)
		trans_x, tran_y = tran:getPosition()
		tran:remove()
		cutscene:walkTo(susie, susie.x, tran_y-50, 2)
		cutscene:fadeOut(1)
		cutscene:wait(1.5)
		cutscene:mapTransition("fountain_room")
		cutscene:gotoCutscene("ending.killing_spamton")
	end,
	man=function(cutscene)
		if not Game.inventory:hasItem("egg") then
			cutscene:text("* (Well[wait:1], there is a man here.)")
			cutscene:text("* (The man might be happy again.)")
			cutscene:text("* (He wants to express his gratitude towards you.)")
			cutscene:choicer({"Yes", "No"})
			if cutscene.choice==1 then
				Assets.stopAndPlaySound("egg")
				Game.inventory:addItemTo("key_items", "egg", false)
				cutscene:text("* (You received an Egg.)")
			end
		else
			cutscene:text("* (Well[wait:1], there was not a man here.)")
		end
	end
}