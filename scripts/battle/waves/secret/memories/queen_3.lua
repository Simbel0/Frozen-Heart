local History, super = Class(Wave)

function History:init()
	super:init(self)

	self.time = 10
end

function History:onStart()
	self.folder = self:spawnSprite("bullets/memories/folder", Game.battle.arena.left+Game.battle.arena.width/2, Game.battle.arena.top-30)
	self.folder:setLayer(BATTLE_LAYERS["top"])
	self.timer:after(0.5, function()
		self.timer:tween(1, self.folder, {rotation=math.rad(180)}, "out-back", function()
			print("da fuwamoco")
			self.timer:everyInstant(1/6, function()
				self:spawnBullet("secret/memories/file", self.folder.x, self.folder.y+10)
			end)
		end)
	end)
	--self:spawnBullet("secret/memories/file", Game.battle.arena.left-75, Game.battle.arena.top+Game.battle.arena.height/2)
end

return History