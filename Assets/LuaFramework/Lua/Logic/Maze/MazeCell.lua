
_G.MazeDirections = {}
MazeDirections.Count = 4;
MazeDirections.__index = MazeDirections;
local MazeDirection = { North = 0,East = 1,South = 2,West = 3}
local vectors = { Vector2(0,1),Vector2(1,0),Vector2(0,-1),Vector2(-1,0)}
local opposites ={ MazeDirection.South, MazeDirection.West, MazeDirection.North, MazeDirection.East}
local rotations = { Quaternion.identity, Quaternion.Euler(0, 90, 0), Quaternion.Euler(0, 180, 0), Quaternion.Euler(0, 270, 0)};
function MazeDirections:New(direction)
	local t = {}
	setmetatable(t, MazeDirections)
	t.direction = direction;
	return t;
end

function MazeDirections:ToIntVector2()
	return vectors[self.direction+1]
end

function MazeDirections:GetOpposite()
	return MazeDirections:New(opposites[self.direction+1])
end

function MazeDirections:ToRotation()
	return rotations[self.direction+1];
end

function MazeDirections:GetNextClockwise()
	return MazeDirections:New((self.direction+1)%MazeDirections.Count)
end

function MazeDirections:GetNextCounterclockwise()
	return MazeDirections:New((self.direction-1)%MazeDirections.Count)
end



_G.MazeCell = {};
MazeCell.__index = MazeCell;

function MazeCell:New(coordinates)
	local t = {};
	setmetatable(t, MazeCell)
	t.coordinates = coordinates;
	t.objRes = nil;
	t.edges = {}
	t.room = nil;

	t.initializedEdgeCount = 0;
	return t;
end

function MazeCell:Initialize( room )
	room:Add(self);
	self.objRes.transform:GetChild(0):GetComponent("Renderer").material = room.floorMaterial;
end

function MazeCell:IsFullyInitialized()
	return self.initializedEdgeCount == MazeDirections.Count;
end

function MazeCell:RandomUninitializedDirection()
	local skips = math.random(0, MazeDirections.Count-self.initializedEdgeCount-1)
	for i=0,MazeDirections.Count do 
		if self.edges[i] == nil then 
			if skips == 0 then 
				return MazeDirections:New(i);
			end
			skips = skips - 1;
		end
	end
	logError("MazeCell has no uninitialized directions left.")
end

function MazeCell:SetEdge (direction, edge)
	self.edges[direction] = edge;
	self.initializedEdgeCount = self.initializedEdgeCount + 1;
end

function MazeCell:GetEdge(direction)
	return self.edges[direction];
end

function MazeCell:Show()
	local setting = MazeManager.getsetting()
	if not setting.roomHide then return end
	self.objRes.gameObject:SetActive(true)
end

function MazeCell:Hide()
	local setting = MazeManager.getsetting()
	if not setting.roomHide then return end
	self.objRes.gameObject:SetActive(false)
end

function MazeCell:OnPlayerEntered()
	self.room:Show();
	for i, v in pairs(self.edges) do 
		v:OnPlayerEntered();
	end
end

function MazeCell:OnPlayerExited()
	self.room:Hide()
	for i, v in pairs(self.edges) do 
		v:OnPlayerExited();
	end
end

