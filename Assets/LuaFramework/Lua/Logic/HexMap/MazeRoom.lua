
_G.HexRoom = {};
HexRoom.__index = HexRoom;

function HexRoom:New()
	local t = {}
	setmetatable(t, HexRoom)
	t.floorMaterial = nil;
	t.wallMaterial = nil;
	t.cells = {};
	return t;
end

function HexRoom:Add(cell)
	cell.room = self;
	table.insert(self.cells, cell);
end

function HexRoom:Assimilate(room)
	for _, cell in pairs(room.cells) do 
		self:Add(cell)
	end
end

function HexRoom:Hide()
	for _, v in pairs(self.cells) do 
		v:Hide()
	end
end

function HexRoom:Show()
	for _, v in pairs(self.cells) do 
		v:Show()
	end
end

