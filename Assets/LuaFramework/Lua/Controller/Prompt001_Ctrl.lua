
function Prompt001_Ctrl:Awake()
	logWarn("Prompt001_Ctrl:Awake impl:"..self.szPanelCode)
	self.UIBuffer.input_panelname = self.UIBuffer.input_panelname:GetComponent("InputField");
	self.UIBuffer.input_scenename = self.UIBuffer.input_scenename:GetComponent("InputField");

	self.UIBuffer.input_panelname.text = "Prompt002"
	self.UIBuffer.input_scenename.text = "Maze"

	self:AddClick(self.UIBuffer.btn_close, function()
			self:Hide()
		end)
	self:AddClick(self.UIBuffer.btn_open, function()
			UIViewer.Show(self.UIBuffer.input_panelname.text)
		end)
	self:AddClick(self.UIBuffer.btn_closepanel, function()
			UIViewer.Hide(self.UIBuffer.input_panelname.text)
		end)
	self:AddClick(self.UIBuffer.btn_loadscene, function()
			resMgr:LoadScene(self.UIBuffer.input_scenename.text)
		end)

	self.UIBuffer.label_mazestate = self.UIBuffer.label_mazestate:GetComponent("Text");
	self.UIBuffer.label_mazestate.text = "开始"
	self:AddClick(self.UIBuffer.btn_Maze, function()
			if not self.bInitMaze then 
				self.UIBuffer.label_mazestate.text = "重置"
				self.bInitMaze = true
				require "Logic/Maze/Include"
    			MazeManager.Init()
    			MazeManager.StartGame();
	    	else
	    		MazeManager.RestartGame()
	    	end
		end)
end

function Prompt001_Ctrl:OnDestory()
	logWarn("Prompt001_Ctrl:OnDestory impl:"..self.szPanelCode)
end
