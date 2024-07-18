local her_room, super = Class(Map)

function her_room:onEnter()
	super:onEnter(self)
	Game:setBorder("mansion")
	if Game:getFlag("plot", 0)==2 and Game:getFlag("noelle_battle_status", nil)==nil then
        print("Start the quick intro")
        print(Game.battle)
        if not Game.battle then
            Game.world:startCutscene("intro.quickintro")
        end
    end
	if Game:getFlag("plot", 0)>=3 then
		Game.world:getEvent(26):remove()
		if Game:getFlag("noelle_battle_status", "no_trance")=="killspare" then
			local noelle_head=Sprite("Noelle_sleeping_in_bed", 560, 185)
			noelle_head:setScale(2)
			noelle_head.layer=0.3
			Game.world:addChild(noelle_head)
		end
	end

	if Game:getFlag("interacted-7", false) then
		local event = Game.world:getEvent(30)
		Game.world:getEvent(event.data.properties["spriteObj"].id):remove()
		event:remove()
	end
	if Game:getFlag("interacted-8", false) then
		local event = Game.world:getEvent(31)
		Game.world:getEvent(event.data.properties["spriteObj"].id):remove()
		event:remove()
	end
end

function her_room:update()
	if Game:getFlag("plot", 0)==3 and not Game:getFlag("susie_reaction", false) then
		if not Game.world.menu and not (Kristal.Console and Kristal.Console.is_open) and not (Kristal.DebugSystem and Kristal.DebugSystem:isMenuOpen()) then
			if Input.down("left") or Input.down("up") or Input.down("right") or Input.down("down") then
				Game:setFlag("susie_reaction", true)
				Game.world.timer:after(1/8, function()
					Game.world:startCutscene("susie_reaction")
				end)
			end
		end
	end
end

return her_room