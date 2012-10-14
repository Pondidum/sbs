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
	ctrl = function() return IsControlKeyDown() end,
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

		local button = ns.uiBuilder.create(config)
		local actions = { default = {} }
		local degrees = 0

		setmetatable(actions, ns.defaultKeyMeta)

		button:SetToplevel(true)
		button:EnableMouse(true)
		button:SetMovable(true)
		

		button:RegisterForClicks("AnyUp")
		button:RegisterForDrag("LeftButton", "RightButton")
		
		local setPosition = function()

			local xCalc = 52 - (80 * cos(degrees))
			local yCalc = (80 * sin(degrees)) - 52

			button:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", xCalc, yCalc)
		end

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

			degrees = math.deg(math.atan2(ypos,xpos))

 			ns.userSettings.set("minimapDegrees", degrees)
		  	setPosition()

		end
		
		local buttonOnClick = function(self, button, down) 
			
			local mod = getModifer()
			local action = actions[button][mod]

			if action then
				action()
			end

		end

		button.Drag:SetScript("OnUpdate", dragOnUpdate)
		button:SetScript("OnDragStart", buttonOnDragStart)
		button:SetScript("OnDragStop", buttonOnDragStop)
		button:SetScript("OnClick", buttonOnClick)

		local this = {}

		this.addAction = function(button, modifier, action)

			if not actions[button] then
				actions[button] = {}
			end

			if modifier == nil or modifier == "" then
				modifier = "default"
			end

			actions[button][modifier] = action

		end

		ns.userSettings.onLoad(function() 
			degrees = ns.userSettings.get("minimapDegrees") or 0
			setPosition()
		end)

		return this

	end,
  
}

ns.minimap = MiniMapIcon.new()