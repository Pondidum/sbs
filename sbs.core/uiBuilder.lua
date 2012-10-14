local addon, ns = ...
local media = ns.media

local parseName = function(original, replacement)
	return string.gsub(original,"%$parent%$", replacement or '')
end


local creationHandlers = {
	
	default = function(frameType, frameName, frameParent, frameInherit)

		return CreateFrame(frameType, frameName, frameParent, frameInherit)

	end,

	font = function(frameType, frameName, frameParent, frameInherit)

		local f = frameParent:CreateFontString(frameName, "OVERLAY")
		
		f:SetFont(media.fonts.normal, 12)

		return f

	end,

	scroll = function(frameType, frameName, frameParent, frameInherit)

		local parent = CreateFrame("ScrollFrame", frameName, frameParent)
		parent:EnableMouseWheel(true)

		local bar = CreateFrame("Slider", nil, parent, "UIPanelScrollBarTemplate")
		bar:SetOrientation("VERTICAL")
		bar:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, -16)
		bar:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 16)
		bar:SetValue(0)

		bar:SetScript("OnValueChanged", function(self)
		    parent:SetVerticalScroll(self:GetValue())
		end)

		parent:SetScript("OnMouseWheel", function(self, delta)
		    bar:SetValue(bar:GetValue()- (20 * delta))
		end)

		local child = CreateFrame("Frame", nil, parent)
		child:SetSize(parent:GetWidth() - bar:GetWidth() -2, parent:GetHeight())
		parent:SetScrollChild(child)


		local PADDING = 5

		parent.populate = function(frames)

			local totalHeight = 0

			local prev
			for i, frame in ipairs(frames) do

				frame:SetParent(child)
				frame:ClearAllPoints()
				frame:SetPoint("LEFT", child, "LEFT", 0, 0)
				frame:SetPoint("RIGHT", child, "RIGHT", 0, 0)

				if i == 1 then
					frame:SetPoint("TOP", child, "TOP", 0, 0)
				else
					frame:SetPoint("TOP", prev, "BOTTOM", 0, - PADDING)
				end

				totalHeight = totalHeight + frame:GetHeight() + PADDING

				prev = frame
			end

			totalHeight = totalHeight - PADDING

			child:SetHeight(totalHeight)
			child:SetWidth(parent:GetWidth() - bar:GetWidth() -2)
			
			bar:SetMinMaxValues(0, child:GetHeight() - parent:GetHeight())

		end

		return parent

	end,

}

local attributeHandlers = {

	default = function(self, config, value)
		-- does nothing!
	end,

	width = function(self, config, value) 
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
		
		local texture, color

		if type(value) == "table" then
			texture = value[1]
			color = value[2]
		else
			texture = media.textures.background
			color = media.colors.background
		end 

		
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
	
		
		local texture, color

		if type(value) == "table" then
			texture = value[1]
			color = value[2]
		else
			texture = media.textures.shadow
			color = media.colors.shadow
		end 

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

	font = function(self, config, value)

		if self.SetFont then

			

			local fontName, fontSize

			if type(value) == "table" then
				fontName = value[1]
				fontSize = value[2]
			else
				fontName = media.fonts.normal
				fontSize = 12
			end

			self:SetFont(fontName, fontSize)

		end

	end

}

setmetatable(creationHandlers, ns.defaultKeyMeta)
setmetatable(attributeHandlers, ns.defaultKeyMeta)

local UIBuilder = {}

UIBuilder.create = function(config, name, parent)
	
	local config = table.clone(config)	-- the ui builder is destructive on a config.

	local frameName = name or config.name 
	local frameType = config.type or "Frame"
	local frameParent = parent or config.parent or "UIParent"
	local frameInherit = config.inherits or nil

	
	if type(frameParent) == "string" then
		frameParent = _G[frameParent]	
	end
	
	config.parentName = frameParent:GetName()
	
	local frame = creationHandlers[frameType](frameType, frameName, frameParent, frameInherit)

	for key, value in pairs(config) do
		attributeHandlers[key](frame, config, value)
	end
	
	frame.children = {}
	
	for i, childConfig in ipairs(config.children or {}) do
	
		local plainName = parseName(childConfig.name)

		childConfig.name = frameName .. plainName
		childConfig.parent = frame
		childConfig.parentName = frameName
		
		local subFrame = UIBuilder.create(childConfig)

		frame[plainName] = subFrame
		frame.children[i] = subFrame
		
	end
	
	return frame
	
end

ns.uiBuilder = UIBuilder