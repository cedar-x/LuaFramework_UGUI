require "3rd/pblua/login_pb"
require "3rd/pbc/protobuf"

local lpeg = require "lpeg"
local json = require "cjson"
local util = require "3rd/cjson/util"
local sproto = require "3rd/sproto/sproto"
local core = require "sproto.core"
local print_r = require "3rd/sproto/print_r"

require "Config/IncludeC"
require "Logic/LuaClass"
require "Logic/CtrlManager"
require "Common/functions"
require "Common/IndexDataMgr"
require "View/UIViewer"

--管理器--
Game = {};
local this = Game;

function Game.InitViewPanels()
    require "Controller/Include"

    require "Common/define"

end

--初始化完成，发送链接服务器信息--
function Game.OnInitOK()
    AppConst.SocketPort = 2012;
    AppConst.SocketAddress = "127.0.0.1";
    networkMgr:SendConnect();

    UIViewer.Init()
    CtrlManager.Init();

    --注册LuaView--
    this.InitViewPanels();

    local szStartView = "View_Ctrl"
    local ctrl = CtrlManager.GetCtrl(szStartView);
    if not ctrl then ErrorException("Game.OnInitOK: nil:", szStartView) end
    ctrl:Init();

    logWarn('LuaFramework InitOK--->>>');

    -- local objRes = newObject(Resources.Load("MazePrefab/Maze Wall")).transform:GetChild(0);
    -- local objRender = objRes:GetComponent("Renderer");
    -- objRender.material = Resources.Load("MazeMaterials/Floor 1");
    -- logWarn(tostring(objRender))
    -- if objRender:GetType() == typeof(UnityEngine.MeshRenderer) then 
    --     logWarn("Sdfsdf")
    -- end
    -- UpdateBeat:Add(this.Update, self)
end

--销毁--
function Game.OnDestroy()
	--logWarn('OnDestroy--->>>');
end
function Game.Update()
    if Input.GetKeyDown(KeyCode.Alpha1)  then
        UIViewer.Show("Layer001")
    elseif Input.GetKeyDown(KeyCode.Alpha2) then
        UIViewer.Show("Layer002")
    elseif Input.GetKeyDown(KeyCode.Alpha3) then
        UIViewer.Show("Layer003")
    elseif Input.GetKeyDown(KeyCode.Alpha4) then
        UIViewer.Show("Layer004")
    elseif Input.GetKeyDown(KeyCode.Alpha5) then
        UIViewer.Show("Layer005")
    elseif Input.GetKeyDown(KeyCode.Alpha6) then
        UIViewer.Show("Prompt001")
    elseif Input.GetKeyDown(KeyCode.Alpha7) then
        UIViewer.Show("UserInterface")
    elseif Input.GetKeyDown(KeyCode.Alpha8) then
        UIViewer.Show("MazePanel")
    end
end