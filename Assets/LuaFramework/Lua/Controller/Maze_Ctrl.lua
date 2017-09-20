
function Maze_Ctrl:Awake()

	self.UIBuffer.input_width = self.UIBuffer.input_width:GetComponent("InputField")
	self.UIBuffer.input_height = self.UIBuffer.input_height:GetComponent("InputField")
	self.UIBuffer.input_doorProb = self.UIBuffer.input_doorProb:GetComponent("InputField")
	self.UIBuffer.toggle_quad = self.UIBuffer.toggle_quad:GetComponent("Toggle");
	self.UIBuffer.toggle_hexagon = self.UIBuffer.toggle_hexagon:GetComponent("Toggle");
	self.UIBuffer.radio_otherroom = self.UIBuffer.radio_otherroom:GetComponent("Toggle");

	self:AddClick(self.UIBuffer.btn_close, function()
			self:Hide();
		end)
	self:AddClick(self.UIBuffer.btn_begingame, function()
			self:SetParam();
			self:Hide()
		end)

	self.UIBuffer.btn_resetgame:SetActive(false)
	self.UIBuffer.input_doorProb.text = "0.1"
end

function Maze_Ctrl:OnDestory()
end

function Maze_Ctrl:SetParam()
	local width = tonumber(self.UIBuffer.input_width.text)
	local height = tonumber(self.UIBuffer.input_height.text)
	local doorProb = tonumber(self.UIBuffer.input_doorProb.text)
	local sidenum = 4;

	require "Logic/Maze/Include"

	MazeManager.resetting(width, height, doorProb, self.UIBuffer.radio_otherroom.isOn)
	ResLoader:ReadyBundles(MazeManager.LoadBundles, function()
			MazeManager.StartGame();
		end)
end
