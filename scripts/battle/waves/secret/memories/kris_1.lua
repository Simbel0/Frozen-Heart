local MusicSheet, super = Class(Wave)

function MusicSheet:init()
	super:init(self)

	self.time = 10

	self.lines_pos = {0, 0, 0}

	self.music_start = false
	self.dir = "down"
end

function MusicSheet:onStart()
	self.lines_pos = {
		(Game.battle.arena.top+Game.battle.arena.width/2)+10,--Game.battle.arena.top+10,
		Game.battle.arena.top+Game.battle.arena.width/2,
		(Game.battle.arena.top+Game.battle.arena.width/2)-10--Game.battle.arena.bottom-10
	}
	self.timer:after(0.75, function()
		self.timer:tween(0.75, self, {lines_pos={
			Game.battle.arena.top+10,
			Game.battle.arena.top+Game.battle.arena.width/2,
			Game.battle.arena.bottom-10
		}}, "out-cubic", function()
			self.timer:after(0.25, function()
				self.music_start = true
			end)
		end)
	end)
	self.timer:every(1, function()
		self:spawnBullet("secret/memories/music_note", love.math.random(1, 3), math.rad(180), 6)
	end)
end

function MusicSheet:update()

	if self.music_start then
		if self.dir == "down" then
			self.lines_pos[1] = self.lines_pos[1] + 3*DTMULT
			self.lines_pos[3] = self.lines_pos[3] - 3*DTMULT
			if self.lines_pos[1] >= Game.battle.arena.bottom-10 then
				self.dir = "up"
			end
		elseif self.dir == "up" then
			self.lines_pos[1] = self.lines_pos[1] - 3*DTMULT
			self.lines_pos[3] = self.lines_pos[3] + 3*DTMULT
			if self.lines_pos[1] <= Game.battle.arena.top+10 then
				self.dir = "down"
			end
		end
	end

	super:update(self)
end

function MusicSheet:draw()
	super:draw(self)
	love.graphics.setLineWidth(1)
	for i=1,3 do
		love.graphics.line(0, self.lines_pos[i], SCREEN_WIDTH, self.lines_pos[i])
	end
end

return MusicSheet