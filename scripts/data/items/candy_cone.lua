-- Instead of Item, create a HealItem, a convenient class for consumable healing items
local item, super = Class(HealItem, "candy_cone")

function item:init()
    super:init(self)

    -- Display name
    self.name = "CandyCone"
    -- Name displayed when used in battle (optional)
    self.use_name = "Cotton Candy Cone"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Healing\nvaries"
    -- Shop description
    self.shop = "The cone of a cotton candy"
    -- Menu description
    self.description = "The logical remain of a cotton candy.\nWho could eat that? +??HP"

    -- Amount healed (HealItem variable)
    self.heal_amount = 1

    -- Default shop price (sell price is halved)
    self.price = 1
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {}
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions (key = party member id)
    self.reactions = {
        kris = {
            ralsei = "Kris ate that strangely easily...",
            susie = "That's great!",
            noelle = "Kr-Kris?? What are you doing??"
        },
        susie = {
            susie = "It stills smells like candy!",
            noelle = "(She... ate that like it was nothing!)"
        },
        ralsei = "Wh-Why am I eating plastic...?",
        noelle = "(I-If it's for Susie...)",
    }

    self.world_heal_amounts = {
        susie = 110,
        noelle = 5,
        ralsei = 1,
        kris = 1
    }

    self.battle_heal_amounts = {
        susie = 110,
        noelle = 20,
        ralsei = 10,
        kris = 10
    }
end

return item