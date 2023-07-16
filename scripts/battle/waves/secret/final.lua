local Final, super = Class(Wave)

function Final:init()
	super.init(self)
	self.time = -1
	self.switch = false
end

function Final:onStart()
	self.timer:tween(0.5, Game.battle.arena, {width=SCREEN_WIDTH, height=SCREEN_HEIGHT, x=320, y=239})
	self.timer:after(0.5, function()
		Game.battle.arena.color = {0, 0, 0}
		self.timer:script(function(wait)
			local first = self.timer:everyInstant(0.75, function()
				if not self.switch then
			        local x, y = Utils.pick({5, SCREEN_WIDTH+5}), Utils.random(5, SCREEN_HEIGHT-5)
			        print(x, y)
			        if self.prev_y then
			            local ok
			            while true do
			                ok = true
			                for i=self.prev_y-5, self.prev_y+5 do
			                    if i==y then
			                        ok = false
			                    end
			                end
			                if ok then
			                    break
			                else
			                    y = Utils.random(Game.battle.arena.left, Game.battle.arena.right)
			                end
			            end
			        end
			        print("pass")
			        self.prev_y = y

			        local rect = Rectangle(SCREEN_WIDTH/2, y, SCREEN_WIDTH, 1)
			        rect:setOrigin(0.5)
			        rect:setLayer(BATTLE_LAYERS["bullets"])
			        rect:setColor(1, 1, 1, 0.5)
			        self:spawnObject(rect)

			        Assets.playSound("bell")
			        self.timer:tween(0.25, rect, {scale_y=20}, nil, function()
			            self.timer:tween(0.35, rect, {scale_y=0}, "in-cubic", function()
			                self.timer:after(0.1, function()
			                	Assets.playSound("snd_swing")
			                    self:spawnBullet("snowflakeBullet", x, y, 0, x<SCREEN_WIDTH/2 and 25 or -25)
			                end)
			            end)
			        end)
			    else
			    	local x, y
			        x = Utils.random(30, SCREEN_WIDTH-30)
			        y = Utils.random(30, SCREEN_HEIGHT-30)

			        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
			        local bullet = self:spawnBullet("secret/iceshock", x, y)
				end
				self.switch = not self.switch
			end)
			wait(7)
		    local second1 = self.timer:every(1/3, function()
		        local angle = love.math.random(360)
		        for i=1,2 do
			        for i=1,5 do
			            local bullet = self:spawnBullet("lonelySnow", Utils.random(0, SCREEN_WIDTH), -5, math.rad((angle+360/5*i)+Utils.random(-5, 5)), 2)
			            bullet.remove_offscreen = true
			        end
			    end
		    end)
		    wait(3)
		    self.timer:cancel(first)
		    wait(5)
		    local delay, delay_timer = 60, 60
		    local second2 = self.timer:during(math.huge, function()
	    		delay_timer = delay_timer + DTMULT
	    		if delay_timer >= delay then
	    			print(delay)
			    	x = Utils.random(Game.battle.arena:getLeft(), Game.battle.arena:getRight())
	            	y = SCREEN_HEIGHT

	            	local rect = Rectangle(x, SCREEN_HEIGHT/2, 24, SCREEN_HEIGHT)
			        rect:setOrigin(0.5)
			        rect:setLayer(BATTLE_LAYERS["bullets"])
			        rect:setColor(1, 1, 1, 1)
			        self:spawnObject(rect)
			        rect:setGraphics({
			        	fade_to = 0,
			        	fade = 0.1,
			        	fade_callback = function() rect:remove() end
			        })
			        Assets.playSound("noise")

			        self.timer:after(0.35, function()
		            	Assets.playSound("snd_spearrise")
				    	self:spawnBullet("secret/stallactic", x, y, math.rad(270), 15)
			    	end)
			    	delay_timer = 0
			    	delay = delay - 2
			    end
		    end)
		    while delay >= 20 do
		    	wait()
		    end
		    delay_timer = -60
		    wait(0.4)
		    self.timer:cancel(second1)
		    self.timer:cancel(second2)
		    for i,bullet in ipairs(self.bullets) do
		    	bullet:fadeOutAndRemove(0.5)
		    end
		    wait(0.5)
		    local radius = 460
		    local angle = 2 * math.pi / 20
	        for i=1,20 do
	        	local x = SCREEN_WIDTH/2 + math.cos(angle * i) * radius
        		local y = (SCREEN_HEIGHT/2)+50 + math.sin(angle * i) * radius

	            local bullet = self:spawnBullet("secret/stallactic", x, y, Utils.angle(x, y, SCREEN_WIDTH/2, (SCREEN_HEIGHT/2)+100), 0)
	            bullet.tp = 0.1
	            bullet.physics.gravity = 0
	            Utils.hook(bullet, "onCollide", function(orig, s, soul)
	            	orig(s, soul)
	            	soul:setPosition(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
	            end)
	            bullet:setHitbox(0, 0, bullet.width, bullet.height+25)
	            bullet.destroy_on_hit = false
	            bullet.remove_offscreen = false
	        end
	        while radius>=100 do
	        	radius = radius - 1*DTMULT

	        	for i,bullet in ipairs(self.bullets) do
	        		local x = SCREEN_WIDTH/2 + math.cos(angle * i) * radius
        			local y = (SCREEN_HEIGHT/2)+50 + math.sin(angle * i) * radius

        			bullet:setPosition(x, y)
	        	end
	        	wait()
	        end
	        self.noelle = self:spawnSprite("party/noelle/dark_c/final", SCREEN_WIDTH/2, (SCREEN_HEIGHT/2)-150)
	        self.fly_noelle = true
	        self.noelle:flash()
	        Assets.playSound("break2")
	        wait(0.5)
	        Assets.playSound("snd_swing")
	        local value = 3
	        while value>-4 do
	        	radius = radius + value
	        	value = value - 0.1*DTMULT

	        	for i,bullet in ipairs(self.bullets) do
	        		local x = SCREEN_WIDTH/2 + math.cos(angle * i) * radius
        			local y = (SCREEN_HEIGHT/2)+50 + math.sin(angle * i) * radius

        			bullet:setPosition(x, y)
	        	end
	        	wait()
	        end
	        Assets.playSound("noise")
	        for i,bullet in ipairs(self.bullets) do
	        	bullet:shake(0.2, 1, 0)
	        	bullet:setHitbox(bullet.width/4, bullet.height/4, bullet.width/2, bullet.height/2)
	        end
	        self.noelle:setSprite("party/noelle/dark_c/final_surprised")
	        wait(3)
	        Assets.playSound("noise")
	        self.noelle:shake(1, 0, 0)
	        self.noelle:setAnimation({"party/noelle/dark_c/innerbattle", 0.2, true})
	        wait(1)
	        while #self.bullets>0 do
	        	local bullet = Utils.pick(self.bullets, nil, true)
	        	bullet:stopShake()
	        	bullet.collider = nil
	        	bullet:setGraphics({
	        		grow = 0.5,
	        		fade_to = 0,
	        		fade = 0.1,
	        		fade_callback = function() bullet:remove() end
	        	})
	        	Assets.playSound("wing")
	        	wait(0.1)
	        end
	        wait(1)
	        self.fly_noelle = false
	        self.noelle:stopShake()
	        Assets.playSound("wing")
	        self.noelle:setSprite("party/noelle/dark_c/final_snowgrave_1")
	        self.timer:tween(0.25, self.noelle, {y=self.noelle.y+25}, "out-cubic")
	        wait(1)
	        self.noelle:setSprite("party/noelle/dark_c/final_snowgrave_2")
	        Assets.playSound("cardrive")
	        self.timer:tween(0.25, self.noelle, {y=self.noelle.y-50}, "in-quint")
	        wait(0.25)
	        Game.fader:fadeIn(nil, {alpha=1})
	        Assets.playSound("scytheburst")
	        Assets.playSound("mus_sfx_gigapunch")
	        self.noelle:setSprite("party/noelle/dark_c/final_snowgrave_3")
	        Game.battle:shake(2, 0, 0)
	        self.close_value = 0.3
	        self.snow = Assets.playSound("snowgrave_shitty_extension", 0.75)
	        self.snow:setLooping(true)
	        self.tornado1 = self:spawnObject(SnowGraveTornado(-100))
	        self.tornado2 = self:spawnObject(SnowGraveTornado(SCREEN_WIDTH+100))
	        self.tornado1:setLayer(BATTLE_LAYERS["top"])
	        self.tornado2:setLayer(BATTLE_LAYERS["top"])
	        local final = self.timer:everyInstant(2, function()
	        	for i=1,SCREEN_HEIGHT/10, 3 do
	        		local bullet = self:spawnBullet("lonelySnow", self.tornado1.x, 10*i, math.rad(Utils.random(-60, 60)), 2)
	        		bullet.remove_offscreen = false
	        		bullet = self:spawnBullet("lonelySnow", self.tornado2.x, 10*i, math.rad(Utils.random(120, 250)), 2)
	        		bullet.remove_offscreen = false
	        	end
	        end)
	        wait(12)
	        print("Intensify")
	        Assets.playSound("mus_sfx_abreak", 1, 0.8)
	        self.snow:setPitch(1.2)
	        local s=Assets.playSound("snowwind", 1, 1.1)
	        Game.fader:fadeIn(nil, {alpha=1})
	        Game.battle:shake(4, 0, 0)
	        self.close_value = 0.6
	        self.noelle:setSprite("party/noelle/dark_c/final_snowgrave_4")
	        Game.battle.encounter.gradient:setLayer(self.tornado1.layer-1)
	        Game.battle.encounter.gradient.alpha = 0.5
	        Game.battle.encounter.gradient:setParent(Game.battle)
	        Game.battle.encounter.snow:setLayer(self.tornado1.layer-1)
	        Game.battle.encounter.snow.physics.speed = 20
	        Game.battle.encounter.snow:setParent(Game.battle)
	        while self.tornado1.x < (SCREEN_WIDTH/2)-186 do
	        	print(self.tornado1.x, (SCREEN_WIDTH/2)-186)
	        	wait()
	        end
	        Game.battle.soul.collider = nil
	        Game.fader:fadeOut(nil, {color={1, 1, 1}, speed=1})
	        wait(2)
	        Game.fader:fadeIn()
	        s:stop()
	        self.snow:stop()
	        Game.battle:stopShake()
	        Game.battle.encounter.gradient:remove()
	        Game.battle.encounter.snow:remove()
	        Game.battle.encounter.noelle.text = {"* ..."}
	        Game.battle.encounter.noelle.defense = -100
	        Game.battle.encounter.noelle.attack = Game.battle.encounter.noelle.attack/2
	        Game.battle.arena.color = {0, 0.75, 0}
	        self.finished = true
		end)
	end)
end

function Final:update()
	super.update(self)
	if self.fly_noelle then
		--self.noelle.x = SCREEN_WIDTH/2 + math.cos(Kristal.getTime()*2)*6
        self.noelle.y = (SCREEN_HEIGHT/2)-150 + math.sin(Kristal.getTime()*3)*20
    end
    if self.tornado1 then
    	print(self.tornado1.x+100, Game.battle.soul.x)
    	self.tornado1.x = self.tornado1.x + self.close_value*DTMULT
    	if (Game.battle.soul.x < self.tornado1.x + 100) and Game.battle.soul.collider then
    		Game.battle:hurt(Game.battle.encounter.noelle.attack * 5, false, "ANY")
    		Game.battle.soul.inv_timer = (4/3)
			Game.battle.soul:onDamage(self, damage)
			Game.battle.soul:setPosition(self.tornado1.x+115, Game.battle.soul.y)
		end
    end
    if self.tornado2 then
    	self.tornado2.x = self.tornado2.x - self.close_value*DTMULT
    	if (Game.battle.soul.x > self.tornado2.x - 100) and Game.battle.soul.collider then
    		Game.battle:hurt(Game.battle.encounter.noelle.attack * 5, false, "ANY")
    		Game.battle.soul.inv_timer = (4/3)
			Game.battle.soul:onDamage(self, damage)
			Game.battle.soul:setPosition(self.tornado2.x-115, Game.battle.soul.y)
    	end
    end

    if not Game.battle.soul.collider then
    	self.snow:setPitch(self.snow:getPitch()+0.05)
    end
end

return Final