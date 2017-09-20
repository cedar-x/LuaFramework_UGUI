
_G.HexManager = {}
local self = HexManager;
self.LoadBundles = {"hexprefab", "mazematerials"}
function HexManager.Init()
	if self.bInit == true then return end
	-- self.objMazeRoot = GameObject.New("MazeRoot");
	-- self.objMazeRoot.transform.localPosition = Vector3(123,23,1);
	-- local objMaterial = newObject(Resources.Load("MazePrefab/Maze Wall"));
	-- objMaterial.name = "1234"
	-- local floorMaterial = Resources.Load("MazeMaterials/Floor 1")
	-- objMaterial.transform:GetChild(0):GetComponent("Renderer").material = floorMaterial;

 	local maze_pool = poolMgr:Create("Maze_")
 	maze_pool.group.localPosition = Vector3(-8,0,0);
 	local objs = resMgr:LoadPrefabSync("hexprefab", {"Maze Cell", "Maze Door", "Maze Wall", "Maze Passage", "SrpgcPlayer"});
 	self.trans_cell = objs[0].transform
 	local cell_pool = prefabPool.New(self.trans_cell);
 	cell_pool.preloadAmount = 5;
    cell_pool.cullDespawned = true;
    cell_pool.cullAbove = 10;
    cell_pool.cullDelay = 1;
    cell_pool.limitInstances = false;
    cell_pool.limitAmount = 5;
    cell_pool.limitFIFO = true;
    maze_pool:CreatePrefabPool(cell_pool)

    self.trans_door = objs[1].transform
    local door_pool = prefabPool.New(self.trans_door);
 	door_pool.preloadAmount = 5;
    door_pool.cullDespawned = true;
    door_pool.cullAbove = 10;
    door_pool.cullDelay = 1;
    door_pool.limitInstances = false;
    door_pool.limitAmount = 5;
    door_pool.limitFIFO = true;
    maze_pool:CreatePrefabPool(door_pool)

    self.trans_wall = objs[2].transform
    local wall_pool = prefabPool.New(self.trans_wall);
 	wall_pool.preloadAmount = 5;
    wall_pool.cullDespawned = true;
    wall_pool.cullAbove = 10;
    wall_pool.cullDelay = 1;
    wall_pool.limitInstances = false;
    wall_pool.limitAmount = 5;
    wall_pool.limitFIFO = true;
    maze_pool:CreatePrefabPool(wall_pool)

    self.trans_passage = objs[3].transform
    local passage_pool = prefabPool.New(self.trans_passage);
 	passage_pool.preloadAmount = 5;
    passage_pool.cullDespawned = true;
    passage_pool.cullAbove = 10;
    passage_pool.cullDelay = 1;
    passage_pool.limitInstances = false;
    passage_pool.limitAmount = 5;
    passage_pool.limitFIFO = true;
    maze_pool:CreatePrefabPool(passage_pool)

    HexPlayer.objPrefab = objs[4]

	local roomSettings = {};
    local length = 4;
    local tabRes = {};
    for i=1,length do 
    	table.insert(tabRes, "Floor "..i)
    	table.insert(tabRes, "Walls "..i)
    end
    objs = resMgr:LoadMetarialSync("mazematerials", tabRes);
    for i=0, length-1 do 
   		local floorRes = {}
   		floorRes.floorMaterial = newObject(objs[2*i])
   		floorRes.wallMaterial = newObject(objs[2*i+1])
   		table.insert(roomSettings, floorRes);
   	end
   	self.roomSettings = roomSettings;

   	roomSettings.length = length;

    self.maze_pool = maze_pool;

    local objCamera = GameObject.New("PreviewCamera"):AddComponent(typeof(UnityEngine.Camera))
	objCamera.transform.localPosition = Vector3(-7,15,-7)
	objCamera.transform.localRotation = Quaternion.Euler(60, 0, 0)
	objCamera.depth = 1;
	self.objCamera = objCamera;

	self.bInit = true;
end

local function RandomCoordinates()
	-- math.randomseed(os.time())
	-- math.randomseed(tostring(os.time()):reverse():sub(1, 6)) 
	return Vector2(math.random(0, self.setting.size.x-1), math.random(0, self.setting.size.y-1))
end
local function ContainsCoordinates(coordinate) 
	return coordinate.x >= 0 and coordinate.x < self.setting.size.x and coordinate.y >= 0 and coordinate.y < self.setting.size.y;
end
local outerRadius = 1;
-- local innerRadius = outerRadius * 0.866025404;
local innerRadius = outerRadius*0.866;
local width = 2*innerRadius;
local height = 1.5*outerRadius;

local function CreateCell(coordinates)
	local newCell = HexCell:New(coordinates);
	local x = coordinates.x;
	local y = coordinates.y;
	self.cells[x][y] = newCell;
	local objRes = self.maze_pool:Spawn(self.trans_cell);
	objRes.name = "Maze Cell"..x..","..y;
	local nx = x*width;
	local ny = y*height;
	if y%2==1 then 
		nx = nx + innerRadius;
	end
	objRes.localPosition = Vector3(nx-self.setting.size.x*0.5+0.5, 0, ny-self.setting.size.y*0.5+0.5);
	newCell.objRes = objRes;
	return newCell;
end

local function CreateRoom(indexToExclude)
	local newRoom = HexRoom:New();
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local dwIndex = math.random(0, self.roomSettings.length-1);
	if dwIndex == indexToExclude then 
		dwIndex = (dwIndex+1)%self.roomSettings.length;
	end
	newRoom.floorMaterial = self.roomSettings[dwIndex+1].floorMaterial;
	newRoom.wallMaterial = self.roomSettings[dwIndex+1].wallMaterial;
	newRoom.settingsIndex = dwIndex;

	table.insert(self.rooms, newRoom);
	return newRoom;
end

local function CreatePassage(cell, otherCell, direction)
	local dwType = 1;
	local trans = self.trans_passage;
	if math.random(1,10000)/10000<self.setting.doorProbability then 
		dwType = 3;
		trans = self.trans_door;
	end
	local passage = HexCellEdge:New(dwType)
	passage.objRes = self.maze_pool:Spawn(trans);
	passage:Initialize(cell, otherCell, direction)
	passage = HexCellEdge:New(dwType);
	passage.objRes = self.maze_pool:Spawn(trans);
	if dwType == 3 then 
		otherCell:Initialize(CreateRoom(cell.room.settingsIndex));
	else
		otherCell:Initialize(cell.room);
	end
	passage:Initialize(otherCell, cell, direction:GetOpposite())
end

local function CreatePassageInSameRoom(cell, otherCell, direction)
	local passage = HexCellEdge:New(1)
	passage.objRes = self.maze_pool:Spawn(self.trans_passage);
	passage:Initialize(cell, otherCell, direction)
	passage = HexCellEdge:New(1);
	passage.objRes = self.maze_pool:Spawn(self.trans_passage);
	passage:Initialize(otherCell, cell, direction:GetOpposite())
	if cell.room ~= otherCell.room then 
		local roomToAssimilate = otherCell.room;
		cell.room:Assimilate(roomToAssimilate);
		-- table.remove(self.rooms, roomToAssimilate)
		for i, v in pairs(self.rooms) do 
			if v == roomToAssimilate then 
				table.remove(self.rooms, i)
			end
		end
		roomToAssimilate = nil;
	end
end

local function CreateWall(cell, otherCell, direction)
	local wall = HexCellEdge:New(2)
	wall.objRes = self.maze_pool:Spawn(self.trans_wall);
	wall:Initialize(cell, otherCell, direction)
	if otherCell ~= nil then 
		wall = HexCellEdge:New(2)
		wall.objRes = self.maze_pool:Spawn(self.trans_wall);
		wall:Initialize(otherCell,cell, direction:GetOpposite())
	end
end

local function GetCell (coordinates)
	return self.cells[coordinates.x][coordinates.y];
end

local default = {
		sizex = 10,
		sizey = 10,
		doorProbability = 0.1;
		roomVisible = true;
	}
function HexManager.resetting(sizex, sizey, doorProbability, roomVisible)
	self.setting = {};
	self.setting.size = Vector2(sizex or default.sizex,sizey or default.sizey);
	self.setting.doorProbability = doorProbability or default.doorProbability;
	self.setting.roomHide = roomHide or default.roomHide;

end

function HexManager.getsetting()
	return self.setting or default;
end

function HexManager.BeginGame()
	self.cells = {};
	self.activeCells = {};
	self.activeCells.length = 0;
	self.rooms = {};
	for i=0,self.setting.size.x do 
		self.cells[i] = {};
	end
	self.DoFirstGenerationStep();
	while self.activeCells.length > 0 do
		coroutine.wait(0.01)
		self.DoNextGenerationStep();
	end
	for _, v in pairs(self.rooms) do 
		v:Hide();
	end
	self.CreatePlayer();
end

function HexManager.RestartGame()
	-- self.maze_pool:DespawnAll();
	HexPlayer.objRes:SetActive(false)
	for _, v in pairs(self.rooms) do 
		v:Hide();
	end
	self.StartGame();
end

function HexManager.StartGame()
	if not self.bInit then 
		self.Init();
	end
	self.objCamera.clearFlags = UnityEngine.CameraClearFlags.Skybox;
	self.objCamera.rect = Rect.New(0,0,1,1)
	coroutine.start(self.BeginGame)
end

function HexManager.CreatePlayer()
	self.objCamera.clearFlags = UnityEngine.CameraClearFlags.Depth;
	self.objCamera.rect = Rect.New(0,0,0.35,0.5)
	HexPlayer.Init()
	HexPlayer.SetLocation(GetCell(RandomCoordinates()));
end


function HexManager.DoFirstGenerationStep()
	local newCell = CreateCell(RandomCoordinates())
	newCell:Initialize(CreateRoom(-1))
	table.insert(self.activeCells, newCell);
	self.activeCells.length = self.activeCells.length+1;
end

function HexManager.DoNextGenerationStep()
	local currentIndex = self.activeCells.length;
	local currentCell = self.activeCells[currentIndex];
	if currentCell:IsFullyInitialized() then 
		table.remove(self.activeCells, currentIndex);
		self.activeCells.length = self.activeCells.length-1;
		return
	end
	local direction = currentCell:RandomUninitializedDirection();
	local doub = currentCell.coordinates.y%2==0
	local coordinates = currentCell.coordinates + direction:ToIntVector2(doub);
	if ContainsCoordinates(coordinates) then 
		local neighbor = GetCell(coordinates);
		if neighbor == nil then 
			neighbor = CreateCell(coordinates);
			CreatePassage(currentCell, neighbor, direction);
			table.insert(self.activeCells, neighbor);
			self.activeCells.length = self.activeCells.length+1;
		elseif currentCell.room.settingsIndex == neighbor.room.settingsIndex then 
			CreatePassageInSameRoom(currentCell, neighbor, direction);
		else
			CreateWall(currentCell, neighbor, direction);
		end
	else
		CreateWall(currentCell, nil, direction);
	end
end


