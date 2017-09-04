

_G.CtrlBase = {};

function CtrlBase:New(szPanelCode)
	local obj = {};
	setmetatable(obj,{__index=self});

	obj.szPanelCode = szPanelCode;
	obj.objCtrl = UIViewer.GetCtrl(szPanelCode);
	obj._objRoot = nil;
	local UIBuffer = {};
	obj.UICache = {};
	UIBuffer.__index = function(tab, key)
		local objSub = obj.UICache[key];
		if objSub then return objSub end
		local _objRoot = obj.objCtrl._objRoot;
		if not _objRoot then return end
		objSub = _objRoot.transform:TreeFind(key);
		if not objSub then 
			objSub = _objRoot.transform:Find(key);
			if objSub ~= nil then logWarn("You not Get Sub By TreeTransform ! ! ! !") end
		end
		if not objSub then ErrorException("Can't find SubChild in:", _objRoot.name, key) return end
		return objSub.gameObject;
	end
	UIBuffer.__newindex = function(tab, key, value)
		obj.UICache[key] = value;
	end
	obj.UIBuffer = setmetatable(UIBuffer, UIBuffer);

	CtrlManager.AddCtrl(szPanelCode, obj)
	return obj;
end

function CtrlBase:Init()
	
end


function CtrlBase:OnAfterCreate()
	-- logWarn("CtrlBase:OnAfterCreate is no impl:"..self.szPanelCode)
end

function CtrlBase:BeforeAwake()
	self._objRoot = self.objCtrl._objRoot;
	self:Awake()
end

function CtrlBase:Awake()
	-- logWarn("CtrlBase:OnAfterOnLoaded is no impl:"..self.szPanelCode)
end

function CtrlBase:BeforeOnDestory()
	self._objBehaviour = nil;
	self._objRoot = nil;
	self.UICache = {};
	self:OnDestory();
end

function CtrlBase:OnDestory()
	-- logWarn("CtrlBase:OnAfterUnLoaded is no impl:"..self.szPanelCode)
end

function CtrlBase:OnShow()
	-- logWarn("CtrlBase:OnAfterShow is no impl:"..self.szPanelCode)
end

function CtrlBase:OnHide()
	-- logWarn("CtrlBase:OnAfterHide is no impl:"..self.szPanelCode)
end

function CtrlBase:Show()
	UIViewer.Show(self.szPanelCode)
end

function CtrlBase:Hide()
	UIViewer.Hide(self.szPanelCode)
end

function CtrlBase:IsOpen()
	if self.objCtrl._objRoot == nil then 
		return self.objCtrl._visible;
	end
	return slef.objCtrl._objRoot.activeSelf;
end

function CtrlBase:HideAndShow()
	if not self:IsOpen() then
		self:Show();
	else
		self:Hide();
	end
end

function CtrlBase:HideThenShow()
	if not self:IsOpen() then 
		self:Show();
	end
end

function CtrlBase:AddClick(obj, pfn)
	-- local objLayerCtrl = UIViewer.GetCtrl(self.objCtrl.dwLayer);
	-- if not objLayerCtrl then ErrorException("AddClick LayerCtrl nil:", self.szPanelCode, self.objCtrl.dwLayer) return end
	-- if not objLayerCtrl._objBehaviour then
	-- 	objLayerCtrl._objBehaviour = objLayerCtrl._objRoot.transform:GetComponent('LuaBehaviour');
	-- end
	-- objLayerCtrl._objBehaviour:AddClick(obj.gameObject, pfn)
	-- if not self._objBehaviour then
	-- 	self._objBehaviour = self.objCtrl._objRoot.transform:GetComponent('LuaBehaviour');
	-- end
	-- self._objBehaviour:AddClick(obj.gameObject, pfn)
    EventTriggerListener.Get(obj.gameObject).onPointerClick = EventTriggerListener.Get(obj.gameObject).onPointerClick+pfn;
end
