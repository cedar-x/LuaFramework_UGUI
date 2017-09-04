require "Common/define"
require "Controller/CtrlBase"


CtrlManager = {};
local this = CtrlManager;
local ctrlList = {};	--控制器列表--

function CtrlManager.Init()
	logWarn("CtrlManager.Init----->>>");
	for i, v in pairs(UIPanelConfig) do 
		if v.controlSystem then 
			_G[v.controlSystem] = CtrlBase:New(v.szPanelCode);
			-- this.AddCtrl(v.szPanelCode, _G[v.controlSystem])
			this.AddCtrl(v.controlSystem, _G[v.controlSystem])
		end
	end
	return this;
end

--添加控制器--
function CtrlManager.AddCtrl(ctrlName, ctrlObj)
	ctrlList[ctrlName] = ctrlObj;
end

--获取控制器--
function CtrlManager.GetCtrl(ctrlName)
	return ctrlList[ctrlName];
end

--移除控制器--
function CtrlManager.RemoveCtrl(ctrlName)
	ctrlList[ctrlName] = nil;
end

--view控制回调--
function CtrlManager.RemoteInvoke(ctrlName, funcName, ...)
	local ctrlSys = this.GetCtrl(ctrlName);
	if not ctrlSys then ErrorException("CtrlManager.RemoteInvoke nil:", ctrlName) return end
	local b,err = pcall(ctrlSys[funcName] ,ctrlSys, ...);
	if b == false then
		ErrorException(string.format("%s call %s Failed %s", ctrlName, funcName, err));
	end
end

--关闭控制器--
function CtrlManager.Close()
	logWarn('CtrlManager.Close---->>>');
end