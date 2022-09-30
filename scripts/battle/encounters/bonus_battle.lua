local Bonus_Battle, super = Class(Encounter)

function Bonus_Battle:init()
    super:init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* ..."

    self.mode = Game:getFlag("noelle_battle_status")
    Game:setFlag("first_pipis", true)

    -- Battle music ("battle" is rude buster)
    self.music = nil
    -- Enables the purple grid battle background
    self.background = false

    self.default_xactions = false

    --Game.battle.use_textbox_timer = false
    self.phase = 1  -- 1:Normal Battle
                    -- 2:Aftermatch

    self.sneo=self:addEnemy("Spamton_NEO", 525, 240)

    Game.battle:registerXAction("susie", "Snap", nil)
    Game.battle:registerXAction("noelle", "Snap", nil)
end

function Bonus_Battle:update()
    if self.funnycheat and self.funnycheat>=5 and not self.cheater then
        self.cheater = true
        Game.battle.timer:tween(0.2, self.sneo.sprite:getPart("head").sprite, {color={1, 0, 0}})
        Assets.playSound("snd_carhonk")
        Game.battle.timer:everyInstant(0.6, function()
            Game.battle.timer:tween(0.25, self.sneo.sprite:getPart("head").sprite, {scale_x=2, scale_y=2}, "linear", function()
                Game.battle.timer:tween(0.25, self.sneo.sprite:getPart("head").sprite, {scale_x=1, scale_y=1})
            end)
        end, 1)
    end
end

function Bonus_Battle:onBattleStart()
    if spamtonMusic and spamtonMusic:isPlaying() then
        Game.battle.music=spamtonMusic
    else
        Game.battle.music:play("SnowGrave NEO", 0.5, 1)
    end
    Game.world:getEvent(2).adjust=3
    Game.battle.party[2].chara.stats["health"]=190
    Game.battle.party[2].chara.health=190
    Game.battle.party[2].chara.stats["attack"]=18
    Game.battle.party[2].chara.stats["defense"]=2
    Game.battle.party[2].chara.stats["magic"]=3
end

function Bonus_Battle:getDialogueCutscene()
    if self.sneo.health<=2400 and self.phase==1 then
        self.phase=2
        self.sneo.text={
            "* Spamton NEO smiles victoriously.",
            "* Spamton waits for you to take the deal.",
            "* Susie tries to tell you something, but Spamton threaten to fire a pipis at her."
        }
        self.sneo.acts={}
        self.sneo.waves={
            "bonus/deal"
        }
        self.sneo:registerAct("Deal", "Negociate\nthe deal")
        self.sneo:registerAct("HealDeal", "Negociate\nand heal", nil, 10)
        Game.battle.music:fade(0, 1.5)
        return function(c)
            c:wait(2.5)
            c:battlerText(self.sneo, "SO THAT'S HOW\nIT IS")
            c:battlerText(self.sneo, "EVEN AFTER MY [Final\nMessage], YOU STILL\nWON'T [Take The Deal]")
            c:battlerText(self.sneo, "KRIS, I ALWAYS\nTHOUGHT OF YOU AS\nA [Value Customer]")
            c:battlerText(self.sneo, "SO IT REALLY [Burns!!]\nTHAT WE HAVE TO COME\nTO THIS.")
            c:battlerText(self.sneo, "KRIS. LET ME TELL\nYOU A SECRET")
            c:wait(3)
            Game.battle.party[2]:hurt(999)
            Game.battle.party[3]:hurt(999)
            c:wait(1)
            Game.battle.music:play("Deal Gone Wrong", 1, 1)
            c:battlerText(self.sneo, "YOU SHOULD HAVE\nGONE FOR THE [Pipis]!!")
            c:battlerText(self.sneo, "AND NOW KRIS")
            c:battlerText(self.sneo, "NO MORE [Deal] NOR\n[Harem] TO COME TO SAVE YOU")
            c:battlerText(self.sneo, "GIVE ME YOUR\n[HeartShapedObject]")
            c:battlerText(self.sneo, "IT'LL BENEFIT [You&me]\nIN THE END")
            c:text("* (You think it would be wise not to use your [color:yellow]ITEM[color:reset]s. Spamton would notice it immedialtely.)")
        end
    end
end

function Bonus_Battle:createSoul(x, y)
    return YellowSoul(x, y)
end

return Bonus_Battle