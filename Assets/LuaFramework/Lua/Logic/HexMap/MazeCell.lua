
_G.HexDirections = {}
HexDirections.Count = 6;
HexDirections.__index = HexDirections;
-- local HexDirection = { North = 0,East = 1,South = 2,West = 3}
-- local vectors = { Vector2(0,1),Vector2(1,0),Vector2(0,-1),Vector2(-1,0)}
-- local opposites ={ HexDirection.South, HexDirection.West, HexDirection.North, HexDirection.East}
-- local rotations = { Quaternion.identity, Quaternion.Euler(0, 90, 0), Quaternion.Euler(0, 180, 0), Quaternion.Euler(0, 270, 0)};

local HexDirection = { NE = 0, E = 1, SE = 2, SW = 3, W = 4, NW = 5}
local vectors_single = { Vector2(1,1),Vector2(1,0),Vector2(1,-1),Vector2(0,-1), Vector2(-1,0), Vector2(0,1)}
local vectors_double = { Vector2(0,1),Vector2(1,0),Vector2(0,-1),Vector2(-1,-1), Vector2(-1,0), Vector2(-1,1)}
local opposites ={ HexDirection.SW, HexDirection.W, HexDirection.NW, HexDirection.NE, HexDirection.E, HexDirection.SE}
local rotations = { Quaternion.Euler(0, 30, 0), Quaternion.Euler(0, 90, 0), Quaternion.Euler(0, 150, 0), Quaternion.Euler(0, 210, 0), Quaternion.Euler(0, 270, 0), Quaternion.Euler(0, 330, 0)};

function HexDirections:New(direction)
	local t = {}
	setmetatable(t, HexDirections)
	t.direction = direction;
	return t;
end

function HexDirections:ToIntVector2(doub)
	if not doub then 
		return vectors_single[self.direction+1]
	end
	return vectors_double[self.direction+1];
end

function HexDirections:GetOpposite()
	return HexDirections:New(opposites[self.direction+1])
end

function HexDirections:ToRotation()
	return rotations[self.direction+1];
end

function HexDirections:GetNextClockwise()
	return HexDirections:New((self.direction+1)%HexDirections.Count)
end

function HexDirections:GetNextCounterclockwise()
	return HexDirections:New((self.direction-1)%HexDirections.Count)
end



_G.HexCell = {};
HexCell.__index = HexCell;

function HexCell:New(coordinates)
	local t = {};
	setmetatable(t, HexCell)
	t.coordinates = coordinates;
	t.objRes = nil;
	t.edges = {}
	t.room = nil;

	t.initializedEdgeCount = 0;
	return t;
end

function HexCell:Initialize( room )
	room:Add(self);
	self.objRes.transform:GetChild(0):GetComponent("Renderer").material = room.floorMaterial;
end

function HexCell:IsFullyInitialized()
	return self.initializedEdgeCount == HexDirections.Count;
end

function HexCell:RandomUninitializedDirection()
	local skips = math.random(0, HexDirections.Count-self.initializedEdgeCount-1)
	for i=0,HexDirections.Count do 
		if self.edges[i] == nil then 
			if skips == 0 then 
				return HexDirections:New(i);
			end
			skips = skips - 1;
		end
	end
	logError("HexCell has no uninitialized directions left.", self.initializedEdgeCount,":", self.coordinates.x, ":", self.coordinates.y)
end

function HexCell:SetEdge (direction, edge)
	self.edges[direction] = edge;
	self.initializedEdgeCount = self.initializedEdgeCount + 1;
end

function HexCell:GetEdge(direction)
	return self.edges[direction];
end

function HexCell:Show()
	local setting = HexManager.getsetting()
	if not setting.roomHide then return end
	self.objRes.gameObject:SetActive(true)
end

function HexCell:Hide()
	local setting = HexManager.getsetting()
	if not setting.roomHide then return end
	self.objRes.gameObject:SetActive(false)
end

function HexCell:OnPlayerEntered()
	self.room:Show();
	for i, v in pairs(self.edges) do 
		v:OnPlayerEntered();
	end
end

function HexCell:OnPlayerExited()
	self.room:Hide()
	for i, v in pairs(self.edges) do 
		v:OnPlayerExited();
	end
end

