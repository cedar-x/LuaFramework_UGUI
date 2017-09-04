
local function formatlog(tabLog)
	for i, v in pairs(tabLog) do 
		tabLog[i] = tostring(v);
	end
	return table.concat(tabLog)
end

--输出日志--
function log(...)
    Util.Log(formatlog({...}));
end

--错误日志--
function logError(...) 
	Util.LogError(formatlog({...}));
end

--警告日志--
function logWarn(...) 
	Util.LogWarning(formatlog({...}));
end

-- 异常堆栈日志
function ErrorException(...)
	local strError = {};
	for i, v in pairs({...}) do 
		table.insert(strError,"["..i..":"..tostring(v).."]")
	end
	table.insert(strError,"[End]")
	logWarn(debug.traceback(table.concat(strError)));
end

--查找对象--
function find(str)
	return GameObject.Find(str);
end

function destroy(obj)
	GameObject.Destroy(obj);
end

function newObject(prefab)
	return GameObject.Instantiate(prefab);
end

--创建面板--
function createPanel(name)
	PanelManager:CreatePanel(name);
end

function child(str)
	return transform:FindChild(str);
end

function subGet(childNode, typeName)		
	return child(childNode):GetComponent(typeName);
end

function findPanel(str) 
	local obj = find(str);
	if obj == nil then
		error(str.." is null");
		return nil;
	end
	return obj:GetComponent("BaseLua");
end