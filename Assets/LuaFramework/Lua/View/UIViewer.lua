
--[[
btn			（按钮：可点）
icon		（图标：不可点、非点击主体、图案部件） 
sign		（标记）
list		（列表） 
menu		（菜单）
view		（视图）
panel		（面板）
sheet		（薄板：底部弹出菜单）
bar			（栏）
statusbar	（状态栏）
navibar		（导航栏）
toolbar		（工具栏）
switch		（切换开关）
slider		（滑动器） 
radio		（单选框） 
check		（复选框） 
bg			（背景） 
mask		（蒙板、遮罩）
--]]


_G.UIViewer = {}
local this = UIViewer;

local function GetResouceName( szPanelCode )
	local tabInfo = UIPanelConfig[szPanelCode]
	if not tabInfo then ErrorException("Panel Code nil in UIPanelConfig:", szPanelCode) return end
	return tabInfo.szBundleName.."."..tabInfo.szResName
end

local function GetPanelName( szPanelCode )
	local tabInfo = UIPanelConfig[szPanelCode]
	if not tabInfo then ErrorException("Panel Code nil in UIPanelConfig:", szPanelCode) return end
	local assertName = tabInfo.szPanelName or tabInfo.szResName;
	return tabInfo.szBundleName.."."..assertName
end

function UIViewer.Init()
	this._objPanelMgr = IndexDataMgr:instance("szPanelCode");
	for i, v in pairs(UIPanelConfig) do 
		local objCtrl = {};
		local szPanelCode = v.szPanelCode;
		objCtrl.szPanelCode = szPanelCode;
		objCtrl.szResName = GetResouceName(szPanelCode)
		objCtrl.szPanelName = GetPanelName(szPanelCode)
		objCtrl.dwLayer = v.dwLayer;

		objCtrl.__visible = false;
		objCtrl._objRoot = nil;
		objCtrl._bLoading = nil;

		this._objPanelMgr:Add(objCtrl)
	end
	Event.AddListener("ViewShow", this.EventViewShow)
end

function UIViewer.Show(szPanelCode, pfn)
	local objCtrl = this._objPanelMgr:Get(szPanelCode);
	if not objCtrl then ErrorException("PanelCtrl nil:", szPanelCode) return end
	if objCtrl._visible == true then 
		return
	end
	objCtrl._visible = true;
	objCtrl._bLoading = true;
	local szResName = GetResouceName(szPanelCode);
	panelMgr:CreatePanel(szResName, function(obj)
			local objCtrl = this._objPanelMgr:Get(szPanelCode);
			obj.name = objCtrl.szPanelName

			objCtrl._bLoading = false;
			objCtrl._visible = true;
			objCtrl._objRoot = obj;

			local panel_clone = obj.transform:Find("panel_clone");
			if panel_clone then panel_clone.gameObject:SetActive(false) end

			if pfn then pfn(obj) end
			local objLayerCtrl = this._objPanelMgr:Get(objCtrl.dwLayer)
			if objLayerCtrl ~= nil then 
				obj.transform:SetParent(objLayerCtrl._objRoot.transform);
			end

			CtrlManager.RemoteInvoke(szPanelCode, "BeforeAwake")
		end)
end

function UIViewer.Hide(szPanelCode)
	local objCtrl = this._objPanelMgr:Get(szPanelCode);
	if not objCtrl then ErrorException("PanelCtrl nil:", szPanelCode) return end
	if objCtrl._visible == false then 
		return
	end

	objCtrl._bLoading = false;
	objCtrl._visible = false;
	objCtrl._objRoot = nil;
	local objLayerCtrl = this.GetCtrl(objCtrl.dwLayer);
	panelMgr:ClosePanel(objLayerCtrl.szPanelName..'/'..objCtrl.szPanelName)

	CtrlManager.RemoteInvoke(szPanelCode, "BeforeOnDestory")
end

function UIViewer.GetCtrl(szPanelCode)
	local objCtrl = this._objPanelMgr:Get(szPanelCode);
	if not objCtrl then ErrorException("UIViewer.GetCtrl objCtrl nil:", szPanelName) return end

	return objCtrl
end

function UIViewer.EventViewShow(...)
	logWarn("UIViewer.EventViewShow:", ...)
end
