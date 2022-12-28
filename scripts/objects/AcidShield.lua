local AcidShield, super = Class(Object)

function AcidShield:init(size)
	super:init(self, 0, 0)

	self.sheild_top = Assets.getTexture("shield/shield_top")
	self.sheild_top_hurt = Assets.getTexture("shield/shield_top_hurt")
	self.sheild_middle = Assets.getTexture("shield/shield_middle")
	self.sheild_middle_hurt = Assets.getTexture("shield/shield_middle_hurt")
	self.sheild_bottom = Assets.getTexture("shield/shield_bottom")
	self.sheild_bottom_hurt = Assets.getTexture("shield/shield_bottom_hurt")
end