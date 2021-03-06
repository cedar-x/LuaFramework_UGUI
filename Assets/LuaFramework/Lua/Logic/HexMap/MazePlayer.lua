
_G.HexPlayer = {}
local this = HexPlayer;

function HexPlayer.Init()
	if not this.objRes then 
		-- this.objRes = newObject(Resources.Load("MazePrefab/SrpgcPlayer"));
		this.objRes = newObject(this.objPrefab);
		UpdateBeat:Add(this.Update, self)
	end
	this.objRes:SetActive(true)
	this.currentDirection = HexDirections:New(0)
end

function HexPlayer.SetLocation(cell)
	if this.currentCell then 
		this.currentCell:OnPlayerExited();
	end
	this.currentCell = cell;
	this.objRes.transform.position = cell.objRes.transform.position;
	this.currentCell:OnPlayerEntered()
end

function HexPlayer.Move(direction)
	-- logWarn("HexPlayer.Move:", direction.direction)
	local edge = this.currentCell:GetEdge(direction.direction)
	if edge.dwtype ~= 2 then 
		this.SetLocation(edge.otherCell);
	end
end

function HexPlayer.Look(direction)
	this.objRes.transform.localRotation = direction:ToRotation();
	this.currentDirection = direction;
end

function HexPlayer.Update()
	if Input.GetKeyDown(KeyCode.W) or Input.GetKeyDown(KeyCode.UpArrow) then
		this.Move(this.currentDirection);
	elseif Input.GetKeyDown(KeyCode.D) or Input.GetKeyDown(KeyCode.RightArrow) then
		this.Move(this.currentDirection:GetNextClockwise());
	elseif Input.GetKeyDown(KeyCode.S) or Input.GetKeyDown(KeyCode.DownArrow) then
		this.Move(this.currentDirection:GetOpposite());
	elseif Input.GetKeyDown(KeyCode.A) or Input.GetKeyDown(KeyCode.LeftArrow) then
		this.Move(this.currentDirection:GetNextCounterclockwise());
	elseif Input.GetKeyDown(KeyCode.Q) then
		this.Look(this.currentDirection:GetNextCounterclockwise());
	elseif Input.GetKeyDown(KeyCode.E) then
		this.Look(this.currentDirection:GetNextClockwise());
	end
end