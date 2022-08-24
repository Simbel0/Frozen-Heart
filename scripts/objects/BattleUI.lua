local BattleUI_o, super = Class(BattleUI, false)

function BattleUI_o:drawState()
    if Game.battle.state == "ALLSELECT" then
    	local enemies = Game.battle:getActiveEnemies()
        local page = math.ceil(Game.battle.current_menu_y / 3) - 1

        local bigparty = Utils.copy(Game.battle.party, true)
        for k,v in pairs(enemies) do
        	table.insert(bigparty, v)
        end

        local max_page = math.ceil(#bigparty / 3) - 1
        local page_offset = page * 3

        love.graphics.setColor(Game:getSoulColor())
        love.graphics.draw(self.heart_sprite, 55, 30 + ((Game.battle.current_menu_y - page_offset) * 30))

        local font = Assets.getFont("main")
        love.graphics.setFont(font)

        for index = page_offset+1, math.min(page_offset+3, #bigparty) do
            love.graphics.setColor(1, 1, 1, 1)
            if bigparty[index].chara then
	            love.graphics.print(bigparty[index].chara:getName(), 80, 50 + ((index - page_offset - 1) * 30))
	        else
	        	love.graphics.print(bigparty[index].name, 80, 50 + ((index - page_offset - 1) * 30))
	        end

            love.graphics.setColor(128 / 255, 0, 0, 1)
            love.graphics.rectangle("fill", 400, 55 + ((index - page_offset - 1) * 30), 101, 16)

            if bigparty[index].chara then
	            local percentage = bigparty[index].chara.health / bigparty[index].chara:getStat("health")
	            love.graphics.setColor(0, 1, 0, 1)
	            love.graphics.rectangle("fill", 400, 55 + ((index - page_offset - 1) * 30), percentage * 101, 16)
	        else
	           	local percentage = bigparty[index].health / bigparty[index].max_health
	            love.graphics.setColor(0, 1, 0, 1)
	            love.graphics.rectangle("fill", 400, 55 + ((index - page_offset - 1) * 30), percentage * 101, 16)
	        end
	    end

        love.graphics.setColor(1, 1, 1, 1)
        if page < max_page then
            love.graphics.draw(self.arrow_sprite, 20, 120 + (math.sin(Kristal.getTime()*6) * 2))
        end
        if page > 0 then
            love.graphics.draw(self.arrow_sprite, 20, 70 - (math.sin(Kristal.getTime()*6) * 2), 0, 1, -1)
        end
    else
    	super:drawState(self)
    end
end

return BattleUI_o