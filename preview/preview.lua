local preview = {}

preview.hide_background = true

function preview:init(mod, _, menu)
	self.bg = love.graphics.newImage(mod.path.."/preview/room.png")
	self.moon = love.graphics.newImage(mod.path.."/preview/room_moon.png")
	self.overlay = love.graphics.newImage(mod.path.."/preview/blackthingything.png")

	self.noelle_1 = love.graphics.newImage(mod.path.."/preview/noelle_look_afar.png")
	self.noelle_2 = love.graphics.newImage(mod.path.."/preview/noelle_look_player.png")
	self.noelle_3 = love.graphics.newImage(mod.path.."/preview/noelle_look_shocked.png")

	self.menu = menu

	self.show_noelle = not Kristal.Config["extras"]
	self.pitch = self.show_noelle and 0.9 or 0.8
end

function preview:update() end

function preview:draw()
	if self.menu.music.pitch ~= self.pitch then
		self.menu.music:setPitch(self.pitch)
	end

	love.graphics.setColor(27/255, 27/255, 42/255, self.fade)
	love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	love.graphics.setColor(1, 1, 1, self.fade)
	love.graphics.draw(self.moon, -329, 0)
	love.graphics.draw(self.bg, -329, 0)

	if self.show_noelle then
		local noelle = self.noelle_1
		local offset = 0
		if self.menu.state == "FILESELECT" then
			offset = 6
			noelle = self.noelle_2
			if self.menu.files and self.menu.files.focused_button then
				noelle = self.noelle_3
			end 
		end
		love.graphics.draw(noelle, (SCREEN_WIDTH/2)-self.noelle_1:getWidth()+offset, 130, 0, 2, 2)
	end

	love.graphics.setColor(1, 1, 1, self.fade-0.3)
	love.graphics.draw(self.overlay)
end

return preview