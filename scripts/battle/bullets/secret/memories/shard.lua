local loved, super = Class(Bullet)

function loved:init(x, y)
    -- Last argument = sprite path
    super:init(self, x, y, "bullets/memories/shard")
end

return loved