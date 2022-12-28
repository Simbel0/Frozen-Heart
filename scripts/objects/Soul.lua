local Soul, super = Class("Soul", true)

function Soul:init(x, y, color)
    super:init(self, x, y)

    self.sprite:remove()

    if Game:getFlag("plot", 0)<4 then
        print("kljzlkjl")
        self.sprite = Sprite("player/heart_monster")
        self.color = {1, 1, 1}
    else
        print("ooooo")
        self.sprite = Sprite("player/heart_dodge")
    end
    self.sprite:setOrigin(0.5, 0.5)
    self.sprite.inherit_color = true
    self:addChild(self.sprite)
end

function Soul:update()
    --[[if self.transitioning then
        if self.timer >= 7 then
            Input.clear("cancel")
            self.timer = 0
            if self.transition_destroy then
                if Game:getFlag("plot", 0)>=2 then
                    Game.battle:addChild(HeartBurst(self.target_x, self.target_y, {Game:getSoulColor()}))
                end
                self:remove()
            else
                self.transitioning = false
                self:setExactPosition(self.target_x, self.target_y)
            end
        else
            self:setExactPosition(
                Utils.lerp(self.original_x, self.target_x, self.timer / 7),
                Utils.lerp(self.original_y, self.target_y, self.timer / 7)
            )
            self.alpha = Utils.lerp(0, self.target_alpha or 1, self.timer / 3)
            self.sprite:setColor(self.color[1], self.color[2], self.color[3], self.alpha)
            self.timer = self.timer + (1 * DTMULT)
        end
        return
    end

    -- Input movement
    if self.can_move then
        self:doMovement()
    end

    -- Bullet collision !!! Yay
    if self.inv_timer > 0 then
        self.inv_timer = Utils.approach(self.inv_timer, 0, DT)
    end

    local collided_bullets = {}
    Object.startCache()
    for _,bullet in ipairs(Game.stage:getObjects(Bullet)) do
        if bullet:collidesWith(self.collider) then
            -- Store collided bullets to a table before calling onCollide
            -- to avoid issues with cacheing inside onCollide
            print("collided_bullets")
            table.insert(collided_bullets, bullet)
        end
        if self.inv_timer == 0 then
            if bullet.tp ~= 0 and bullet:collidesWith(self.graze_collider) then
                if bullet.grazed then
                    Game:giveTension(bullet.tp * DT * self.graze_tp_factor)
                    if Game.battle.noelle_tension_bar then
                        Game.battle.noelle_tension_bar:giveTension(bullet.tp * DT * self.graze_tp_factor)
                    end
                    if Game.battle.wave_timer < Game.battle.wave_length - (1/3) then
                        Game.battle.wave_timer = Game.battle.wave_timer + (bullet.time_bonus * (DT / 30) * self.graze_time_factor)
                    end
                    if self.graze_sprite.timer < 0.1 then
                        self.graze_sprite.timer = 0.1
                    end
                else
                    Assets.playSound("graze")
                    Game:giveTension(bullet.tp * self.graze_tp_factor)
                    if Game.battle.noelle_tension_bar then
                        Game.battle.noelle_tension_bar:giveTension(bullet.tp * self.graze_tp_factor)
                    end
                    if Game.battle.wave_timer < Game.battle.wave_length - (1/3) then
                        Game.battle.wave_timer = Game.battle.wave_timer + ((bullet.time_bonus / 30) * self.graze_time_factor)
                    end
                    self.graze_sprite.timer = 1/3
                    bullet.grazed = true
                end
            end
        end
    end
    Object.endCache()
    for _,bullet in ipairs(collided_bullets) do
        print("Collide")
        self:onCollide(bullet)
    end

    if self.inv_timer > 0 then
        self.inv_flash_timer = self.inv_flash_timer + DT
        local amt = math.floor(self.inv_flash_timer / (4/30))
        if (amt % 2) == 1 then
            self.sprite:setColor(0.5, 0.5, 0.5)
        else
            self.sprite:setColor(1, 1, 1)
        end
    else
        self.inv_flash_timer = 0
        self.sprite:setColor(1, 1, 1)
    end]]
    super:update(self)
    for _,bullet in ipairs(Game.stage:getObjects(Bullet)) do
        if self.inv_timer == 0 then
            if bullet.tp ~= 0 and bullet:collidesWith(self.graze_collider) then
                if bullet.grazed then
                    if Game.battle.noelle_tension_bar then
                        Game.battle.noelle_tension_bar:giveTension(bullet.tp * DT * self.graze_tp_factor)
                    end
                else
                    if Game.battle.noelle_tension_bar then
                        Game.battle.noelle_tension_bar:giveTension(bullet.tp * self.graze_tp_factor)
                    end
                end
            end
        end
    end
end

return Soul