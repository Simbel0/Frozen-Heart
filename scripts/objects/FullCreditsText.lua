local FullCredits, super = Class(Object)

function FullCredits:init(logo)
	super:init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	self.logo = logo

	self.credits_table = {
		"Based on",
		"DELTARUNE - Toby Fox & The DELTARUNE Team",

		"Kristal Engine v0.8.1",
		"Nyakorita - Lead Developer",
		"SylviBlossom - Lead Developer",
		"Vitellary - Lead Developer",
		"Agent7 - GitHub Contributor",
		"Archie-osu - GitHub Contributor",
		"Dobby233Liu - GitHub Contributor",
		"Luna - GitHub Contributor",
		"prokube - GitHub Contributor",
		"AcousticJamm - GitHub Contributor",
		"Simbel - GitHub Contributor",

		"Musics",
		"Flasback Excerpt - Toby Fox",
		"Lost Girl - Toby Fox",
		"mus_mysteriousroom2 - Toby Fox",
		"SnowGrave - Nick Nitro",
		"Until Next Time - Toby Fox",
		"Astrogirl - Tsukumo Sana",
		"Astrogirl (Music Box) - R3 Music Box",
		"SnowGrave NEO - ShinkoNet",
		"Deal Gone Wrong - Toby Fox",
		"Deal Gone Wrong (Orchestral) - FAYNALY",
		"GALLERY - Toby Fox",
		"Freezing Burns - BonwtrixARTS",
		"Warm Memories - Glazko (Razor Xo)",
		"A Cold World - ToxicFlame",

		"Sprites",
		"Deltarune sprites - The DELTARUNE Team",
		"Dess sprite & design - HUECYCLES",
		"Original sprites - Simbel",
		"Frozen Heart Logo - Soup Taels",

		"Libraries",
		"Queen Library - Sylvi, Vitellary",
		"Hangplug Library - Sylvi",
		"Spamton NEO Library - Vitellary",
		"Yellow Soul Library - Vitellary",
		"Particle System Library - Vitellary",
		"Vending Machine Library - Simbel",
		"Achievements Library - AcousticJamm, BrendaK7200, SciSpaceProductions",

		"",
		"w/Betatesters",
		"Racckoon",
		"OctoBox",
		"Glavvrach",

		"",
		"w/Special Thanks",
		"The Kristal Discord server for their help and feedbacks",
		"RhenaudTheLukark for creating Create Your Frisk and Create Your Kris,",
		"the engine first used for Frozen Heart.",
		"The people who waited for Frozen Heart for 2 years.",
		"You. For playing my small fangame.",

		"",
		"",
		"",

		"Thank you for playing Frozen Heart.",
		"Thank you if you have supported Frozen Heart",
		"during its two years of devlopment.",
		"I still think it's way too long for a small fangame like this one.",
		"But you have continued to show support nonetheless",
		"and for this alone, thank you.",
		"I hope it was worth it.",

		"",
		"",
		"",
		"",
		"",
		"",

		"You have unlocked the extras.",
		"See you soon.",
		"-Simbel"
	}

	self.music = Music("fullcredits")
	self.music.source:setLooping(false)

	self.full_mode = true

	self.in_category = false

	self.spacing = 60

	self.text_y = SCREEN_HEIGHT

	self.ended = false

	self.font = Assets.getFont("main_mono", 16)
end

function FullCredits:draw()
	super:draw(self)
	self.full_mode = false
	love.graphics.setFont(self.font)

	if self.text_y > -2026 then
		self.logo.y = self.logo.y - DTMULT
		self.text_y = self.text_y - DTMULT
	else
		self.ended = true
	end

	local add = 0
	for i,str in ipairs(self.credits_table) do
		local width = self.font:getWidth(str)

		if not self.full_mode then
			if str:find("-") then
				love.graphics.setColor(1, 1, 1)
				if i < #self.credits_table and not self.credits_table[i+1]:find("-") then
					self.double_spacing = true
				end
			else
				love.graphics.setColor(1, 1, 0)
				self.double_spacing = false
			end

			if str == "Vending Machine Library - Simbel" then
				self.full_mode = true
				self.double_spacing = false
			end
		else
			if Utils.startsWith(str, "w/") then
				love.graphics.setColor(1, 1, 0)
				str = str:sub(3, -1)
			else
				love.graphics.setColor(1, 1, 1)
			end
		end

		add = add + self.spacing/2

		love.graphics.printf(str, (SCREEN_WIDTH/2)-width/2, self.text_y+add, width, "center")

		if self.double_spacing then
			add = add + self.spacing/2
		end
	end
end

return FullCredits