
_G.MazeRoom = {};
MazeRoom.__index = MazeRoom;

function MazeRoom:New()
	local t = {}
	setmetatable(t, MazeRoom)
	t.floorMaterial = nil;
	t.wallMaterial = nil;
	t.cells = {};
	return t;
end

function MazeRoom:Add(cell)
	cell.room = self;
	table.insert(self.cells, cell);
end

function MazeRoom:Assimilate(room)
	for _, cell in pairs(room.cells) do 
		self:Add(cell)
	end
end

function MazeRoom:Hide()
	for _, v in pairs(self.cells) do 
		v:Hide()
	end
end

function MazeRoom:Show()
	for _, v in pairs(self.cells) do 
		v:Show()
	end
end

