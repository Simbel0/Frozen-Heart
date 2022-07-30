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
    if self.encounter.battleMod then
        local map={Game.world.map:getImageLayer("room"), Game.world.map:getImageLayer("moon"), Game.world.map:getImageLayer("ferris_wheel")}
        for _,layer in ipairs(map) do
            layer.y = Utils.lerp(-30, 0, self.transition_timer / 10)
        end
    end
    super:updateTransitionOut(self)
end

function Battle:checkGameOver()
    for _,battler in ipairs(self.party) do
        if not battler.is_down then
            return
        end
    end
    self.music:stop()
    if Game:getFlag("plot", 0)>=2 then
        Game:gameOver(self:getSoulLocation())
    else
        self.cutscene:endCutscene()
        self.party[1].sprite.frozen=true
        self:startCutscene("introGameOver")
    end
end

function Battle:spawnSoul(x, y)
    if Game:getFlag("plot", 0)>=2 then
        print("Soul here")
        local bx, by = self:getSoulLocation()
        local color = {Game:getSoulColor()}
        self:addChild(HeartBurst(bx, by, color))
        if not self.soul then
            self.soul = self.encounter:createSoul(bx, by, color)
            self.soul:transitionTo(x or SCREEN_WIDTH/2, y or SCREEN_HEIGHT/2)
            self.soul.target_alpha = self.soul.alpha
            self.soul.alpha = 0
            self:addChild(self.soul)
        end
    else
        print("No soul")
        if not self.soul then --Create an invisible soul to prevent problems with DEFENDINGBEGIN
            self.soul = self.encounter:createSoul(bx, by, color)
            self.soul:transitionTo(x or SCREEN_WIDTH/2, y or SCREEN_HEIGHT/2)
            self.soul.target_alpha = 0
            self.soul.alpha = 0
            self:addChild(self.soul)
        end
    end
end

return Battle