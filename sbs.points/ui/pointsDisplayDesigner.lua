local addon, ns = ...
local builder = ns.lib.builder

local OFFSET = 5
local core = sbsLib

local config = {
	name = "sbsPoints",
	parent = "UIParent",
	background = true,
	width = 350,
	height = 400,
	anchors =  {
		{"LEFT", "UIParent", "LEFT", 15, -200} ,
	},
	children = {
		{
			name = "$parent$Options",
			border = true,
			background = true,
			height = 25,
			anchors = {
				{"TOPLEFT", "$parent$", "TOPLEFT", 0, 0},
				{"TOPRIGHT", "$parent$", "TOPRIGHT", 0, 0},
			}, 
			children = {
				{
					name = "$parent$Refresh",
					type = "button",
					border = true,
					background = true,
					width = 18,
					height = 18,
					anchors = {
						{"LEFT", "$parent$", "LEFT", OFFSET, 0},
					}
				},
				{
					name = "$parent$Close",
					type = "button",
					border = true,
					background = true,
					width = 18,
					height = 18,
					anchors = {
						{"RIGHT", "$parent$", "RIGHT", -OFFSET, 0},
					}
				}
			}
		},  
		{
			name = "$parent$TableHeader",
			border = true,
			background = true,
			height = 15,
			anchors = {
				{"TOPLEFT", "$parent$Options", "BOTTOMLEFT", 0, -OFFSET},
				{"TOPRIGHT", "$parent$Options", "BOTTOMRIGHT", 0, -OFFSET},
			}
		},
		{
			name = "$parent$Table",
			type = "scroll",
			border = true,
			background = true,
			anchors = {
				{"TOPLEFT", "$parent$TableHeader", "BOTTOMLEFT", 0, -OFFSET},
				{"TOPRIGHT", "$parent$TableHeader", "BOTTOMRIGHT", 0, -OFFSET},
				{"BOTTOM", "$parent$", "BOTTOM", 0, 0},
			} 
		}
	}
	
	
}

local row = {
	height = 15,
	children = {
		{
			name = "$parent$Name",
			type = "font",
			anchors = {
				{"LEFT", "$parent$", "LEFT", 5, 0},
			}
		},
		{
			name = "$parent$Class",
			type = "font",
			anchors = {
				{"LEFT", "$parent$", "LEFT", 85, 0},
			}
		},
		{
			name = "$parent$Spec",
			type = "font",
			anchors = {
				{"LEFT", "$parent$", "LEFT", 165, 0},
			},
		},
		{
			name = "$parent$Points",
			type = "font",
			anchors = {
				{"LEFT", "$parent$", "LEFT", 245, 0},
			},
		}
	}  
}

local designer = {}

designer.newRow = function(name, parent)
	return builder.create(row, name, parent)
end

designer.newDisplay = function()

	local display = builder.create(config)
	local rowHeader = designer.newRow("$parent$Row", display.TableHeader)
	rowHeader:SetAllPoints(display.TableHeader)

	rowHeader.Name:SetText("Name")
	rowHeader.Class:SetText("Class")
	rowHeader.Spec:SetText("Spec")
	rowHeader.Points:SetText("Points")

	return display

end

ns.pointsDisplayDesigner = designer
