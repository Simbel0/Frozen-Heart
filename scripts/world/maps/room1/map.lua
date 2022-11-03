local map, super = Class(Map)

function map:onEnter()
	super:onEnter(self)
	self.previous_party = {}
	for i,v in ipairs(Game.party) do
		table.insert(self.previous_party, v.id)
	end
	Game:setPartyMembers("kris")
end

function map:onExit()
	super:onExit(self)
	Game:setPartyMembers(Utils.unpack(self.previous_party))
end

return map