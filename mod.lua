function Mod:init()
    print("Loaded "..self.info.name.."!")
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

        local diff=Game:getFlag("difficulty", 1)
        if diff==0 then
            for i=1,4 do
                Game.inventory:addItem("lightcandy")
            end

            local tea_flavors={"susie", "noelle"}
            local tea_flavor=Utils.pick(tea_flavors)
            Game.inventory:addItem(tea_flavor.."_tea")
        elseif diff==1 then
            for i=1,3 do
                Game.inventory:addItem("lightcandy")
            end

            local tea_flavors={"kris", "susie", "ralsei", "noelle"}
            local tea_flavor=Utils.pick(tea_flavors)
            Game.inventory:addItem(tea_flavor.."_tea")
        end

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