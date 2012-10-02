local addon, ns = ...


local parseName = function(original, replacement)
	return string.gsub(original,"%$parent%$", replacement or '')
end


local handlers = {
	width = function(self,config, value) 
		self:SetWidth(value)
	end,
	
	height = function(self, config, value) 
		self:SetHeight(value)
	end,
	
	anchors = function(self, config, value) 
	
		for i, anchor in ipairs(value) do			
			
			local point, target, targetPoint, x, y = unpack(anchor)
			target = parseName(target, config.parentName)
			
			self:SetPoint(point, target, targetPoint, x, y)
			
		end
	
	end,
	
	background = function(self, config, value)
		
		local texture = value[1]
		local color = value[2]
		
		local bg = CreateFrame("Frame", nil, self)
		
		bg:SetAllPoints(self)
		bg:SetFrameLevel(1)
		bg:SetFrameStrata(self:GetFrameStrata())
		bg:SetBackdrop( { 
			bgFile = texture,
			edgeSize = 0,
			tile = true,
		})
		
		bg:SetBackdropColor(unpack(color))
		
		self.bg = bg
	
	end,
	
	border = function(self, config, value)
	
		local texture = value[1]
		local color = value[2]
		local offset = 3		
		
		
		local shadow = CreateFrame("Frame", nil, self)
		
		shadow:SetFrameLevel(1)
		shadow:SetFrameStrata(self:GetFrameStrata())
		
		shadow:SetPoint("TOPLEFT", -offset, offset)
		shadow:SetPoint("BOTTOMLEFT", -offset, -offset)
		shadow:SetPoint("TOPRIGHT", offset, offset)
		shadow:SetPoint("BOTTOMRIGHT", offset, -offset)
		
		shadow:SetBackdrop( { 
			edgeFile = texture, 
			edgeSize = offset,
			insets = {
				left = 5, 
				right = 5, 
				top = 5, 
				bottom = 5
			},
		})
		
		shadow:SetBackdropColor(0, 0, 0, 0)
		shadow:SetBackdropBorderColor(unpack(color))
		self.shadow = shadow
	
	end,

	text = function(self, config, value)

		if self.SetText then
			self:SetText(value)
		end

	end,

}

local UiBuilder = {}

UiBuilder.create = function(config, name)
	
	local frameName = name or config.name 
	local frameType = config.type or "Frame"
	local frameParent = config.parent or "UIParent"
	
	if type(frameParent) == "string" then
		frameParent = _G[frameParent]	
	end
	
	config.parentName = frameParent:GetName()
	
	local frame = CreateFrame(frameType, frameName, frameParent)
	
	for key, value in pairs(config) do
	
		if handlers[key] then
			handlers[key](frame, config, value)
		end
	
	end
	
	frame.children = {}
	
	for i, childConfig in ipairs(config.children or {}) do
	
		local plainName = parseName(childConfig.name)

		childConfig.name = frameName .. plainName
		childConfig.parent = frame
		childConfig.parentName = frameName
		
		local subFrame = UiBuilder.create(childConfig)

		frame.plainName = subFrame
		frame.children[i] = subFrame
		
	end
	
	return frame
	
end
