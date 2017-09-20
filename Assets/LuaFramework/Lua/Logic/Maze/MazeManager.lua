
_G.MazeManager = {}
local this = MazeManager;
this.LoadBundles = {"mazeprefab", "mazematerials"}
function MazeManager.Init()
	if this.bInit == true then return end
	-- this.objMazeRoot = GameObject.New("MazeRoot");
	-- this.objMazeRoot.transform.localPosition = Vector3(123,23,1);
	-- local objMaterial = newObject(Resources.Load("MazePrefab/Maze Wall"));
	-- objMaterial.name = "1234"
	-- local floorMaterial = Resources.Load("MazeMaterials/Floor 1")
	-- objMaterial.transform:GetChild(0):GetComponent("Renderer").material = floorMaterial;

 	local maze_pool = poolMgr:Create("Maze_")
 	maze_pool.group.localPosition = Vector3(-8,0,0);
 	local objs = resMgr:LoadPrefabSync("mazeprefab", {"Maze Cell", "Maze Door", "Maze Wall", "Maze Passage", "SrpgcPlayer"});
 	this.trans_cell = objs[0].transform
 	local cell_pool = prefabPool.New(this.trans_cell);
 	cell_pool.preloadAmount = 5;
    cell_pool.cullDespawned = true;
    cell_pool.cullAbove = 10;
    cell_pool.cullDelay = 1;
    cell_pool.limitInstances = false;
    cell_pool.limitAmount = 5;
    cell_pool.limitFIFO = true;
    maze_pool:CreatePrefabPool(cell_pool)

    this.trans_door = objs[1].transform
    local door_pool = prefabPool.New(this.trans_door);
 	door_pool.preloadAmount = 5;
    door_pool.cullDespawned = true;
    door_pool.cullAbove = 10;
    door_pool.cullDelay = 1;
    door_pool.limitInstances = false;
    door_pool.limitAmount = 5;
    door_pool.limitFIFO = true;
    maze_pool:CreatePrefabPool(door_pool)

    this.trans_wall = objs[2].transform
    local wall_pool = prefabPool.New(this.trans_wall);
 	wall_pool.preloadAmount = 5;
    wall_pool.cullDespawned = true;
    wall_pool.cullAbove = 10;
    wall_pool.cullDelay = 1;
    wall_pool.limitInstances = false;
    wall_pool.limitAmount = 5;
    wall_pool.limitFIFO = true;
    maze_pool:CreatePrefabPool(wall_pool)

    this.trans_passage = objs[3].transform
    local passage_pool = prefabPool.New(this.trans_passage);
 	passage_pool.preloadAmount = 5;
    passage_pool.cullDespawned = true;
    passage_pool.cullAbove = 10;
    passage_pool.cullDelay = 1;
    passage_pool.limitInstances = false;
    passage_pool.limitAmount = 5;
    passage_pool.limitFIFO = true;
    maze_pool:CreatePrefabPool(passage_pool)

    MazePlayer.objPrefab = objs[4]

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
   	this.roomSettings = roomSettings;

   	roomSettings.length = length;

    this.maze_pool = maze_pool;

    local objCamera = GameObject.New("PreviewCamera"):AddComponent(typeof(UnityEngine.Camera))
	objCamera.transform.localPosition = Vector3(-7,15,-7)
	objCamera.transform.localRotation = Quaternion.Euler(60, 0, 0)
	objCamera.depth = 1;
	this.objCamera = objCamera;

	this.bInit = true;
--------------------------------------------
  -- for i=1, 50 do 
  -- 	local inst = maze_pool:Spawn(this.trans_cell)
  -- 	inst.localPosition = Vector3(i*2,0,0);
  -- end

  -- while maze_pool.Count > 15 do 
  -- 	logWarn("Cell:Despawn:", maze_pool.Count);
  -- 	local inst = maze_pool[maze_pool.Count-1]
  -- 	maze_pool:Despawn(inst);
  -- end

  -- for i=1, 50 do 
  -- 	local inst = maze_pool:Spawn(this.trans_door)
  -- 	inst.localPosition = Vector3(i*2,0,0);
  -- end

  -- while maze_pool.Count > 0 do 
  -- 	logWarn("Door:Despawn:", maze_pool.Count);
  -- 	local inst = maze_pool[maze_pool.Count-1]
  -- 	maze_pool:Despawn(inst);
  -- end
end

local function RandomCoordinates()
	-- math.randomseed(os.time())
	-- math.randomseed(tostring(os.time()):reverse():sub(1, 6)) 
	return Vector2(math.random(0, this.setting.size.x-1), math.random(0, this.setting.size.y-1))
end
local function ContainsCoordinates(coordinate) 
	return coordinate.x >= 0 and coordinate.x < this.setting.size.x and coordinate.y >= 0 and coordinate.y < this.setting.size.y;
end

local function CreateCell(coordinates)
	local newCell = MazeCell:New(coordinates);
	local x = coordinates.x;
	local y = coordinates.y;
	this.cells[x][y] = newCell;
	local objRes = this.maze_pool:Spawn(this.trans_cell);
	objRes.name = "Maze Cell"..x..","..y;
	objRes.localPosition = Vector3(x-this.setting.size.x*0.5+0.5, 0, y-this.setting.size.y*0.5+0.5);
	newCell.objRes = objRes;
	return newCell;
end

local function CreateRoom(indexToExclude)
	local newRoom = MazeRoom:New();
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local dwIndex = math.random(0, this.roomSettings.length-1);
	if dwIndex == indexToExclude then 
		dwIndex = (dwIndex+1)%this.roomSettings.length;
	end
	newRoom.floorMaterial = this.roomSettings[dwIndex+1].floorMaterial;
	newRoom.wallMaterial = this.roomSettings[dwIndex+1].wallMaterial;
	newRoom.settingsIndex = dwIndex;

	table.insert(this.rooms, newRoom);
	return newRoom;
end

local function CreatePassage(cell, otherCell, direction)
	local dwType = 1;
	local trans = this.trans_passage;
	if math.random(1,10000)/10000<this.setting.doorProbability then 
		dwType = 3;
		trans = this.trans_door;
	end
	local passage = MazeCellEdge:New(dwType)
	passage.objRes = this.maze_pool:Spawn(trans);
	passage:Initialize(cell, otherCell, direction)
	passage = MazeCellEdge:New(dwType);
	passage.objRes = this.maze_pool:Spawn(trans);
	if dwType == 3 then 
		otherCell:Initialize(CreateRoom(cell.room.settingsIndex));
	else
		otherCell:Initialize(cell.room);
	end
	passage:Initialize(otherCell, cell, direction:GetOpposite())
end

local function CreatePassageInSameRoom(cell, otherCell, direction)
	local passage = MazeCellEdge:New(1)
	passage.objRes = this.maze_pool:Spawn(this.trans_passage);
	passage:Initialize(cell, otherCell, direction)
	passage = MazeCellEdge:New(1);
	passage.objRes = this.maze_pool:Spawn(this.trans_passage);
	passage:Initialize(otherCell, cell, direction:GetOpposite())
	if cell.room ~= otherCell.room then 
		local roomToAssimilate = otherCell.room;
		cell.room:Assimilate(roomToAssimilate);
		-- table.remove(this.rooms, roomToAssimilate)
		for i, v in pairs(this.rooms) do 
			if v == roomToAssimilate then 
				table.remove(this.rooms, i)
			end
		end
		roomToAssimilate = nil;
	end
end

local function CreateWall(cell, otherCell, direction)
	local wall = MazeCellEdge:New(2)
	wall.objRes = this.maze_pool:Spawn(this.trans_wall);
	wall:Initialize(cell, otherCell, direction)
	if otherCell ~= nil then 
		wall = MazeCellEdge:New(2)
		wall.objRes = this.maze_pool:Spawn(this.trans_wall);
		wall:Initialize(otherCell,cell, direction:GetOpposite())
	end
end

local function GetCell (coordinates)
	return this.cells[coordinates.x][coordinates.y];
end

local default = {
		sizex = 10,
		sizey = 10,
		doorProbability = 0.1;
		roomVisible = true;
	}
function MazeManager.resetting(sizex, sizey, doorProbability, roomVisible)
	this.setting = {};
	this.setting.size = Vector2(sizex or default.sizex,sizey or default.sizey);
	this.setting.doorProbability = doorProbability or default.doorProbability;
	this.setting.roomHide = roomHide or default.roomHide;

end

function MazeManager.getsetting()
	return this.setting or default;
end

function MazeManager.BeginGame()
	this.cells = {};
	this.activeCells = {};
	this.activeCells.length = 0;
	this.rooms = {};
	for i=0,this.setting.size.x do 
		this.cells[i] = {};
	end
	this.DoFirstGenerationStep();
	while this.activeCells.length > 0 do
		coroutine.wait(0.01)
		this.DoNextGenerationStep();
	end
	for _, v in pairs(this.rooms) do 
		v:Hide();
	end
	this.CreatePlayer();
end

function MazeManager.RestartGame()
	-- this.maze_pool:DespawnAll();
	MazePlayer.objRes:SetActive(false)
	for _, v in pairs(this.rooms) do 
		v:Hide();
	end
	this.StartGame();
end

function MazeManager.StartGame()
	if not this.bInit then 
		this.Init();
	end
	this.objCamera.clearFlags = UnityEngine.CameraClearFlags.Skybox;
	this.objCamera.rect = Rect.New(0,0,1,1)
	coroutine.start(this.BeginGame)
end

function MazeManager.CreatePlayer()
	this.objCamera.clearFlags = UnityEngine.CameraClearFlags.Depth;
	this.objCamera.rect = Rect.New(0,0,0.35,0.5)
	MazePlayer.Init()
	MazePlayer.SetLocation(GetCell(RandomCoordinates()));
end


function MazeManager.DoFirstGenerationStep()
	local newCell = CreateCell(RandomCoordinates())
	newCell:Initialize(CreateRoom(-1))
	table.insert(this.activeCells, newCell);
	this.activeCells.length = this.activeCells.length+1;
end

function MazeManager.DoNextGenerationStep()
	local currentIndex = this.activeCells.length;
	local currentCell = this.activeCells[currentIndex];
	if currentCell:IsFullyInitialized() then 
		table.remove(this.activeCells, currentIndex);
		this.activeCells.length = this.activeCells.length-1;
		return
	end
	local direction = currentCell:RandomUninitializedDirection();
	local coordinates = currentCell.coordinates + direction:ToIntVector2();
	if ContainsCoordinates(coordinates) then 
		local neighbor = GetCell(coordinates);
		if neighbor == nil then 
			neighbor = CreateCell(coordinates);
			CreatePassage(currentCell, neighbor, direction);
			table.insert(this.activeCells, neighbor);
			this.activeCells.length = this.activeCells.length+1;
		elseif currentCell.room.settingsIndex == neighbor.room.settingsIndex then 
			CreatePassageInSameRoom(currentCell, neighbor, direction);
		else
			CreateWall(currentCell, neighbor, direction);
		end
	else
		CreateWall(currentCell, nil, direction);
	end
end


