local addon, ns = ...


local f = ns.pointsDisplayDesigner.new()

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