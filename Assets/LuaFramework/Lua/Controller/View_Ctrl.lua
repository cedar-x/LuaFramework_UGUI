
--构建函数--
function View_Ctrl:Init()
    logWarn("View_Ctrl:Init:")
    self.dwAwakeNum = 0;
    self.dwLayerNum = 5;

    self:OnInit();
end

function View_Ctrl:OnInit()
    self.dwAwakeNum = 0;
    for i=1, self.dwLayerNum do 
        local szLayerName = 'Layer00'..i;
        UIViewer.Show(szLayerName, function()
                self.dwAwakeNum = self.dwAwakeNum + 1
                if self.dwAwakeNum >= self.dwLayerNum then 
                    self:OnReady()
                end
            end);
    end
end

function View_Ctrl:OnReady()
    logWarn("View_Ctrl:OnReady:Start Open First UI")
    UIViewer.Show("UserInterface");
    -- UIViewer.Show("Prompt001");
end
