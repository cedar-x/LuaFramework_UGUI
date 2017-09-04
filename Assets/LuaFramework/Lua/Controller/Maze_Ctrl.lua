
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
			self.UIBuffer.btn_begingame:SetActive(false);
			self.UIBuffer.btn_resetgame:SetActive(true);
			self:SetParam();
		end)
	self:AddClick(self.UIBuffer.btn_resetgame, function()
			self:SetParam();
		end)
	self:AddClick(self.UIBuffer.btn_resetgame, function(obj)
			log("234SDf:", obj.name)
		end)
	self.UIBuffer.btn_resetgame:SetActive(false)
end

function Maze_Ctrl:OnDestory()
	self.UICache = {}
end

function Maze_Ctrl:SetParam()
	local width = tonumber(self.UIBuffer.input_width.text)
	local height = tonumber(self.UIBuffer.input_height.text)
	local doorProb = tonumber(self.UIBuffer.input_doorProb.text)
	local sidenum = 4;

	log("11111:", self.UIBuffer.toggle_quad.isOn)
	log("22222:", self.UIBuffer.toggle_hexagon.isOn)
	log("33333:", self.UIBuffer.radio_otherroom.isOn)
	log("44444:", width, ":", height, ":", doorProb, ":", sidenum)
end
