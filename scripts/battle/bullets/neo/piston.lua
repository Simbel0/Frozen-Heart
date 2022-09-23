local piston, super = Class(Bullet)

function piston:init(x, y, dir, speed, shootable, flip)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/neo/crew")
    self:setOrigin(0.5, 0.5)

    self.shootable = shootable~=nil and shootable or true

    self.sprite.flip_x = flip

    if self.shootable then
        self:setColor(21/255, 203/255, 231/255)
    end

    --self.sprite:setScale(0.5, 0.5)
    --self:setHitbox(5, 5, (self.sprite.width/2)-10, (self.sprite.height/2)-10)

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed

    self.piston_bottom = Sprite("bullets/neo/pillar_piston", flip and 5 or -6, (self.sprite.height/2)+5)
    self.piston_bottom:setOrigin(0, 0)
    self.piston_bottom:setLayer(self.layer-10000)
    self:addChild(self.piston_bottom)

    self.piston_bottom_tube = Sprite("bullets/neo/pillar_thicc", flip and 0 or 0, self.piston_bottom.height)
    self.piston_bottom_tube:setOrigin(0, 0)
    self.piston_bottom_tube.scale_y = 999
    self.piston_bottom:addChild(self.piston_bottom_tube)

    self.piston_top = Sprite("bullets/neo/pillar_piston", flip and 5 or 6, -5)
    self.piston_top:setOrigin(1, 1)
    self.piston_top.rotation = math.rad(180)
    self.piston_top:setLayer(self.layer-10000)
    self:addChild(self.piston_top)

    self.piston_top_tube = Sprite("bullets/neo/pillar_thicc", 0, self.piston_top.height)
    self.piston_top_tube:setOrigin(0, 0)
    self.piston_top_tube.scale_y = 999
    self.piston_top:addChild(self.piston_top_tube)
end

function piston:update()
    super:update(self)

end

return piston