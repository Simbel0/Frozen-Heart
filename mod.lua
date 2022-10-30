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

        if Game:getFlag("spamton_boss", nil)==nil then
            Game:setFlag("spamton_boss", false)
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

function Mod:registerDebugOptions(d)
    d:registerMenu("frozen_heart_main", "~ FROZEN HEART DEBUG ~")
    d:registerMenu("frozen_heart_ending", "~ SETTING ENDING ~")
    d:registerMenu("frozen_heart_battle", "~ BATTLE DEBUG ~")

    d:registerOption("main", "Frozen Heart", "Frozen Heart stuff", function()
        d:enterMenu("frozen_heart_main")
    end, "ALL")
    d:registerOption("frozen_heart_main", "Endings", "Set the ending", function()
        d:enterMenu("frozen_heart_ending")
    end, "OVERWORLD")
    d:registerOption("frozen_heart_main", "Battle stuff", "Modified stuff related to battle", function()
        d:enterMenu("frozen_heart_battle")
    end, "BATTLE")

    d:registerOption("frozen_heart_ending", "Spare Ending", "Get Noelle's Mercy to 100%", function()
        Game:setFlag("plot", 3)
        Game:setFlag("noelle_battle_status", "no_trance")
        Game:addPartyMember("noelle")
        Kristal.DebugSystem:closeMenu()
        Kristal.quickReload("temp")
    end, "OVERWORLD")
    d:registerOption("frozen_heart_ending", "Thorned Ending", "Get Noelle's HP to 0 due to the Thorn Ring", function()
        Game:setFlag("plot", 3)
        Game:setFlag("noelle_battle_status", "thorn_kill")
        Game.world:mapTransition("fountain_room")
        Game.world:startCutscene("ending.killing_spamton")
        Kristal.DebugSystem:closeMenu()
    end, "OVERWORLD")
    d:registerOption("frozen_heart_ending", "Soulless Spare Ending", "Spare Noelle after destroying her", function()
        Game:setFlag("plot", 3)
        Game:setFlag("noelle_battle_status", "killspare")
        Kristal.DebugSystem:closeMenu()
        Kristal.quickReload("temp")
    end, "OVERWORLD")
    d:registerOption("frozen_heart_ending", "Violent Ending", "Kill Noelle", function()
        Game:setFlag("plot", 3)
        Game:setFlag("noelle_battle_status", "killkill")
        Game.world:mapTransition("fountain_room")
        Game.world:startCutscene("ending.killing_spamton")
        Kristal.DebugSystem:closeMenu()
    end, "OVERWORLD")
    d:registerOption("frozen_heart_ending", "Spamton Ending", "Start the Spamton NEO battle", function()
        Game:setFlag("noelle_battle_status", "no_trance")
        Game:setFlag("spamton_boss", true)
        Game:addPartyMember("noelle", 3)
        Game.world:startCutscene("ending.killing_spamton", true)
        Kristal.DebugSystem:closeMenu()
    end, "OVERWORLD")

    d:registerOption("frozen_heart_main", "Change Mercy", "Set Noelle's Mercy to 99%", function()
        Game.battle.enemies[1]:addMercy(99)
    end, "BATTLE")
    d:registerOption("frozen_heart_main", "Increases Noelle's TP", "Increases Noelle's TP by 5", function()
        Game.battle.noelle_tension_bar:giveTension(5)
    end, "BATTLE")
end