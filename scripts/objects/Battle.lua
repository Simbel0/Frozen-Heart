--I'm sure I could have use that stuff better but it works so who cares?
local Battle, super = Class(Battle)

function Battle:init()
    super:init(self)
end

function Battle:postInit(state, encounter)
    self.state = state

    if type(encounter) == "string" then
        self.encounter = Registry.createEncounter(encounter)
    else
        self.encounter = encounter
    end

    if self.encounter.battleMod then
        self.enemies[1].actor.path=self.enemies[1].actor.path.."_b"
    end

    if Game.world.music:isPlaying() then
        self.resume_world_music = true
        Game.world.music:pause()
    end

    if self.encounter.queued_enemy_spawns then
        for _,enemy in ipairs(self.encounter.queued_enemy_spawns) do
            if state == "TRANSITION" then
                enemy.target_x = enemy.x
                enemy.target_y = enemy.y
                enemy.x = SCREEN_WIDTH + 200
            end
            table.insert(self.enemies, enemy)
            self:addChild(enemy)
        end
    end

    self.battle_ui = BattleUI()
    self:addChild(self.battle_ui)

    self.tension_bar = TensionBar(-25, 40, true)
    self:addChild(self.tension_bar)

    if self.encounter.battleMod then
        self.noelle_tension_bar = NoelleTensionBar(SCREEN_WIDTH+30, 40, true)
        self:addChild(self.noelle_tension_bar)
    end

    self.battler_targets = {}
    for index, battler in ipairs(self.party) do
        local target_x, target_y
        if #self.party == 1 then
            target_x = 80
            target_y = 140
        elseif #self.party == 2 then
            target_x = 80
            target_y = 100 + (80 * (index - 1))
        elseif #self.party == 3 then
            target_x = 80
            target_y = 50 + (80 * (index - 1))
        end

        local ox, oy = battler.chara:getBattleOffset()
        target_x = target_x + (battler.actor:getWidth()/2 + ox) * 2
        target_y = target_y + (battler.actor:getHeight()  + oy) * 2
        table.insert(self.battler_targets, {target_x, target_y})

        if state ~= "TRANSITION" then
            battler:setPosition(target_x, target_y)
        end
    end

    for _,enemy in ipairs(self.enemies) do
        self.enemy_beginning_positions[enemy] = {enemy.x, enemy.y}
    end
    if Game.encounter_enemies then
        for _,from in ipairs(Game.encounter_enemies) do
            if not isClass(from) then
                local enemy = self:parseEnemyIdentifier(from[1])
                from[2].visible = false
                self.enemy_beginning_positions[enemy] = {from[2]:getScreenPos()}
                self.enemy_world_characters[enemy] = from[2]
                if state == "TRANSITION" then
                    enemy:setPosition(from[2]:getScreenPos())
                end
            else
                for _,enemy in ipairs(self.enemies) do
                    if enemy.actor and from.actor and enemy.actor.id == from.actor.id then
                        from.visible = false
                        self.enemy_beginning_positions[enemy] = {from:getScreenPos()}
                        self.enemy_world_characters[enemy] = from
                        if state == "TRANSITION" then
                            enemy:setPosition(from:getScreenPos())
                        end
                        break
                    end
                end
            end
        end
    end

    if state == "TRANSITION" then
        self.transitioned = true
        self.transition_timer = 0
        self.afterimage_count = 0
    else
        self.transition_timer = 10

        if state ~= "INTRO" then
            self:nextTurn()
        end
    end

    if not self.encounter:onBattleInit() then
        self:setState(state)
    end
end

function Battle:onStateChange(old,new)
    if new == "INTRO" then
        if self.encounter.beforeStateChange then
            local result = self.encounter:beforeStateChange(old,new)
            if result or self.state ~= new then
                return
            end
        end

        self.seen_encounter_text = false
        self.intro_timer = 0
        Assets.playSound("impact", 0.7)
        Assets.playSound("weaponpull_fast", 0.8)

        for _,battler in ipairs(self.party) do
            battler:setAnimation("battle/intro")
        end
        for _,enemy in ipairs(self.enemies) do
            if enemy.id=="noelle" then
                enemy:setAnimation("battle/transition")
            end
        end

        self.encounter:onBattleStart()

        if self.encounter.onStateChange then
            self.encounter:onStateChange(old,new)
        end
    elseif new == "ALLSELECT" then
        self.battle_ui.encounter_text:setText("")
        self.current_menu_y = 1
    else
        super:onStateChange(self, old, new)
    end
end

function Battle:pushForcedAction(battler, action, target, data, extra)
    self:showUI()
    super:pushForcedAction(self, battler, action, target, data, extra)
end

function Battle:updateTransition()
    while self.afterimage_count < math.floor(self.transition_timer) do
        for index, battler in ipairs(self.party) do
            local target_x, target_y = unpack(self.battler_targets[index])

            local battler_x = battler.x
            local battler_y = battler.y

            battler.x = Utils.lerp(self.party_beginning_positions[index][1], target_x, (self.afterimage_count + 1) / 10)
            battler.y = Utils.lerp(self.party_beginning_positions[index][2], target_y+(self.encounter.battleMod and 40 or 0), (self.afterimage_count + 1) / 10)

            local afterimage = AfterImage(battler, 0.5)
            self:addChild(afterimage)

            if self.encounter.battleMod then
                local afterimageNoelle = AfterImage(self.enemies[1], 0.5)
                self:addChild(afterimageNoelle)
            end

            battler.x = battler_x
            battler.y = battler_y
        end
        self.afterimage_count = self.afterimage_count + 1
    end

    self.transition_timer = self.transition_timer + 1 * DTMULT

    if self.transition_timer >= 10 then
        self.transition_timer = 10
        self:setState("INTRO")
    end

    for index, battler in ipairs(self.party) do
        local target_x, target_y = unpack(self.battler_targets[index])

        battler.x = Utils.lerp(self.party_beginning_positions[index][1], target_x, self.transition_timer / 10)
        battler.y = Utils.lerp(self.party_beginning_positions[index][2], target_y+(self.encounter.battleMod and 40 or 0), self.transition_timer / 10)
    end
    for _, enemy in ipairs(self.enemies) do
        enemy.x = Utils.lerp(self.enemy_beginning_positions[enemy][1], enemy.target_x, self.transition_timer / 10)
        enemy.y = Utils.lerp(self.enemy_beginning_positions[enemy][2], enemy.target_y+(self.encounter.battleMod and 40 or 0), self.transition_timer / 10)
    end

    if self.encounter.battleMod then
        local map={Game.world.map:getImageLayer("room"), Game.world.map:getImageLayer("moon"), Game.world.map:getImageLayer("ferris_wheel")}
        for _,layer in ipairs(map) do
            layer.y = Utils.lerp(0, -30, self.transition_timer / 10)
        end
    end
end

function Battle:updateTransitionOut()
    if not self.battle_ui.animation_done then
        return
    end

    local all_enemies = {}
    Utils.merge(all_enemies, self.enemies)
    Utils.merge(all_enemies, self.defeated_enemies)

    self.transition_timer = self.transition_timer - DTMULT

    if self.transition_timer <= 0 then--or not self.transitioned then
        local enemies = {}
        for k,v in pairs(self.enemy_world_characters) do
            table.insert(enemies, v)
        end
        self.encounter:onReturnToWorld(enemies)
        self:returnToWorld()
        return
    end

    if self.encounter.battleMod then
        local map={Game.world.map:getImageLayer("room"), Game.world.map:getImageLayer("moon"), Game.world.map:getImageLayer("ferris_wheel")}
        for _,layer in ipairs(map) do
            layer.y = Utils.lerp(0, -30, -(self.transition_timer / 10))
        end
    end

    for index, battler in ipairs(self.party) do
        local target_x, target_y = unpack(self.battler_targets[index])

        battler.x = Utils.lerp(self.party_beginning_positions[index][1], target_x, self.transition_timer / 10)
        battler.y = Utils.lerp(self.party_beginning_positions[index][2], target_y, self.transition_timer / 10)
    end

    for _, enemy in ipairs(all_enemies) do
        local world_chara = self.enemy_world_characters[enemy]
        if enemy.target_x and enemy.target_y and not enemy.exit_on_defeat and world_chara and world_chara.parent then
            enemy.x = Utils.lerp(self.enemy_beginning_positions[enemy][1], enemy.target_x, self.transition_timer / 10)
            enemy.y = Utils.lerp(self.enemy_beginning_positions[enemy][2], enemy.target_y, self.transition_timer / 10)
        else
            local fade = enemy:getFX("battle_end")
            if not fade then
                fade = enemy:addFX(AlphaFX(1), "battle_end")
            end
            fade.alpha = self.transition_timer / 10
        end
    end
end

function Battle:spawnSoul(x, y)
    print("HEAR ITS CRY")
    if Game:getFlag("plot", 0)>=2 then
        print("o")
        local bx, by = self:getSoulLocation()
        local color = {Game:getSoulColor()}
        self:addChild(HeartBurst(bx, by, color))
        if not self.soul then
            print("é")
            self.soul = self.encounter:createSoul(bx, by, color)
            self.soul:transitionTo(x or SCREEN_WIDTH/2, y or SCREEN_HEIGHT/2)
            self.soul.target_alpha = self.soul.alpha
            self.soul.alpha = 0
            self:addChild(self.soul)
        end
    else
        if not self.soul then --Create an invisible soul just in case to prevent problems with DEFENDINGBEGIN
            self.soul = self.encounter:createSoul(bx, by, color)
            self.soul:transitionTo(x or SCREEN_WIDTH/2, y or SCREEN_HEIGHT/2)
            self.soul.target_alpha = 0
            self.soul.alpha = 0
            self:addChild(self.soul)
        end
    end
end

function Battle:isHighlighted(battler)
    if self.state == "ALLSELECT" then
        if self.current_menu_y<=#self.party then
            return self.party[self.current_menu_y] == battler
        else
            return self.enemies[self.current_menu_y-#self.party] == battler
        end
    end
    return super:isHighlighted(self, battler)
end

function Battle:commitSingleAction(action)
    local battler = self.party[action.character_id]

    if action.action == "ITEM" and action.data then
        local result = action.data:onBattleSelect(battler, action.target)
        if result ~= false then
            local storage, index = Game.inventory:getItemIndex(action.data)
            action.item_storage = storage
            action.item_index = index
            if action.data:hasResultItem() then
                local result_item = action.data:createResultItem()
                Game.inventory:setItem(storage, index, result_item)
                action.result_item = result_item
            else
                Game.inventory:removeItem(action.data)
            end
            action.consumed = true
            Game:setFlag("no_heal", false)
        else
            action.consumed = false
        end
    end
    
    local anim = action.action:lower()
    if action.action == "SPELL" and action.data then
        local result = action.data:onSelect(battler, action.target)
        if result ~= false then
            if action.tp then
                if action.tp > 0 then
                    Game:giveTension(action.tp)
                elseif action.tp < 0 then
                    Game:removeTension(-action.tp)
                end
            end
            battler:setAnimation("battle/"..anim.."_ready")
            action.icon = anim
        end
    else
        if action.tp then
            if action.tp > 0 then
                Game:giveTension(action.tp)
            elseif action.tp < 0 then
                Game:removeTension(-action.tp)
            end
        end
        
        if action.action == "SKIP" and action.reason then
            anim = action.reason:lower()
        end
    
        if (action.action == "ITEM" and action.data and (not action.data.instant)) or (action.action ~= "ITEM") then
            battler:setAnimation("battle/"..anim.."_ready")
            action.icon = anim
        end
    end

    battler.action = action

    self.character_actions[action.character_id] = action
end

function Battle:nextParty()
    table.insert(self.selected_character_stack, self.current_selecting)
    table.insert(self.selected_action_stack, Utils.copy(self.character_actions))

    local all_done = true
    local last_selected = self.current_selecting
    self.current_selecting = (self.current_selecting % #self.party) + 1
    while self.current_selecting ~= last_selected do
        if not self:hasAction(self.current_selecting) and self.party[self.current_selecting]:isActive() then
            all_done = false
            break
        end
        self.current_selecting = (self.current_selecting % #self.party) + 1
    end

    local party = self.party[self.current_selecting]
    if all_done then
        self.selected_character_stack = {}
        self.selected_action_stack = {}
        self.current_action_processing = 1
        self.current_selecting = 0
        self:startProcessing()
    else
        if self:getState() ~= "ACTIONSELECT" then
            self:setState("ACTIONSELECT")
            self.battle_ui.encounter_text:setText("[instant]" .. self.battle_ui.current_encounter_text)
        else
            party.chara:onActionSelect(party, false)
        end
    end
    self.encounter:onCharacterTurn(party, false)
end

function Battle:onKeyPressed(key)
    if OVERLAY_OPEN then return end

    if Kristal.Config["debug"] and Input.ctrl() then
        if key == "h" then
            for _,party in ipairs(self.party) do
                party:heal(math.huge)
            end
        end
        if key == "y" then
            Input.clear(nil, true)
            self:setState("VICTORY")
        end
        if key == "m" then
            if self.music then
                if self.music:isPlaying() then
                    self.music:pause()
                else
                    self.music:resume()
                end
            end
        end
        if self.state == "DEFENDING" and key == "f" then
            self.encounter:onWavesDone()
        end
        if self.soul and key == "j" then
            self.soul:shatter(6)
            self:getPartyBattler(Game:getSoulPartyMember().id):hurt(99999)
        end
        if key == "b" then
            for _,battler in ipairs(self.party) do
                battler:hurt(99999)
            end
        end
        if key == "k" then
            -- Set it directly so it's not capped by the max
            Game.tension = (Game:getMaxTension() * 2)
        end
        if key == "n" then
            Game.battle.noelle_tension_bar.nTension = 99
        end
    end

    if self.state == "MENUSELECT" then
        local menu_width = 2
        local menu_height = math.ceil(#self.menu_items / 2)

        if Input.isConfirm(key) then
            if self.state_reason == "ACT" then
                local menu_item = self.menu_items[self:getItemIndex()]
                if self:canSelectMenuItem(menu_item) then
                    self.ui_select:stop()
                    self.ui_select:play()

                    self:pushAction("ACT", self.enemies[self.selected_enemy], menu_item)
                end
                return
            elseif self.state_reason == "SPELL" then
                local menu_item = self.menu_items[self:getItemIndex()]
                self.selected_spell = menu_item
                if self:canSelectMenuItem(menu_item) then
                    self.ui_select:stop()
                    self.ui_select:play()

                    if menu_item.data.target == "xact" then
                        self.selected_xaction = menu_item.data
                        self:setState("XACTENEMYSELECT", "SPELL")
                    elseif not menu_item.data.target or menu_item.data.target == "none" then
                        self:pushAction("SPELL", nil, menu_item)
                    elseif menu_item.data.target == "ally" then
                        self:setState("PARTYSELECT", "SPELL")
                    elseif menu_item.data.target == "enemy" then
                        self:setState("ENEMYSELECT", "SPELL")
                    elseif menu_item.data.target == "party" then
                        self:pushAction("SPELL", self.party, menu_item)
                    elseif menu_item.data.target == "enemies" then
                        self:pushAction("SPELL", self:getActiveEnemies(), menu_item)
                    elseif menu_item.data.target == "all" then
                        self:setState("ALLSELECT", "SPELL")
                    end
                end
                return
            elseif self.state_reason == "ITEM" then
                local menu_item = self.menu_items[self:getItemIndex()]
                self.selected_item = menu_item
                if self:canSelectMenuItem(menu_item) then
                    self.ui_select:stop()
                    self.ui_select:play()
                    if not menu_item.data.target or menu_item.data.target == "none" then
                        self:pushAction("ITEM", nil, menu_item)
                    elseif menu_item.data.target == "ally" then
                        self:setState("PARTYSELECT", "ITEM")
                    elseif menu_item.data.target == "enemy" then
                        self:setState("ENEMYSELECT", "ITEM")
                    elseif menu_item.data.target == "party" then
                        self:pushAction("ITEM", self.party, menu_item)
                    elseif menu_item.data.target == "enemies" then
                        self:pushAction("ITEM", self:getActiveEnemies(), menu_item)
                    end
                end
            end
        elseif Input.isCancel(key) then
            self.ui_move:stop()
            self.ui_move:play()
            Game:setTensionPreview(0)
            self:setState("ACTIONSELECT", "CANCEL")
            return
        elseif Input.is("left", key) then -- TODO: pagination
            self.current_menu_x = self.current_menu_x - 1
            if self.current_menu_x < 1 then
                self.current_menu_x = menu_width
                if not self:isValidMenuLocation() then
                    self.current_menu_x = 1
                end
            end
        elseif Input.is("right", key) then
            self.current_menu_x = self.current_menu_x + 1
            if not self:isValidMenuLocation() then
                self.current_menu_x = 1
            end
        end
        if Input.is("up", key) then
            self.current_menu_y = self.current_menu_y - 1
            if self.current_menu_y < 1 then
                self.current_menu_y = 1 -- No wrapping in this menu.
            end
        elseif Input.is("down", key) then
            self.current_menu_y = self.current_menu_y + 1
            if (self.current_menu_y > menu_height) or (not self:isValidMenuLocation()) then
                self.current_menu_y = menu_height -- No wrapping in this menu.
                if not self:isValidMenuLocation() then
                    self.current_menu_y = menu_height - 1
                end
            end
        end
    elseif self.state == "ENEMYSELECT" or self.state == "XACTENEMYSELECT" then
        if Input.isConfirm(key) then
            self.ui_select:stop()
            self.ui_select:play()
            if #self.enemies == 0 then return end
            self.selected_enemy = self.current_menu_y
            if self.state == "XACTENEMYSELECT" then
                self:pushAction("XACT", self.enemies[self.selected_enemy], self.selected_xaction)
            elseif self.state_reason == "SPARE" then
                self:pushAction("SPARE", self.enemies[self.selected_enemy])
            elseif self.state_reason == "ACT" then
                self.menu_items = {}
                local enemy = self.enemies[self.selected_enemy]
                for _,v in ipairs(enemy.acts) do
                    local insert = true
                    if v.character and self.party[self.current_selecting].chara.id ~= v.character then
                        insert = false
                    end
                    if v.party and (#v.party > 0) then
                        for _,party_id in ipairs(v.party) do
                            if not self:getPartyIndex(party_id) then
                                insert = false
                                break
                            end
                        end
                    end
                    if insert then
                        local item = {
                            ["name"] = v.name,
                            ["tp"] = v.tp or 0,
                            ["description"] = v.description,
                            ["party"] = v.party,
                            ["color"] = {1, 1, 1, 1},
                            ["highlight"] = v.highlight or enemy,
                            ["icons"] = v.icons
                        }
                        table.insert(self.menu_items, item)
                    end
                end
                self:setState("MENUSELECT", "ACT")
            elseif self.state_reason == "ATTACK" then
                self:pushAction("ATTACK", self.enemies[self.selected_enemy])
            elseif self.state_reason == "SPELL" then
                self:pushAction("SPELL", self.enemies[self.selected_enemy], self.selected_spell)
            elseif self.state_reason == "ITEM" then
                self:pushAction("ITEM", self.enemies[self.selected_enemy], self.selected_item)
            else
                self:nextParty()
            end
            return
        end
        if Input.isCancel(key) then
            self.ui_move:stop()
            self.ui_move:play()
            if self.state_reason == "SPELL" then
                self:setState("MENUSELECT", "SPELL")
            elseif self.state_reason == "ITEM" then
                self:setState("MENUSELECT", "ITEM")
            else
                self:setState("ACTIONSELECT", "CANCEL")
            end
            return
        end
        if Input.is("up", key) then
            if #self.enemies == 0 then return end
            local old_location = self.current_menu_y
            local give_up = 0
            repeat
                give_up = give_up + 1
                if give_up > 100 then return end
                -- Keep decrementing until there's a selectable enemy.
                self.current_menu_y = self.current_menu_y - 1
                if self.current_menu_y < 1 then
                    self.current_menu_y = #self.enemies
                end
            until (self.enemies[self.current_menu_y].selectable)

            if self.current_menu_y ~= old_location then
                self.ui_move:stop()
                self.ui_move:play()
            end
        elseif Input.is("down", key) then
            local old_location = self.current_menu_y
            if #self.enemies == 0 then return end
            local give_up = 0
            repeat
                give_up = give_up + 1
                if give_up > 100 then return end
                -- Keep decrementing until there's a selectable enemy.
                self.current_menu_y = self.current_menu_y + 1
                if self.current_menu_y > #self.enemies then
                    self.current_menu_y = 1
                end
            until (self.enemies[self.current_menu_y].selectable)

            if self.current_menu_y ~= old_location then
                self.ui_move:stop()
                self.ui_move:play()
            end
        end
    elseif self.state == "PARTYSELECT" then
        if Input.isConfirm(key) then
            self.ui_select:stop()
            self.ui_select:play()
            if self.state_reason == "SPELL" then
                self:pushAction("SPELL", self.party[self.current_menu_y], self.selected_spell)
            elseif self.state_reason == "ITEM" then
                self:pushAction("ITEM", self.party[self.current_menu_y], self.selected_item)
            else
                self:nextParty()
            end
            return
        end
        if Input.isCancel(key) then
            self.ui_move:stop()
            self.ui_move:play()
            if self.state_reason == "SPELL" then
                self:setState("MENUSELECT", "SPELL")
            elseif self.state_reason == "ITEM" then
                self:setState("MENUSELECT", "ITEM")
            else
                self:setState("ACTIONSELECT", "CANCEL")
            end
            return
        end
        if Input.is("up", key) then
            self.ui_move:stop()
            self.ui_move:play()
            self.current_menu_y = self.current_menu_y - 1
            if self.current_menu_y < 1 then
                self.current_menu_y = #self.party
            end
        elseif Input.is("down", key) then
            self.ui_move:stop()
            self.ui_move:play()
            self.current_menu_y = self.current_menu_y + 1
            if self.current_menu_y > #self.party then
                self.current_menu_y = 1
            end
        end
    elseif self.state == "ALLSELECT" then
        if Input.isConfirm(key) then
            self.ui_select:stop()
            self.ui_select:play()
            local selected
            if self.current_menu_y<=#self.party then
                selected = self.party[self.current_menu_y]
            else
                selected = self.enemies[self.current_menu_y-#self.party]
            end
            if self.state_reason == "SPELL" then
                self:pushAction("SPELL", selected, self.selected_spell)
            elseif self.state_reason == "ITEM" then
                self:pushAction("ITEM", selected, self.selected_item)
            else
                self:nextParty()
            end
            return
        end
        if Input.isCancel(key) then
            self.ui_move:stop()
            self.ui_move:play()
            if self.state_reason == "SPELL" then
                self:setState("MENUSELECT", "SPELL")
            elseif self.state_reason == "ITEM" then
                self:setState("MENUSELECT", "ITEM")
            else
                self:setState("ACTIONSELECT", "CANCEL")
            end
            return
        end
        if Input.is("up", key) then
            self.ui_move:stop()
            self.ui_move:play()
            self.current_menu_y = self.current_menu_y - 1
            if self.current_menu_y < 1 then
                self.current_menu_y = #self.party+#self.enemies
            end
        elseif Input.is("down", key) then
            self.ui_move:stop()
            self.ui_move:play()
            self.current_menu_y = self.current_menu_y + 1
            if self.current_menu_y > #self.party+#self.enemies then
                self.current_menu_y = 1
            end
        end
    elseif self.state == "BATTLETEXT" then
        -- Nothing here
    elseif self.state == "SHORTACTTEXT" then
        if Input.isConfirm(key) then
            if (not self.battle_ui.short_act_text_1:isTyping()) and
               (not self.battle_ui.short_act_text_2:isTyping()) and
               (not self.battle_ui.short_act_text_3:isTyping()) then
                self.battle_ui.short_act_text_1:setText("")
                self.battle_ui.short_act_text_2:setText("")
                self.battle_ui.short_act_text_3:setText("")
                for _,iaction in ipairs(self.short_actions) do
                    self:finishAction(iaction)
                end
                self.short_actions = {}
                self:setState("ACTIONS", "SHORTACTTEXT")
            end
        end
    elseif self.state == "ENEMYDIALOGUE" then
        -- Nothing here
    elseif self.state == "ACTIONSELECT" then
        local actbox = self.battle_ui.action_boxes[self.current_selecting]

        if Input.isConfirm(key) then
            actbox:select()
            self.ui_select:stop()
            self.ui_select:play()
            return
        elseif Input.isCancel(key) then
            local old_selecting = self.current_selecting

            self:previousParty()

            if self.current_selecting ~= old_selecting then
                self.ui_move:stop()
                self.ui_move:play()
                self.battle_ui.action_boxes[self.current_selecting]:unselect()
            end
            return
        elseif Input.is("left", key) then
            actbox.selected_button = actbox.selected_button - 1
            self.ui_move:stop()
            self.ui_move:play()
        elseif Input.is("right", key) then
            actbox.selected_button = actbox.selected_button + 1
            self.ui_move:stop()
            self.ui_move:play()
        end

        if actbox.selected_button < 1 then
            actbox.selected_button = #actbox.buttons
        end

        if actbox.selected_button > #actbox.buttons then
            actbox.selected_button = 1
        end
    elseif self.state == "ATTACKING" then
        if Input.isConfirm(key) then
            if not self.attack_done and not self.cancel_attack and #self.battle_ui.attack_boxes > 0 then
                local closest
                local closest_attacks = {}

                for _,attack in ipairs(self.battle_ui.attack_boxes) do
                    if not attack.attacked then
                        local close = attack:getClose()
                        if not closest then
                            closest = close
                            table.insert(closest_attacks, attack)
                        elseif close == closest then
                            table.insert(closest_attacks, attack)
                        elseif close < closest then
                            closest = close
                            closest_attacks = {attack}
                        end
                    end
                end

                if closest < 15 and closest > -5 then
                    for _,attack in ipairs(closest_attacks) do
                        local points = attack:hit()

                        local action = self:getActionBy(attack.battler)
                        action.points = points

                        if self:processAction(action) then
                            self:finishAction(action)
                        end
                    end
                end
            end
        end
    end
end

return Battle