local GameOver, super = Class("GameOver")

function GameOver:init(x, y)
    super:init(self, x, y)

    print("ded at plot "..Game:getFlag("plot", -999))
    if Game:getFlag("plot", 0)<=3 and Game:getFlag("plot", 0)~=0 then
        self.soul.rotation = math.rad(180)
    end
end

return GameOver