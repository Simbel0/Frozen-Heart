local Spelling, super = Class(Wave)

function Spelling:init()
	super:init(self)

	self.time = 10

	self.words = {
		"SMART",
		"DECEMBER",
		"ICE",
		"ANGEL",
		"BULLET",
		"HYPOTHERMIA",
		"LETITGO",
		"SUBZERO",
		"HEAVEN",
		"DEATH",
		"ICEBREAKER"
	}

	self.font = Assets.getFont("main_mono")
end

function Spelling:onStart()
	self.timer:everyInstant(2, function()
		local word = Utils.pick(self.words)
		local letters = {}
		for i=1,utf8.len(word) do
			table.insert(letters, Utils.sub(word, i, i))
		end

		for i,letter in ipairs(letters) do
			self:spawnBullet("secret/memories/letter", letter, Utils.random(Game.battle.arena.left, Game.battle.arena.right), Utils.random(Game.battle.arena.top, Game.battle.arena.bottom), self.font)
		end
	end)
end

return Spelling