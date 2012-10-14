local addon, ns = ...

local config = {
	name = "sbsCoreMinimap",
	type = "button",
	parent = "Minimap",
	width = 33,
	height = 33,
	highlighttexture = "Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight",
	anchors = {
		{"TOPLEFT", "$parent$", "TOPLEFT", 0, 0},
	},
	children = {
		{
			name = "$parent$Icon",
			type = "texture",
			layer = "ARTWORK",
			texture = "Interface\\Icons\\INV_Misc_QuestionMark",
			texturecoord = {0.075, 0.925, 0.075, 0.925},
			width = 21,
			height = 21,
			anchors = {
				{"TOPLEFT", "$parent$", "TOPLEFT", 7, -6}
			}
		},
		{
			name = "$parent$Border",
			type = "texture",
			layer = "OVERLAY",
			texture = "Interface\\Minimap\\MiniMap-TrackingBorder",
			width = 56,
			height = 56,
			anchors = {
				{"TOPLEFT", "$parent$", "TOPLEFT", 0, 0},
			},
		},
		{
			name = "$parent$Drag",
			visible = false,
		},

	}

}

local modifiers = {
	
	default = function() return true end,
	shift = function() return IsShiftKeyDown() end,
	ctrl = function() return IsControlKeyDown end,
	alt = function() return IsAltKeyDown() end,
}

setmetatable(modifiers, ns.defaultKeyMeta)

local getModifer = function()

	for k,v in pairs(modifiers) do
		if v() then
			return k
		end
	end

	return "default"

end

local MiniMapIcon = {
  
	new = function() 

		local this = {}
		local button = ns.uiBuilder.create(config)
		local actions = { default = {} }

		setmetatable(actions, ns.defaultKeyMeta)

		button:SetToplevel(true)
		button:EnableMouse(true)
		button:SetMovable(true)
		

		button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		button:RegisterForDrag("LeftButton", "RightButton")
		
		local buttonOnDragStart = function()
			button:LockHighlight()
			button.Drag:Show()
		end
		
		local buttonOnDragStop = function()
			button:UnlockHighlight()
			button.Drag:Hide()
		end
		
		local dragOnUpdate = function()
		  
			local xpos, ypos = GetCursorPosition()
			local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()

			xpos = xmin - xpos / UIParent:GetScale() + 70            --minimap center
			ypos = ypos / UIParent:GetScale() - ymin - 70

			local degrees = math.deg(math.atan2(ypos,xpos))

			local xCalc = 52 - (80 * cos(degrees))
			local yCalc = (80 * sin(degrees)) - 52

			button:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", xCalc, yCalc)
		  
		end
		
		local buttonOnClick = function(self, button, down) 
			
			local action = actions[button][getModifer()]

			if action then
				action()
			end

		end
		
		button.Drag:SetScript("OnUpdate", dragOnUpdate)
		button:SetScript("OnDragStart", buttonOnDragStart)
		button:SetScript("OnDragStop", buttonOnDragStop)
		button:SetScript("OnClick", buttonOnClick)


		this.addAction = function(button, modifier, action)

			if not action[button] then
				action[button] = {}
			end

			if modifier == nil or modifier == "" then
				modifier = "default"
			end

			action[button][modifier] = action

		end

	end,
  
}
MiniMapIcon.new()