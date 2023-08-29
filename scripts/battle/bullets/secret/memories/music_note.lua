local MusicNote, super = Class(Bullet)

function MusicNote:init(line, dir, speed)
    -- Last argument = sprite path
    super:init(self, SCREEN_WIDTH+Utils.random(10, 20), -999, "bullets/memories/music_note")

    self.line = line

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
end

function MusicNote:update()
    -- For more complicated bullet behaviours, code here gets called every update

    if self.wave then
        self.y = self.wave.lines_pos[self.line]
    end

    super:update(self)
end

return MusicNote