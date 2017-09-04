
--协议类型--
ProtocalType = {
	BINARY = 0,
	PB_LUA = 1,
	PBC = 2,
	SPROTO = 3,
}
--当前使用的协议类型--
TestProtoType = ProtocalType.BINARY;

Util = LuaFramework.Util;
AppConst = LuaFramework.AppConst;
LuaHelper = LuaFramework.LuaHelper;
ByteBuffer = LuaFramework.ByteBuffer;

Resources = UnityEngine.Resources;
Input = UnityEngine.Input;
KeyCode = UnityEngine.KeyCode;

resMgr = LuaHelper.GetResManager();
panelMgr = LuaHelper.GetPanelManager();
soundMgr = LuaHelper.GetSoundManager();
networkMgr = LuaHelper.GetNetManager();

poolMgr = PathologicalGames.SpawnPoolsDict.New();
prefabPool = PathologicalGames.PrefabPool;

WWW = UnityEngine.WWW;
GameObject = UnityEngine.GameObject;
EventTriggerListener = LuaFramework.EventTriggerListener;
