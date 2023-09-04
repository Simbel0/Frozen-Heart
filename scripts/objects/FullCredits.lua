local FullCredits, super = Class(Object)

function FullCredits:init()
	super:init(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	self.credits_table = {
		"by Simbel",

		"Based on",
		"DELTARUNE by Toby Fox & The DELTARUNE Team",

		"Engine",
		"Kristal - The KRISTAL Team",

		"Musics",
		"Original Deltarune OST by Toby Fox",
		"SnowGrave by Nick Nitro",
	}
end

return FullCredits