local you_ve_got_mail, super = Class(Wave)

function you_ve_got_mail:init()
    super:init(self)
    self.time=-1
end

function you_ve_got_mail:onStart()
    local sneo = self.encounter.sneo
    self.org_y=sneo.y
    local arm = sneo.sprite:getPart("arm_l")
    sneo.sprite:setPartSprite("arm_l", "npcs/spamton/arm_cannon")
    sneo.sprite:setPartSwingSpeed("arm_l", 0)
    sneo.sprite:setHeadFrame(3)
    sneo.sprite:tweenPartRotation("arm_l", math.rad(170), 0.3, "out-cubic")
    self.timer:tween(0.3, sneo, {y=260}, "out-cubic")
    local x, y = arm:getScreenPos()
    local laser = self:spawnSprite("bullets/neo/laser_friendly", x-67, y+46)
    laser:setOrigin(1, 0.5)
    laser:setGraphics({
    	fade = 0.3,
    	fade_to = 0,
    	fade_callback = function(laser)
    		laser.graphics.fade = 0.3
    	end
    })
    laser.alpha = 0
    self.timer:script(function(wait)
    	print("Start", laser.graphics.fade, laser.graphics.fade_to)
    	wait(0.4)
    	print("1", laser.graphics.fade, laser.graphics.fade_to)
    	Assets.playSound("noise")
    	laser.alpha = 0.5
    	wait(0.5)
    	print("2", laser.graphics.fade, laser.graphics.fade_to)
    	Assets.playSound("noise")
    	laser.alpha = 0.5
    	wait(0.35)
    	print("3", laser.graphics.fade, laser.graphics.fade_to)
    	Assets.playSound("noise")
    	laser.alpha = 0.5
    	wait(0.25)
    	print("4", laser.graphics.fade, laser.graphics.fade_to)
    	Assets.playSound("noise")
    	laser.alpha = 0.5
    	wait(0.15)
    	print("End", laser.graphics.fade, laser.graphics.fade_to)
    	laser:resetGraphics()
    	laser.alpha = 1
    	laser:setScale(1.15, 0)
    	self.timer:tween(0.2, laser, {scale_y=1})
    	Game.stage:shake(2, 2, 0, 1/30)
    	laser:setSprite("bullets/neo/laser")
    	local ow = self.timer:during(math.huge, function()
    		Game.battle:hurt(3, true, "ANY")
    		--There's some bug in kristal where a downed battler will still take damage in the next frame, keeping them up despite being down
    		--So i'm calling battler:down() manually to be sure that they are put down *and stay down*
    		for i,battler in ipairs(Game.battle.party) do
    			if battler.chara:getHealth() <= 0 then
    				battler:down()
    			end
    		end
        	Game.battle.soul.inv_timer = 0.1
        	if Game.battle.soul.x > Game.battle.arena.left then
        		Game.battle.soul:move(-2, 0)
        	end
    	end)
    	wait(2)
    	self.timer:cancel(ow)
    	self.timer:tween(0.2, laser, {scale_y=0}, nil, function()
    		laser:remove()
    	end)
    	Game.stage:shake(2, 2, 0.5, 1/30)
    	wait(1)
    	self.finished = true
    end)
end

function you_ve_got_mail:update()

    super:update(self)
end

function you_ve_got_mail:onEnd()
    local sneo = self.encounter.sneo

    sneo.sprite:resetPart("arm_l", true)

    Game.battle.timer:tween(0.5, sneo, {y=self.org_y}, "out-cubic")

    super:onEnd(self)
end

return you_ve_got_mail