local Spamton_NEO, super = Class(EnemyBattler)

function Spamton_NEO:init()
    super:init(self)

    -- Enemy name
    self.name = "Spamton NEO"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("spamtonneo")
    self.sprite:setStringCount(6)

    local wl = self.sprite:getPart("wing_l")
    local wr = self.sprite:getPart("wing_r")

    wl.sprite.frozen = true
    wl.sprite.freeze_progress = 1
    wl.swing_speed = 0
    wr.sprite.frozen = true
    wr.sprite.freeze_progress = 1
    wr.swing_speed = 0

    -- Enemy health
    self.max_health = 4809*50
    self.health = 278*30
    -- Enemy attack (determines bullet damage)
    self.attack = 13
    -- Enemy defense (usually 0)
    self.defense = -27*2
    -- Enemy reward
    self.money = 0

    self.dialogue_advance = 0

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0

    self.tired_percentage = 0

    self.disable_mercy = true

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "bonus/test",
        "bonus/phoneRing",
        "bonus/protectedCrew",
        "bonus/rainPipis",
        "bonus/you've_got_mail",
        "bonus/pistonTrap"
    }
    self.current_id = 0
    self.wave_loop = 1
    self.no_no_wave = nil

    -- Dialogues Spamton might say depending on the selected wave
    self.waves_dialogues = {
        {"LOOK AT THOSE [Flying Heads]\nCOMING TO [!$#!] YOU!!!", "SAY [Hello] TO\nMY [Beautiful] FACE!!"},
        {{
            "YOU DON'T NEED TO\n[Feeling Unsafe] KRIS!!",
            "JUST PICK UP\nTHE [Phone]!!!"
        }, "CAN YOU HEAR IT\n[Ring, Ring]??!"},
        {{"DO NOT WORRY ABOUT\nTHIS [Deal] KRIS!!", "IT IS NOW PROTECTED WITH\n[Certified Protection Ⓒ 1997]"}, "[Enjoy Full Time Protection\nWith] FLYING HEADS!!"},
        {"[Hoochi Mama]!! I HAVE\nA [Gift] FOR YOU!!!", "CAN YOU FEEL\n[Wipe My Save]??"},
        {"KRIS, LOOK AT THOSE [E-Mail Guy]\nREVIEW JUST FOR YOU!!", "I HAVE A [$!$#]\nLETTER FOR YOU!!"},
        {{"KRIS, DO YOU\nFEEL [Trap]?","THEN PLEASE\nSHOOT FOR THE [Deal]"}, "WE CAN FREE OURSELVES\nFROM THOSE [Vulnerable Walls]!!"},
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "ENL4RGE\nYOURSELF",
        "help",
        "GO [die]",
        "BUY YOUR [Ice Scream]\nSOMEWHERE ELSE!!",
        "CLOWN?? NO, THAT\nMAKES ME SICK!!",
        "LET's MAKE\nA DEAL!!"
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "13 ATK 98 DEF\n* His armor is falling apart with him."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Spamton noticed there is no audience.",
        "* Spamton laughs in a broken way.",
        "* It's cold.",
        "* Spamton's armor is freezing.",
        "* Spamton is freezing.",
        --"* Proceed.",
        "* The air crackles with freedom.",
        --"* The stage lights are frozen.",
        "* It pulls the strings and makes them ring.",
        --"* Raise your hands and make them shut up.",
        "* Spamton feels the cold breeze as he takes a ride around town.[wait:10]\n* He hates it.",
        "* Spamton believes in you.[wait:10]\n* Probably not.",
    }

    self.deal = 0

    self:registerAct("X-Slash", "Physical\nDamage", nil, 15)
    --self:registerAct("Red Buster", "Red\nDamages", {"susie"}, 60)
    --self:registerAct("DualHeal", "Heals\neveryone", {"noelle"}, 50)
    self:registerAct("Snap", nil)
    self:registerAct("SnapAll", nil, {"susie", "noelle"})
end

function Spamton_NEO:selectWave()
    print("Do not take this wave: "..(self.no_no_wave and self.no_no_wave or "None"))
    if self.encounter.phase == 2 and self.encounter.item_used then
        self.encounter.item_used = false
        self.selected_wave = "bonus/take_down"
        return "bonus/take_down"
    end

    if self.nb_wave then
        self.selected_wave = self.waves[self.nb_wave]
        self.no_no_wave = self.selected_wave
        self.nb_wave = nil
        print("Selected wave: "..self.selected_wave)
        return self.selected_wave
    end

    self.current_id = self.current_id + 1
    if self.current_id>#self.waves then
        self.current_id = 1
        self.wave_loop = self.wave_loop + 1
    end
    if self.wave_loop == 1 then
        self.selected_wave = self.waves[self.current_id]
        print("Selected wave: "..self.selected_wave)
        return self.waves[self.current_id]
    end
    local wave = super:selectWave(self)
    if self.encounter.phase==1 then
        while wave==self.no_no_wave do
            wave = super:selectWave(self)
        end
    end
    self.no_no_wave = wave
    print("Selected wave: "..wave)
    return wave
end

function Spamton_NEO:onAct(battler, name)
    if name == "Check" then
        return {
            "* SPAMTON NEO - 14 ATK 32 DEF\n* His armor is falling apart with him.",
            "* His \"[color:blue]bluelight specil[color:reset]\" has been damaged, lowering his defense and restoring his attack."
        }
    elseif name == "X-Slash" then
        Game.battle.timer:everyInstant(0.5, function()
            battler:setAnimation("battle/attack")
            Assets.playSound("scytheburst")
            self:hurt(75, battler)
            local afIm = AfterImage(battler.sprite, 1)
            afIm.physics = {
                speed_x = 3,
                direction = 2*math.pi
            }
            battler:addChild(afIm)
        end, 2)
        return "* Kris uses X-Slash!"
    elseif name == "Snap" then
        self.sprite:snapString()
        Assets.playSound("damage")
        self:hurt(love.math.random(55, 155), battler)
        return "* "..battler.chara.name.." snapped a wire!"
    elseif name == "SnapAll" then
        self.sprite:snapStrings(love.math.random(2, 4))
        Assets.playSound("damage")
        self:hurt(Utils.round(love.math.random(55, 155)*3.5), battler)
        return "* Everyone snapped wires!"
    elseif name == "Deal" or name == "HealDeal" then
        if name == "HealDeal" then
            battler:heal(80)
        end
        self.deal = self.deal + 1
        if self.deal == 1 then
            self.dialogue_override = {
                "[Interested In This\nAmazing] DEAL, KRIS??",
                "THE [Terms And Conditions]\nARE VERY SIMPLE",
                "YOU GIVE ME YOUR\n[HeartShapedObject]",
                "AND I GIVE YOU\n[Hyperlink Blocked]\nIN RETURN",
                "YOU HAVE NO REASON TO\n[Unsign Copy] KRIS!! THIS IS\nTHE [Honestest] DEAL EVER\nMADE!!!!"
            }
            return "* You ask Spamton about the details of the deal."
        elseif self.deal == 2 then
            self.dialogue_override = {
                "I SEE NO [Loophole] IN\nTHIS [Contract], KRIS",
                "NORMALLY, I WOULD BE MAD\nAT YOU FOR JUDGING MY\n[HonestMan] SKILLS",
                "BUT SINCE IT's yoU KRIS,\nI WILL LISTEN TO YOUR\n[Complaint]!!",
                "TELL ME... WHAT IS [@$!$]\nWITH MY [Sweet, Sweet] DEAL??"
            }
            return "* You tell Spamton that the deal cannot go as well as he makes it sound."
        elseif self.deal == 3 then
            self.dialogue_override = {
                "[Priority: High]\nYOU SAY?",
                "KRIS. I TOLD YOU\nTHERE WAS NO\n[Loophole]!",
                "WE SHARE THE SAME.\nGOAL, DON't we?",
                "TOGETHER, WE WANT TO\nREACH [Heaven] AND SNAP\nTHE [Silly Strings]!!",
                "AND IF WE HAVE TO\n[2 in 1] TO DO SO,\nSO BE IT!!!",
                "YOU ALWAYS MUST SACRIFICE\nFOR [Salvation]."
            }
            return "* You inform Spamton that what he seeks are crucial for Lightners."
        elseif self.deal == 4 then
            self.dialogue_override = {
                "I UNDERSTAND YOUR\n[Fear Meter] KRIS",
                "AND KRIS... I CAN'T\nFORCE YOU.",
                "BUT COMPARE THE [Good]\nAND THE [Bad] AND SEE",
                "YOUR [Flesh And Bones]\nAGAINST ABSOLUTE\n[Hyperlink Blocked]",
                "THE POWER TO BE\nA [Big Shot]...",
                "WELL ISN4T IT\nWORTH A [Shot]??"
            }
            return "* You tell Spamton you don't want to be one with him."
        elseif self.deal == 5 then
            self.dialogue_override = {
                "KRIS????",
                "ARE YOU GETTING\n[Desperate]?",
                "[You Are On The Fastest\nAvailable Route] TO [Heaven]\nKRIS!!",
                "YOU DON'T HAVE TO RELY\nON YOUR [Friends] ANYMORE!!",
                "THEY WILL BETRAY\nYOU ANYWAY..."
            }
            return {
                "* You call for help.",
                "* .[wait:10].[wait:10].",
                "* ..But nobody came."
            }
        else
            return {
                "* You call for help.",
                "* .[wait:10].[wait:10].",
                "* ..But nobody came."
            }
        end
    --elseif name == "Red Buster" then
    --    Game.battle:powerAct("red_buster", battler, "susie", self)
    --elseif name == "Dual Heal" then
    --    Game.battle:powerAct("dual_heal", battler, "noelle", self)
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super:onAct(self, battler, name)
end

function Spamton_NEO:getEnemyDialogue()
    print(self.health)
    self.dialogue_advance = self.dialogue_advance+1
    local d    = self.dialogue_advance
    local mode = self.encounter.mode

    if self.encounter.phase==2 and self.encounter.item_used then
        return {
            "DID YOU REALLY THINK\nI WOULDN'T NOTICE YOU\nUSING YOUR [Inventorium]???",
            "IT'S A DISCUSSION\nBETWEEN [HonestMan], NOT\n[Friends]!!"
        }
    end

    if mode=="no_trance" then
        if d==1 then
            return {
                "WELL LOOK WHAT\nTHE [Element 6]\nDRAGGED IN!!",
                "CONGRATULATIONS KRIS!!\nYOUR FRIENDS\nANSWERED THE [Phone]!",
                "AND JUST LIKE THAT,\nYOU LET YOUR GOOD OLD\nFRIEND SPAMTON IN\nTHE [Dumpster]",
                "[func:setAllPartsShaking, 1]YOU'RE SO [$!#@]!!\nYOU REALLY MAKE ME SICK!!!"
            }
        elseif d==2 then
            return {
                "WHY WOULD YOU DO\nTHAT TO ME KRIS??",
                "WE COULD HAVE BEEN [Partnership]!\n[[Friend Request Accepted]]!!"
            }
        elseif d==3 then
            return {
                "WE COULD HAVE REIGN\nOVER MY NEW\n[World] TOGETHER",
                "AFTER ALL YOU'RE\nTHE ONE WHO HELPED ME\nGETTING HERE!"
            }
        elseif d==4 then
            return {
                "SO WHY KRIS?",
                "WHY?\nWHY?\nWHY?\nWHY?\nWHY?\nWHY?\nWHY?\nWHY?\nWHY?\nWHY?\nWHY?\nWHY?\nWHY?\nWHY?\nWHY?\nWHY?\nWHY?\nWHY?\nWHY?\nWHY?",
                "...[wait:2]Why did you\nleave me behind\ntoo...?"
            }
        elseif d==5 then
            return {
                "ARE YOU [Afraid]?",
                "PLEASE [Be Not Afraid]\nKRIS",
                "DON\"t FORGET I'M A [HonestMan]",
            }
        elseif d==6 then
            return {
                "PERHAPS WE COULD\nFIND ANOTH3R [Deal]?",
                "MAYBE WE CAN FIND\nYOUR FRIENDS A PLACE TO\nSTAY IN OUR NEW\n[World]!!"
            }
        elseif d==7 then
            return {
                "DOESn4T IT SOUND\n[Satisfied or\nSatisfied]??",
                "YOU'LL STILL HAVE [Mean Girl],\n[Hoochi Mama] and [Frozen Chicken]\nALONGSIDE YOU!!",
                "WELL MAYBE NOT\nTHE [3rd] ONE"
            }
        elseif d==8 then
            return {
                "MAYBE WE CAN MAKE THE\n[Miracle] HAPPEN AFTER ALL,\nKRIS!!",
                "THE [Voices] OF [Heaven] WILL\nHEAR US AT LAST",
                "AND TOGETHER, WE'LL\nBE [BIG SHOT!!!!]"
            }
        elseif d==9 then
            return {
                "SO THAT'S A [Please! Please get\nout of my room! I swear\nI'll-], I SUPPOSE?",
                "YOU DON'T KNOW WHAT\nYOU'RE [Missing Out] KRIS!!",
                "YOU DON'T KNOW..."
            }
        elseif d==10 then
            return {
                "ALL THE [Deals],\nTHE [Hyperlink Blocked]",
                "ALL OFFER ON A SILVER\nPLATE WHILE WE TAKE\nA DIVE INTO [Do Not\nContain Liquid Acid]"
            }
        elseif d==11 then
            return {
                "KRIS WHY DO WANT TO\nSEAL THAT [Fountain] SO\nMUCH??!!!",
                "IN THE [Buisiness],\nTHERE'S NO SUCH THING\nAS [Lonely Wolf]"
            }
        elseif d==12 then
            return {
                "IF YOU [Pave Your Path]\nALONE, KRIS",
                "YOU WILL LOSE EVERYTHING..."
            }
        elseif d==13 then
            return {
                "[Friends] WILL GO\nDOWN THE [Drain]\n[Drain]",
                "THE [World] WILL FORGET\nABOUT YOU AND YOUR\nSWEET [Deals]",
                "AND YOU'LL LIVE IN A\n[Garbage Can] FOR YOUR [One-Time\nOnly] LIFE"
            }
        elseif d==14 then
            return {
                "KRIS, DO YOU REALLY...",
                "DO YOU REALLY WANT TO\nBE A [Little Sponge]??"
            }
        end
    end

    if self.encounter.phase==1 and Utils.random()<0.5 then
        self.nb_wave = love.math.random(#self.waves)
        if self.waves[self.nb_wave]~=self.no_no_wave then
            return self.waves_dialogues[self.nb_wave][love.math.random(1, 2)]
        else
            self.nb_wave = nil
        end
    end
    return super:getEnemyDialogue(self)
end

function Spamton_NEO:getAttackDamage(damage, battler, points)
    if damage == 0 then
        damage = super:getAttackDamage(self, damage, battler, points)
    end
    if damage>0 then
        return Utils.round(Utils.clampMap(damage, 0, ((battler.chara:getStat("attack") * 150) / 20) - (self.defense * 3), 0, 75))
    end
    return 0
end

return Spamton_NEO