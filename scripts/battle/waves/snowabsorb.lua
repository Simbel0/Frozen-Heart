local snowAbsorb, super = Class(Wave)

function snowAbsorb:init()
    super:init(self)
    self.time=12
    self.s_a=0
end

function snowAbsorb:onArenaEnter()
    Game.battle.arena.color={0, 0, 1}
end

function snowAbsorb:onStart()
    -- Every 0.33 seconds...
    Game.battle.soul.inv_timer = 3
    bigBullet = self:spawnBullet("snowflakeBullet", Game.battle.arena.left+142/2, Game.battle.arena.top+142/2, 0, 0, false, 0, false)
    bigBullet.alpha=0
    bigBullet.destroy_on_hit=false
    bigBullet.tp=0
    bigBullet.damage=0
    self.timer:script(function(wait)
        self.timer:tween(3, bigBullet, {alpha=1, scale_x=1, scale_y=1})
        wait(3.5)
        bigBullet.rotate=true
        bigBullet.damage=nil
        bigBullet.tp=1
        self.timer:everyInstant(0.4, function()

            for i=1,10 do
                local angle=self.s_a + 360 / 60 * i
                local rangle=math.rad(angle)
                -- Our X position is offscreen, to the right
                local x = math.cos(rangle)*800
                -- Get a random Y position between the top and the bottom of the arena
                local y = math.sin(rangle)*800

                local angle = Utils.angle(x, y, bigBullet.x, bigBullet.y)

                -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
                local bullet = self:spawnBullet("lonelySnow", x, y, angle, Utils.random(2, 6))
                bullet.layer=bigBullet.layer-10

                -- Dont remove the bullet offscreen, because we spawn it offscreen
                bullet.remove_offscreen = false
                self.s_a=self.s_a+math.random(15,180)
            end

            for i=1,20 do
                local angle=self.s_a + 360 / 60 * i
                local rangle=math.rad(angle)
                -- Our X position is offscreen, to the right
                local x = math.cos(rangle)*800
                -- Get a random Y position between the top and the bottom of the arena
                local y = math.sin(rangle)*800

                local angle = Utils.angle(x, y, bigBullet.x, bigBullet.y)

                -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
                local bullet = self:spawnBullet("lonelySnow", x, y, angle, Utils.random(8, 14))
                bullet.layer=bigBullet.layer-20
                bullet.damage=0
                bullet.tp=0
                bullet.alpha=0.15
                bullet:setScale(0.75)

                -- Dont remove the bullet offscreen, because we spawn it offscreen
                bullet.remove_offscreen = false
                self.s_a=self.s_a+math.random(15,180)
            end
        end)
    end)
end

function snowAbsorb:update()
    -- Code here gets called every frame

    for i=2,#self.bullets do
        if self.bullets[i].collider:collidesWith(bigBullet) then
            self.bullets[i]:remove()
        end
    end

    if #self.bullets>1 then
        Game.battle.arena.rotation=Game.battle.arena.rotation+((7/60)*DTMULT)
    end

    super:update(self)
end

return snowAbsorb