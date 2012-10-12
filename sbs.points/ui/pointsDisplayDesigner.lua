local addon, ns = ...

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

ns.pointsDisplayDesigner = {

  new = function()
  
    return ns.lib.builder.create(config)

  end,

}
