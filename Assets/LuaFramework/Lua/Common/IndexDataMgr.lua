
--[[
功能：用于通用Index索引基类
作者：xingxuesong
时间：2017-05-15
]]

--多维表------------------------------------------------
	_G.CacheMutiMap = {}
	function CacheMutiMap:new(deep)
		local obj = {}
		obj.deep = deep
		obj.data = {}
		setmetatable(obj,{ __index = self })
		return obj
	end
	function CacheMutiMap:Get(...)
		local arg = {...}
		local des = self.data
		for i = 1,self.deep do
			local idx = arg[i]
			des = des[idx]
			if not des then break end
		end
		return des
	end
	function CacheMutiMap:Set(...) 
		local arg = {...}
		local des = self.data
		for i = 1,self.deep - 1 do
			local idx = arg[i]
			des[idx] = des[idx] or {}
			des = des[idx]
		end
		des[arg[self.deep]] = arg[self.deep + 1]
	end
	function CacheMutiMap:Iterator(fn,i,des)
		i = i or self.deep
		des = des or self.data
		if i == 1 then
			for k,v in pairs(des) do
				fn(v)
			end
		elseif i > 1 then
			for k,v in pairs(des) do
				self:Iterator(fn,i-1,v)
			end
		end
	end

_G.IndexDataMgr = object();

function IndexDataMgr:constructor(...)
	self.tabIndex = {};
	local dwDepth = 0;
	for i, v in pairs({...}) do 
		dwDepth = dwDepth + 1;
		table.insert(self.tabIndex, v);
	end
	self.tabDataMap = CacheMutiMap:new(dwDepth);
	self.tabDataList = {}
end

function IndexDataMgr:New()
	local obj = {};
	obj.tabDataMap = {};

	setmetatable(obj, {__index=self})
	return obj;
end

function IndexDataMgr:Init(objData)
	setmetatable(objData, {__index=self})
	return objData;
end

function IndexDataMgr:Add(objData)
	local tabArgv = {};
	for i, v in pairs(self.tabIndex) do 
		table.insert(tabArgv, objData[v])
	end
	table.insert(tabArgv, objData);
	self.tabDataMap:Set(unpack(tabArgv))
	self:SetDataList(objData);
	return objData;
end

function IndexDataMgr:Get(...)
	local objData = self.tabDataMap:Get(...)
	return objData;
end

function IndexDataMgr:Del(...)
	local objData = self.tabDataMap:Get(...)
	if not objData then return end
	self.tabDataMap:Set(...)
	self:DelDataList(objData)
	return objData;
end

function IndexDataMgr:GetDataMap()
	return self.tabDataMap;
end

function IndexDataMgr:SetDataList(objData) end
function IndexDataMgr:DelDataList(objData) end