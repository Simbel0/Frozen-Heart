local Ach, super = Class(Achievement)

function Ach:init()
    super:init(self)
    
    self.name = localize("violentspare_text1") -- Display name

    self.iconanimated = false -- If icons should be animated, if true then the input for both icons should be a table of paths
    self.icon = "achievements/mercykill" -- Normal icon
    self.desc = "Get the Violent Sparing Ending" -- Description
    self.hint = nil -- If info hidden is true then this will show up in place of description, used for hints
    self.hidden = false -- Doesn't show up in the menu if not collected
    self.rarity = "Uncommon" -- An indicator on how difficult this achievement is. "Common", "Uncommon", "Rare", "Epic" "Legendary", "Unique", "Impossible"
    self.completion = false -- Shows a percent indicator if true, shows x/int if an integer, nothing if false.
    self.index = 3 -- Order in which the achievements will show up on the menu.
end

return Ach