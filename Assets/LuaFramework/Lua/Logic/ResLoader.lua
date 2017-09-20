
_G.ResLoader = {}
ResLoader.tabReadys = {};
ResLoader.dwIndex = 0;

function ResLoader:NextID()
	self.dwIndex = self.dwIndex + 1;
	return self.dwIndex;
end

function ResLoader:ReadyBundles(bundles, pfnReady)
	if not next(bundles or {}) then ErrorException("ReadyBundles bundles nil:") return end
	
	local tabReady = {};
	tabReady.length = #bundles;
	tabReady.pfnReady = pfnReady;
	tabReady.backNum = 0;

	local dwIndex = self:NextID();
	self.tabReadys[dwIndex] = tabReady;
	for _, abName in pairs(bundles) do 
		resMgr:LoadPrefab(abName, {}, function()
			local requestInfo = self.tabReadys[dwIndex];
			requestInfo.backNum = requestInfo.backNum + 1;
			if requestInfo.backNum >= requestInfo.length then 
				if requestInfo.pfnReady then 
					requestInfo.pfnReady();
					self.tabReadys[dwIndex] = nil;
				end
			end
		end)
	end
end