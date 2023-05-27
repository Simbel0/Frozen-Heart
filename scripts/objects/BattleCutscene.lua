local BattleCutscene, super = Class("BattleCutscene", true)

local function waitForSpecialTextbox(self) return not self.textbox or self.textbox:isDone() end
function BattleCutscene:textSpecial(text, portrait, actor, options)
    if type(actor) == "table" and not isClass(actor) then
        options = actor
        actor = nil
    end
    if type(portrait) == "table" then
        options = portrait
        portrait = nil
    end

    options = options or {}

    if self.textbox then
        self.textbox:remove()
    end

    if self.choicebox then
        self.choicebox:remove()
        self.choicebox = nil
    end

    local width, height = 529, 103
    if Game:isLight() then
        width, height = 530, 104
    end

    self.textbox = Textbox(56, 344, width, height)
    self.textbox.layer = BATTLE_LAYERS["top"] + 10
    Game.battle:addChild(self.textbox)
    self.textbox:setParallax(0, 0)

    local speaker = self.textbox_speaker
    if not speaker and isClass(actor) and actor:includes(Character) then
        speaker = actor.sprite
    end

    if options["talk"] ~= false then
        self.textbox.text.talk_sprite = speaker
    end

    actor = actor or self.textbox_actor
    if isClass(actor) and actor:includes(Character) then
        actor = actor.actor
    end
    if actor then
        self.textbox:setActor(actor)
    end

    self.textbox_top = false

    self.textbox.active = true
    self.textbox.visible = true
    self.textbox:setFace(portrait, options["x"], options["y"])

    if options["reactions"] then
        for id,react in pairs(options["reactions"]) do
            self.textbox:addReaction(id, react[1], react[2], react[3], react[4], react[5])
        end
    end

    if options["functions"] then
        for id,func in pairs(options["functions"]) do
            self.textbox:addFunction(id, func)
        end
    end

    if options["font"] then
        if type(options["font"]) == "table" then
            -- {font, size}
            self.textbox:setFont(options["font"][1], options["font"][2])
        else
            self.textbox:setFont(options["font"])
        end
    end

    if options["align"] then
        self.textbox:setAlign(options["align"])
    end

    self.textbox:setSkippable(options["skip"] or options["skip"] == nil)
    self.textbox:setAdvance(options["advance"] or options["advance"] == nil)
    self.textbox:setAuto(options["auto"])

    self.textbox:setText(text, function()
        self.textbox:remove()
        self:tryResume()
    end)

    local wait = options["wait"] or options["wait"] == nil
    if not self.textbox.text.can_advance then
        wait = options["wait"] -- By default, don't wait if the textbox can't advance
    end

    if wait then
        return self:wait(waitForSpecialTextbox)
    else
        return waitForSpecialTextbox, self.textbox
    end
end

local function waitForSpecialChoicer(self) return self.choicebox.done, self.choicebox.selected_choice end
function BattleCutscene:choicerSpecial(choices, options)
	if self.textbox then
        self.textbox:remove()
        self.textbox = nil
    end

    if self.choicebox then self.choicebox:remove() end

    local width, height = 529, 103
    if Game:isLight() then
        width, height = 530, 104
    end

    self.choicebox = Choicebox(56, 344, width, height, false, options)
    self.choicebox.layer = BATTLE_LAYERS["top"]
    Game.battle:addChild(self.choicebox)
    self.choicebox:setParallax(0, 0)

    for _,choice in ipairs(choices) do
        self.choicebox:addChoice(choice)
    end

    options = options or {}
    self.textbox_top = false

    self.choicebox.active = true
    self.choicebox.visible = true

    if options["wait"] or options["wait"] == nil then
        return self:wait(waitForSpecialChoicer)
    else
        return waitForSpecialChoicer, self.choicebox
    end
end

return BattleCutscene