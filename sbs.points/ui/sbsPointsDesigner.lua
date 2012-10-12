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
    },  
    {
      name = "$parent$TableHeader",
      border = true,
      background = true,
      height = 15,
      anchors = {
        {"TOPLEFT", "$parent$Options", "BOTTOMLEFT", 0, -OFFSET},
        {"TOPRIGHT", "$parent$Options", "BOTTOMRIGHT", 0, -OFFSET},
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
          },
        }
      },
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


local f = _G["sbsPoints"] or core.builder.create(config)

local frame = core.builder.create(row, "$parent$Row", f.TableHeader)
frame:SetAllPoints(f.TableHeader)

frame.Name:SetText("Name")
frame.Class:SetText("Class")
frame.Spec:SetText("Spec")
frame.Points:SetText("Points")


local data = {}

sbsLib.guildRoster.loadPoints(sbmLib.config.guildRanks, nil)

for i, player in ipairs(sbsLib.guildRoster.listPlayerData()) do
  
  local frame = core.builder.create(row, "Player"..i, f.Table:GetName())  
  
  frame.Name:SetText(player.name)
  frame.Class:SetText(player.class)
  frame.Spec:SetText(player.spec)
  frame.Points:SetText(player.points)
  
  local color = RAID_CLASS_COLORS[player.classFile]
  
  if color == nil then
    color = { r=1,g=1,b=1}
  end
  
  frame.Name:SetTextColor(color.r, color.g, color.b)
  
  data[i] = frame
  
end

f.Table.populate(data)