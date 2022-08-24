local Vending_Machine, super = Class(Interactable)

function Vending_Machine:init(data)
    super:init(self, data.x, data.y, nil, nil, data.properties)

    properties = data.properties or {}

    self.item = properties["item"] or "cd_bagel"

    self.itemname = properties["itemname"] or Registry.createItem(self.item):getName()

    self.price = properties["price"] or 120

    self.text = properties["text"] or "* (It's a machine that sells refreshments.)\n* (1 "..self.itemname.." is $"..self.price..". Buy?)"

    self.solid = true

    self:setOrigin(0.5, 1)
    self:setSprite("world/events/vending_machine")
end

function Vending_Machine:getDebugInfo()
    local info = super:getDebugInfo(self)
    table.insert(info, "Item: "..self.item)
    table.insert(info, "Price: "..self.price)
    return info
end

function Vending_Machine:onInteract(player, dir)
    cutscene = self.world:startCutscene(function(c)
        local text = self.text
        c:showShop()
        c:text(text)
        c:choicer({"Yes", "No"})
        if c.choice==1 then
            if Game.money<self.price then
                c:text("* (You didn't have enough money. Which[wait:1], is surprising.)")
            else
                local item=self.item
                if type(self.item) == "string" then
                    item = Registry.createItem(self.item)
                end
                local success, result_text = Game.inventory:tryGiveItem(item)
                if success then
                    Game.money = Game.money - self.price
                end
                c:text(result_text)
            end
        end
        c:hideShop()
    end)
    return true
end

return Vending_Machine