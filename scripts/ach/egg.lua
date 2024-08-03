local Ach, super = Class(Achievement)
--bau bau
function Ach:init()
    super:init(self)
    
    self.name = localize("egg_text1") -- Display name

    self.iconanimated = false -- If icons should be animated, if true then the input for both icons should be a table of paths
    self.icon = "achievements/egg" -- Normal icon
    self.desc = "Get the Egg" -- Description
    self.hint = "Somewhere, a man is happy that you changed your path. He has something for you now." -- If info hidden is true then this will show up in place of description, used for hints
    self.hidden = true -- Doesn't show up in the menu if not collected
    self.rarity = "Legendary" -- An indicator on how difficult this achievement is. "Common", "Uncommon", "Rare", "Epic" "Legendary", "Unique", "Impossible"
    self.completion = false -- Shows a percent indicator if true, shows x/int if an integer, nothing if false.
    self.index = 7 -- Order in which the achievements will show up on the menu.
end

return Ach