
_G.HexCellEdge = {};
HexCellEdge.__index = HexCellEdge;

function HexCellEdge:New(dwtype)
	local t = {}
	setmetatable(t, HexCellEdge)
	t.dwtype = dwtype;
	t.cell = nil;
	t.otherCell = nil;
	t.direction = nil;
	t.objRes = nil;
	return t;
end

function HexCellEdge:Initialize(cell, otherCell, direction)
	self.cell = cell;
	self.otherCell = otherCell;
	self.direction = direction;
	cell:SetEdge(direction.direction, self);
	if self.objRes then 
		self.objRes.transform.parent = cell.objRes.transform;
		self.objRes.transform.localPosition = Vector3.zero;
		-- self.objRes.transform.localPosition = cell.objRes.transform.localPosition;
		self.objRes.transform.localRotation = direction:ToRotation();
		self.objHinge = self.objRes.transform:Find("Hinge");
		if self.dwtype == 2 then 
			self.objRes.transform:GetChild(0):GetComponent("Renderer").material = cell.room.wallMaterial;
		end
	end
	if self.dwtype == 3 then 
		self:InitDoor();
	end
end

function HexCellEdge:InitDoor()
	local otherDoor = self:OtherSideOfDoor();
	if otherDoor ~= nil then 
		self.isMirrored = true
		self.objHinge.transform.localScale = Vector3(-1,1,1);
		local p = self.objHinge.transform.localPosition;
		p.x = -p.x;
		self.objHinge.transform.localPosition = p
	end
	for i=0,self.objRes.childCount-1 do 
		local child = self.objRes:GetChild(i);
		if child ~= self.objHinge then 
			child:GetComponent("Renderer").material = self.cell.room.wallMaterial;
		end
	end
end

function HexCellEdge:OtherSideOfDoor()
	return self.otherCell:GetEdge(self.direction:GetOpposite().direction)
end

local normalRotation = Quaternion.Euler(0, -90, 0)
local mirroredRotation = Quaternion.Euler(0, 90, 0)

function HexCellEdge:OnPlayerEntered()
	if self.dwtype ~= 3 then return end

	local otherDoor = self:OtherSideOfDoor();
	if self.isMirrored then 
		self.objHinge.localRotation = mirroredRotation
		otherDoor.objHinge.localRotation = mirroredRotation
	else
		self.objHinge.localRotation = normalRotation
		otherDoor.objHinge.localRotation = normalRotation
	end
	otherDoor.cell.room:Show();
end

function HexCellEdge:OnPlayerExited()
	if self.dwtype ~= 3 then return end

	local otherDoor = self:OtherSideOfDoor();
	self.objHinge.localRotation = Quaternion.identity
	otherDoor.objHinge.localRotation = Quaternion.identity

	otherDoor.cell.room:Hide();
end