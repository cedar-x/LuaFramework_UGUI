
function UserInterface_Ctrl:Awake()
	self:AddClick(self.UIBuffer.btn_home, function()
			UIViewer.Show("Prompt001")
		end)
	self:AddClick(self.UIBuffer.btn_play, function()
			UIViewer.Show("MazePanel")
		end)
end

function UserInterface_Ctrl:OnDestory()

end