function Mod:init()
    print("Loaded "..self.info.name.."!")

    self.kristal_ids = {
        item={
            "dark_candy",
            "revivemint",
            "glowshard",
            "manual",
            nil,
            "top_cake",
            "spincake",
            "darkburger",
            "lancercookie",
            "gigasalad",
            "clubssandwich",
            "heartsdonut",
            "chocdiamond",
            "favwich",
            "rouxlsroux",
            "cd_bagel",
            "mannequin",
            "kris_tea",
            "noelle_tea",
            "ralsei_tea",
            "susie_tea",
            "dd_burger",
            "lightcandy",
            "butjuice",
            "spagetticode",
            "javacookie",
            "tensionbit",
            "tensiongem",
            "tensionmax",
            "revivedust",
            "revivebrite",
            "s_poison",
            "dogdollar"
        },
        weapon={
            "wood_blade",
            "mane_ax",
            "red_scarf",
            "everybodyweapon",
            "spookysword",
            "brave_ax",
            "devilsknife",
            "trefoil",
            "ragger",
            "daintyscarf",
            "twistedswd",
            "snowring",
            "thornring",
            "bounceblade",
            "cheerscarf",
            "mechasaber",
            "autoaxe",
            "fiberscarf",
            "ragger2",
            "brokenswd",
            "puppetscarf",
            "freezering"
        },
        armor={
            "amber_card",
            "dice_brace",
            "pink_ribbon",
            "white_ribbon",
            "ironshackle",
            "mousetoken",
            "jevilstail",
            "silver_card",
            "twinribbon",
            "glowwrist",
            "chainmail",
            "bshotbowtie",
            "spikeband",
            "silver_watch",
            "tensionbow",
            "mannequin",
            "darkgoldband",
            "skymantle",
            "spikeshackle",
            "frayedbowtie",
            "dealmaker",
            "royalpin"
        }
    }

end

function Mod:postInit(newfile)
    if newfile then
        if not Game:getFlag("plot", nil) then
            Game:setFlag("plot", 0)
        end
        if not Game:getFlag("difficulty", nil) then
            Game:setFlag("difficulty", 1)
        end

        if Game:getFlag("no_heal", nil)==nil then
            Game:setFlag("no_heal", true)
        end
        if Game:getFlag("no_hit", nil)==nil then
            Game:setFlag("no_hit", true)
        end

        local diff=Game:getFlag("difficulty", 1)
        if diff==0 then
            for i=1,4 do
                Game.inventory:addItem("lightcandy")
            end
            Game.inventory:addItem("candy_cone")

            local tea_flavors={"susie", "noelle"}
            local tea_flavor=Utils.pick(tea_flavors)
            Game.inventory:addItem(tea_flavor.."_tea")
        elseif diff==1 then
            for i=1,3 do
                Game.inventory:addItem("lightcandy")
            end
            Game.inventory:addItem("candy_cone")

            local tea_flavors={"kris", "susie", "ralsei", "noelle"}
            local tea_flavor=Utils.pick(tea_flavors)
            Game.inventory:addItem(tea_flavor.."_tea")
        end

        Game.inventory:removeItem("cell_phone")

        Game.world:startCutscene("TEST_DOGUNCHECK")
    end
end

function Mod:load(data, newfile, index)
    print("Loading")
    print(Game:getFlag("plot", 0)==2, Game:getFlag("noelle_battle_status", nil)==nil)
    if Game:getFlag("plot", 0)==2 and Game:getFlag("noelle_battle_status", nil)==nil then
        print("Start the quick intro")
        if not Game.battle then
            Game.world:startCutscene("intro.quickintro")
        end
    end
end

function Mod:getKristalID(id, type)
    return self.kristal_ids[type][id]
end