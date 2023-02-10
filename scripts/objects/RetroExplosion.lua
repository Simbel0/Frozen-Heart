local RetroExplosion, super = Class(Explosion)

function RetroExplosion:init(x, y)
	super:init(self, x, y)

	self.frames = Assets.getFrames("vector_explosion")
	self.width = self.frames[1]:getWidth()
	self.height = self.frames[1]:getHeight()

	self.speed = 0.1333
end

function RetroExplosion:onAdd()
    if self.play_sound then
        Assets.playSound("snd_explosion_8bit")
    end
end

function RetroExplosion:update()
    self.time = self.time + (self.speed * DTMULT)

    self.frame = (math.floor(self.time)%2) + 1
    if self.time >= 5.4 then
        self:remove()
    end

    super.super.update(self)
end

return RetroExplosion