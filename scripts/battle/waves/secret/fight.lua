local Fight, super = Class(Wave)

function Fight:init()
    super:init(self)
    self.time = 10
    self.flash = 0
    self.fade = -0.5
    self:setArenaSize(162)
end

function Fight:onStart()
    -- Every 0.33 seconds...
    self.timer:after(0.4, function()
        self.timer:everyInstant(0.4, function()
            print("loop")
            if not self.attack_bar then
                self.timer:script(function(wait)
                    self.attack_bar = AttackBar(SCREEN_WIDTH-200, SCREEN_HEIGHT-(36*3)-6, 6, 38)
                    print(self.attack_bar)
                    self.attack_bar:setLayer(BATTLE_LAYERS["below_bullets"])
                    Game.battle:addChild(self.attack_bar)
                    while not self.attack_bar.bursting do
                        wait(0.1)
                    end
                    print("SLAP")
                    Assets.playSound("laz_c", 1, 1.5)
                    local x, y = Utils.random(Game.battle.arena.left, Game.battle.arena.right), Utils.random(Game.battle.arena.top, Game.battle.arena.bottom)
                    local attack_sprite = Sprite("effects/attack/slap_n", x, y)
                    attack_sprite:setPosition(x-attack_sprite.width/2, y-attack_sprite.height/2)
                    attack_sprite:setOrigin(0.5,0.5)
                    attack_sprite:setScale(2)
                    attack_sprite:setLayer(BATTLE_LAYERS["below_bullets"])
                    attack_sprite:play(1/15, false, function(s)
                        s:remove()
                        local start_rot = Utils.random(380)
                        for i=0,7 do
                            self:spawnBullet("secret/slap", x, y, math.rad(start_rot+(i*45)), 5)
                        end
                    end)
                    Game.battle:addChild(attack_sprite)
                    while self.attack_bar.parent do
                        wait(0.1)
                    end
                    wait(0.2)
                    self.attack_bar = nil
                end)
            end
        end)
    end)
end

function Fight:update()
    -- Code here gets called every frame

    if self.attack_bar then
        if self.attack_bar.x<SCREEN_WIDTH-53 then
            self.attack_bar:move(8*DTMULT, 0)
        else
            self.attack_bar:setColor(1,1,0)
            self.attack_bar:burst()
        end
    end

    super:update(self)
end

function Fight:draw()
    local target_color = {1, 1, 153/255, self.fade}
    local box_color = {1, 1, 0, self.fade}

    if self.flash > 0 then
        box_color = Utils.lerp(box_color, {1, 1, 1, self.fade}, self.flash)
    end

    if self.fade<1 then
        self.fade=self.fade+0.04*DTMULT
    end

    love.graphics.setLineWidth(2)
    love.graphics.setLineStyle("rough")

    love.graphics.setColor(box_color)
    love.graphics.rectangle("line", SCREEN_WIDTH-160, SCREEN_HEIGHT-(36*3)-6, (15 * 8) + 3, 36)
    love.graphics.setColor(target_color)
    love.graphics.rectangle("line", SCREEN_WIDTH-50, SCREEN_HEIGHT-(36*3)-6, 8, 36)

    love.graphics.setLineWidth(1)

    super:draw(self)
end

function Fight:onEnd()
    if self.attack_bar and self.attack_bar.parent then
        self.attack_bar:remove()
    end
    super:onEnd(self)
end

return Fight