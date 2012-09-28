local addon, ns = ...


local parseName = function(original, replacement)
  return string.gsub(original,"%$parent%$", replacement)
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
  
  
}

local UiBuilder = {}

UiBuilder.create = function(config)
  
  local name = config.name 
  local parent = config.parent
  
  if type(parent) == "string" then
    parent = _G[parent]  
  end
  
  config.parentName = parent:GetName()
  
  local frame = CreateFrame("Frame", config.name, parent)
  
  for key, value in pairs(config) do
    
    if handlers[key] then
      handlers[key](frame, config, value)
    end
    
  end
  
  frame.children = {}
  
  for i, child in ipairs(config.children or {}) do
    
    child.name = parseName(child.name, name)
    child.parent = frame
    child.parentName = name
    
    table.insert(frame.children, UiBuilder.create(child))
    
  end
  
  return frame
  
end

ns.uiBuilder = UiBuilder
