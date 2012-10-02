local addon, ns = ...
local builder = ns.lib.builder

local config = {
	name = "BidMaster",
	width = 600,
	height = 600,
	anchors = {
		{"RIGHT", "UIParent", "RIGHT", -40, 0},
	},
	children = {
		{
			name = "$parent$LoadLoot",
			type = "Button",
			width = 50,
			height = 25,
			text = "Load Loot",
			anchors = {
				{"TOPLEFT", "$parent$", "TOPLEFT", 5, 5},
			}
		},
		{
			name = "$parent$AddLoot",
			type = "Button",
			width = 50,
			height = 25,
			text = "Add Loot",
			anchors = {
				{"LEFT", "$parent$LoadLoot", "RIGHT", 5, 0},
			}
		},
		{
			name = "$parent$CloseLoot",
			type = "Button",
			width = 50,
			height = 25,
			text = "Close Loot",
			anchors = {
				{"LEFT", "$parent$AddLoot", "RIGHT", 5, 0},
			}
		},
		{
			name = "$parent$LootList",
			type = "ScrollFrame",
			width = 150,
			anchors = {
				{"TOPLEFT", "$parent$LoadLoot", "BOTTOMLEFT", 5, 5},
				{"BOTTOMLEFT", "$parent$", "BOTTOMLEFT", 5, 5}
			},
		},
		{
			name = "$parent$LootDetails",
			anchors = {
				{"TOPLEFT", "$parent$LootList", "TOPRIGHT", 5, 5},
				{"BOTTOMRIGHT", "$parent$", "BOTTOMRIGHT", 5, 5}	
			},
			children = {
				{ name = "$parent$NameLabel", type = "fontstring" },
				{ name = "$parent$NameValue", type = "fontstring" },
			},
		},	
	},
}

local BidMasterDesigner = {
	
	new = function()
		return builder.create(config)
	end,

}