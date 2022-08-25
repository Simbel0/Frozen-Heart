--TODO: remove that useless mess
return function(cutscene)
    local ending = Game:getFlag("noelle_battle_status")

    local spamton_fight = Game:getFlag("no_heal")

    if spamton_fight then
        for _, member in ipairs(Game.party) do
            Game:removePartyMember(member)
        end
        if ending == "killkill" then
            Game:addPartyMember("kris")
        elseif ending == "killspare" then
            Game:addPartyMember("kris")
            Game:addPartyMember("susie")
        elseif ending == "thorn_kill" then
            Game:addPartyMember("kris")
            Game:addPartyMember("noelle")
        elseif ending == "no_trance" then
            Game:addPartyMember("kris")
            Game:addPartyMember("susie")
            Game:addPartyMember("noelle")
        end
        cutscene:mapTransition("fountain_room")
    else
        cutscene:gotoCutscene("ending.closing_fountain")
    end
end